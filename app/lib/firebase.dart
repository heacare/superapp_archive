import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'firebase_options.dart';

final bool hasFirebase = Platform.isIOS || Platform.isAndroid;

Future<void> firebaseSetup() async {
  if (hasFirebase) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }
}
