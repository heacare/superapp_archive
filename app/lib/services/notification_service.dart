import 'dart:math';

import 'package:flutter/material.dart' show Color;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  final AwesomeNotifications notifications;
  final FirebaseMessaging messaging;

  NotificationService({required this.notifications, required this.messaging});

  Future<void> showReminder(int id, String channelKey, String title,
      String body, String payload) async {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: id,
      channelKey: channelKey,
      category: NotificationCategory.Reminder,
      title: title,
      body: body,
      payload: {"reminder": payload},
    ));
  }

  Future<void> showDemoContentReminder(
      int id, String channelKey, String title, String body) async {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: channelKey,
          category: NotificationCategory.Reminder,
          title: title,
          body: body,
          payload: {},
        ),
        actionButtons: [
          NotificationActionButton(
            buttonType: ActionButtonType.Default,
            key: "continue",
            label: "Continue",
          ),
          NotificationActionButton(
            buttonType: ActionButtonType.KeepOnTop,
            key: "remind-tomorrow-morning",
            label: "Remind me tomorrow morning",
          ),
          NotificationActionButton(
            buttonType: ActionButtonType.KeepOnTop,
            key: "remind-tomorrow-afternoon",
            label: "Remind me tomorrow afternoon",
          ),
        ]);
  }

  Future<void> showPreferences() async {
    await notifications.showNotificationConfigPage();
  }

  static Future<NotificationService> create() async {
    AwesomeNotifications notifications = AwesomeNotifications();
    notifications.initialize(
        "resource://drawable/notification_icon_temporary",
        [
          NotificationChannel(
              channelGroupKey: "reminders",
              channelKey: "sleep_reminders",
              channelName: "Sleep reminders",
              channelDescription: "In-app reminders: sleep reminders",
              defaultColor: Color(0xFFFF7FAA),
              importance: NotificationImportance.High),
          NotificationChannel(
              channelGroupKey: "reminders",
              channelKey: "hydration_reminders",
              channelName: "Hydration reminders",
              channelDescription: "In-app reminders: hydration reminders",
              defaultColor: Color(0xFFFF7FAA),
              importance: NotificationImportance.High),
          NotificationChannel(
              channelGroupKey: "content",
              channelKey: "sleep_content",
              channelName: "Sleep content",
              channelDescription: "In-app reminders: sleep content",
              defaultColor: Color(0xFFFF7FAA),
              importance: NotificationImportance.High),
          NotificationChannel(
              channelKey: "service_updates",
              channelName: "Service updates",
              channelDescription: "Updates about Happily Ever After",
              defaultColor: Color(0xFFFF7FAA),
              importance: NotificationImportance.High),
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
    print(await service.messaging.getToken());
    // For now, request notifications on start up
    bool allowed = await AwesomeNotifications().isNotificationAllowed();
    if (!allowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
    return service;
  }

  Future<void> _firebaseMessagingForegroundHandler(
      RemoteMessage message) async {
    print("foreground message: ${message.messageId}");
    if (!AwesomeStringUtils.isNullOrEmpty(message.notification?.title,
            considerWhiteSpaceAsEmpty: true) ||
        !AwesomeStringUtils.isNullOrEmpty(message.notification?.body,
            considerWhiteSpaceAsEmpty: true)) {
      // Firebase does not create notifications when the application is in the foreground.

      String? imageUrl;
      imageUrl ??= message.notification!.android?.imageUrl;
      imageUrl ??= message.notification!.apple?.imageUrl;

      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: Random().nextInt(2147483647),
              channelKey:
                  message.notification?.android?.channelId ?? "service_updates",
              title: message.notification?.title,
              body: message.notification?.body,
              bigPicture: imageUrl,
              notificationLayout: imageUrl == null
                  ? NotificationLayout.Default
                  : NotificationLayout.BigPicture));
    } else {
      // Handle custom push notifications
      print("message data: ${message.data}");
      AwesomeNotifications().createNotificationFromJsonData(message.data);
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  //await Firebase.initializeApp();

  print("background message: ${message.messageId}");
  if (!AwesomeStringUtils.isNullOrEmpty(message.notification?.title,
          considerWhiteSpaceAsEmpty: true) ||
      !AwesomeStringUtils.isNullOrEmpty(message.notification?.body,
          considerWhiteSpaceAsEmpty: true)) {
    // Firebase creates notification when the application is in the background.
  } else {
    // Handle custom push notifications
    print("message data: ${message.data}");
    AwesomeNotifications().createNotificationFromJsonData(message.data);
  }
}
