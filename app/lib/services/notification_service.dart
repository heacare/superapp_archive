import 'package:flutter/material.dart' show Color;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService({required this.notifications});
  final FlutterLocalNotificationsPlugin notifications;

  Future<void> onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    print("receive title: $title body: $body payload: $payload");
  }

  Future<void> onSelectNotification(String? payload) async {
    if (payload != null) {
      print("selected payload: $payload");
    }
  }

  Future<void> showReminder(
      int id, String title, String body, String payload) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'reminders',
      'Reminders',
      channelDescription: 'In-app reminders',
      color: Color(0xFFFF7FAA),
      ticker: 'Happily Ever After',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notifications.show(id, title, body, platformChannelSpecifics,
        payload: payload);
  }

  static Future<NotificationService> create() async {
    var service =
        NotificationService(notifications: FlutterLocalNotificationsPlugin());
    const initializationSettingsAndroid =
        AndroidInitializationSettings('notification_icon_temporary');
    final initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: service.onDidReceiveLocalNotification);
    await service.notifications.initialize(
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS),
        onSelectNotification: service.onSelectNotification);
    return service;
  }
}
