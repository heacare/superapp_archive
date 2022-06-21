import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

import '../firebase_options.dart';
import 'log.dart';

bool isFirebaseReady = false;

Future<void> firebaseInitialize() async {
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
    case TargetPlatform.iOS:
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      isFirebaseReady = true;
      break;
    default:
      logW('Firebase is not set up');
  }
}
