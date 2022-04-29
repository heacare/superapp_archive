import 'dart:math';

import 'package:flutter/material.dart'
    show Color, BuildContext, Navigator, MaterialPageRoute, TimeOfDay;
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:hea/screens/sleep_checkin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hea/services/service_locator.dart';
import 'package:hea/services/logging_service.dart';
import 'package:hea/widgets/page.dart';

import 'package:hea/pages/sleep/lookup.dart';

class NotificationService {
  final AwesomeNotifications notifications;
  final FirebaseMessaging messaging;

  NotificationService({required this.notifications, required this.messaging});

  Future<void> cancelAllSchedules() async {
    notifications.cancelAllSchedules();
  }

  Future<void> cancelSchedulesByChannelKey(String channelKey) async {
    notifications.cancelSchedulesByChannelKey(channelKey);
  }

  Future<void> showSimpleReminder(
    int id,
    String channelKey,
    String title,
    String body,
    TimeOfDay timeOfDay,
  ) async {
    NotificationSchedule? schedule = NotificationCalendar(
      repeats: true,
      era: 1,
      hour: timeOfDay.hour % 24,
      minute: timeOfDay.minute % 60,
      second: 0,
    );
    if (kDebugMode) {
      schedule = NotificationCalendar(
        repeats: true,
        era: 1,
        minute: timeOfDay.hour % 60,
        second: 0,
      );
    }
    notifications.createNotification(
        schedule: schedule,
        content: NotificationContent(
          id: id,
          channelKey: channelKey,
          category: NotificationCategory.Reminder,
          title: title,
          body: body,
          notificationLayout: NotificationLayout.BigText,
        ));
  }

  Future<void> showDailyReminder(
    int id,
    String channelKey,
    String title,
    String body,
    TimeOfDay timeOfDay, {
    String action = "Let's go",
    Map<String, String>? payload,
    String remindAction = "Remind me later",
  }) async {
    NotificationSchedule? schedule = NotificationCalendar(
      repeats: true,
      era: 1,
      hour: timeOfDay.hour % 24,
      minute: timeOfDay.minute % 60,
      second: 0,
    );
    if (kDebugMode) {
      schedule = NotificationCalendar(
        repeats: true,
        era: 1,
        minute: timeOfDay.hour % 60,
        second: 0,
      );
    }
    notifications.createNotification(
        schedule: schedule,
        content: NotificationContent(
          id: id,
          channelKey: channelKey,
          category: NotificationCategory.Reminder,
          title: title,
          body: body,
          payload: payload,
          notificationLayout: NotificationLayout.BigText,
        ),
        actionButtons: [
          NotificationActionButton(
            buttonType: ActionButtonType.Default,
            key: "continue",
            label: action,
          ),
        ]);
  }

  Future<void> showContentReminder(
    int id,
    String channelKey,
    String title,
    String body, {
    String action = "Continue",
    Map<String, String>? payload = const {"jump_to": "sleep_content"},
    String remindAction = "Remind me later",
    int minHoursLater = 0,
  }) async {
    NotificationSchedule? schedule;
    if (minHoursLater > 0) {
      DateTime later = DateTime.now().add(Duration(hours: minHoursLater));
      if (later.hour < 7) {
        // Ensure arrives after 7am
        later = DateTime(later.year, later.month, later.day, 8);
      } else if (later.hour >= 22) {
        // Ensure arrives before 10pm
        later = later.add(const Duration(days: 1));
        later = DateTime(later.year, later.month, later.day, 8);
      }
      schedule = NotificationCalendar(
        era: 1,
        year: later.year,
        month: later.month,
        day: later.day,
        hour: later.hour,
        minute: 0,
        second: 0,
      );
      if (kDebugMode) {
        later = DateTime.now().add(Duration(minutes: minHoursLater));
        schedule = NotificationCalendar(
          era: 1,
          year: later.year,
          month: later.month,
          day: later.day,
          hour: later.hour,
          minute: later.minute,
          second: 0,
        );
      }
    }
    notifications.createNotification(
        schedule: schedule,
        content: NotificationContent(
          id: id,
          channelKey: channelKey,
          category: NotificationCategory.Reminder,
          title: title,
          body: body,
          payload: payload,
          notificationLayout: NotificationLayout.BigText,
        ),
        actionButtons: [
          NotificationActionButton(
            buttonType: ActionButtonType.Default,
            key: "continue",
            label: action,
          ),
          /*
          NotificationActionButton(
            buttonType: ActionButtonType.KeepOnTop,
            key: "remind-later",
            label: remindAction,
          ),
		  */
        ]);
  }

  BuildContext? context;

