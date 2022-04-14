import 'package:firebase_messaging/firebase_messaging.dart';

class MessagingService {
  MessagingService({required this.messaging});
  final FirebaseMessaging messaging;

  static Future<MessagingService> create() async {
    var service = MessagingService(messaging: FirebaseMessaging.instance);
    await service.messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    var token = await service.messaging.getToken();
    print(token);
    return service;
  }
}
