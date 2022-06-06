import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart' show Firebase;

import 'firebase_options.dart';
import 'log.dart';

bool isFirebaseReady = false;

Future<void> firebaseInitialize() async {
  if (Platform.isIOS || Platform.isAndroid) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    isFirebaseReady = true;
  } else {
    logW("Firebase is not set up");
  }
}