  Future<void> _recieved(ReceivedNotification receivedNotification) async {
    debugPrint("${receivedNotification.id}");
    debugPrint("${receivedNotification.payload}");
    if (receivedNotification is ReceivedAction) {
      debugPrint(receivedNotification.buttonKeyPressed);
      return;
    }
    if (receivedNotification.payload == null) {
      return;
    }
    String jumpTo = receivedNotification.payload!["jump_to"] ?? "";
    if (jumpTo == "sleep_content") {
      String? s = serviceLocator<SharedPreferences>().getString('sleep');
      PageBuilder resume = sleep.lookup(s);
      serviceLocator<LoggingService>().createLog('notification-navigate', s);
      Navigator.of(context!)
          .push(MaterialPageRoute(builder: (context) => resume()));
    } else if (jumpTo == "sleep_checkin") {
      Navigator.of(context!)
          .push(MaterialPageRoute(builder: (context) => const SleepCheckin()));
    }
  }

  bool actionStreamAttached = false;
  void ensureListen(BuildContext context) {
    this.context = context;
    if (!actionStreamAttached) {
      notifications.actionStream.listen(_recieved);
      actionStreamAttached = true;
    }
  }

  Future<void> showPreferences() async {
    await notifications.showNotificationConfigPage();
  }

  static Future<NotificationService> create() async {
    const primaryColor = Color(0xFFFA6E78);

    AwesomeNotifications notifications = AwesomeNotifications();
    notifications.initialize(
        "resource://drawable/notification_icon",
        [
          NotificationChannel(
              channelGroupKey: "reminders",
              channelKey: "sleep_reminders",
              channelName: "Sleep reminders",
              channelDescription: "In-app reminders: sleep reminders",
              defaultColor: primaryColor,
              importance: NotificationImportance.High),
          NotificationChannel(
              channelGroupKey: "reminders",
              channelKey: "hydration_reminders",
              channelName: "Hydration reminders",
              channelDescription: "In-app reminders: hydration reminders",
              defaultColor: primaryColor,
              importance: NotificationImportance.High),
          NotificationChannel(
              channelGroupKey: "content",
              channelKey: "sleep_content",
              channelName: "Sleep content",
              channelDescription: "In-app reminders: sleep content",
              defaultColor: primaryColor,
              importance: NotificationImportance.Default),
          NotificationChannel(
              channelKey: "service_updates",
              channelName: "Service updates",
              channelDescription: "Updates about Happily Ever After",
              defaultColor: primaryColor,
              importance: NotificationImportance.Default),
        ],
        channelGroups: [
          NotificationChannelGroup(
              channelGroupkey: "reminders", channelGroupName: "Reminders"),
          NotificationChannelGroup(
              channelGroupkey: "content", channelGroupName: "Content"),
        ],
        debug: true);
    NotificationService service = NotificationService(
        notifications: notifications, messaging: FirebaseMessaging.instance);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage
        .listen(service._firebaseMessagingForegroundHandler);
    // Debug: Print token
    debugPrint(await service.messaging.getToken());
    // For now, request notifications on start up
    bool allowed = await notifications.isNotificationAllowed();
    if (!allowed) {
      await notifications.requestPermissionToSendNotifications();
    }
    return service;
  }

  Future<void> _firebaseMessagingForegroundHandler(
      RemoteMessage message) async {
    debugPrint("foreground message: ${message.messageId}");
    if (!AwesomeStringUtils.isNullOrEmpty(message.notification?.title,
            considerWhiteSpaceAsEmpty: true) ||
        !AwesomeStringUtils.isNullOrEmpty(message.notification?.body,
            considerWhiteSpaceAsEmpty: true)) {
      // Firebase does not create notifications when the application is in the foreground.
      String? imageUrl;
      imageUrl ??= message.notification!.android?.imageUrl;
      imageUrl ??= message.notification!.apple?.imageUrl;
      notifications.createNotification(
          content: NotificationContent(
              id: Random().nextInt(2147483647),
              channelKey:
                  message.notification?.android?.channelId ?? "service_updates",
              title: message.notification?.title,
              body: message.notification?.body,
              bigPicture: imageUrl,
              notificationLayout: imageUrl == null
                  ? NotificationLayout.BigText
                  : NotificationLayout.BigPicture));
    } else {
      // Handle custom push notifications
      debugPrint("message data: ${message.data}");
      notifications.createNotificationFromJsonData(message.data);
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  //await Firebase.initializeApp();

  debugPrint("background message: ${message.messageId}");
  if (!AwesomeStringUtils.isNullOrEmpty(message.notification?.title,
          considerWhiteSpaceAsEmpty: true) ||
      !AwesomeStringUtils.isNullOrEmpty(message.notification?.body,
          considerWhiteSpaceAsEmpty: true)) {
    // Firebase creates notification when the application is in the background.
  } else {
    // Handle custom push notifications
    debugPrint("message data: ${message.data}");
    AwesomeNotifications().createNotificationFromJsonData(message.data);
  }
}
