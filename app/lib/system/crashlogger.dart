import 'dart:async' show runZonedGuarded;

import 'package:firebase_crashlytics/firebase_crashlytics.dart'
    show FirebaseCrashlytics;
import 'package:flutter/foundation.dart'
    show
        FlutterError,
        FlutterErrorDetails,
        debugPrint,
        kDebugMode,
        kProfileMode;

import 'firebase.dart' show isFirebaseReady;
import 'log.dart';

abstract class _CrashLogger {
  void _recordFlutterError(
    final FlutterErrorDetails details, {
    required final bool fatal,
  });

  void _recordFlutterFatalError(
    final FlutterErrorDetails flutterErrorDetails,
  ) =>
      _recordFlutterError(flutterErrorDetails, fatal: true);

  void _recordZoneError(final Object error, final StackTrace stack) {
    _recordFlutterError(
      FlutterErrorDetails(
        exception: error,
        stack: stack,
        library: 'HEA crashlogger',
      ),
      fatal: false,
    );
  }

  Future<void> _setup() async {}

  void wrap(
    final Future<void> Function() setup,
    final Future<void> Function() runApp,
  ) {
    runZonedGuarded(
      () async {
        await setup();
        await _setup();
        FlutterError.onError = _recordFlutterFatalError;
        await runApp();
      },
      _recordZoneError,
    );
  }
}

class _FirebaseCrashLogger extends _CrashLogger {
  void Function(FlutterErrorDetails details, {required bool fatal})? _record;

  @override
  Future<void> _setup() async {
    _record = FirebaseCrashlytics.instance.recordFlutterError;
  }

  @override
  void _recordFlutterError(
    final FlutterErrorDetails details, {
    required final bool fatal,
  }) {
    _record!(details, fatal: fatal);
  }
}

class _DebugPrintCrashLogger extends _CrashLogger {
  @override
  void _recordFlutterError(
    final FlutterErrorDetails details, {
    required final bool fatal,
  }) {
    debugPrint(
      'UNCAUGHT ${details.exceptionAsString()} (fatal: $fatal)\n${details.stack.toString()}',
    );
  }
}

// ignore: do_not_use_environment
const String crashlogger = String.fromEnvironment('CRASHLOGGER');

Future<void> crashloggerWrap(
  final Future<void> Function() setup,
  final Future<void> Function() runApp,
) async {
  if (crashlogger == 'disabled') {
    await setup();
    await runApp();
    return;
  }

  _CrashLogger? crashLogger;
  if (isFirebaseReady && !kDebugMode && !kProfileMode) {
    // Also disable Firebase Crashlytics crash logging when in profile mode to prevent crashes in CI from flooding Crashlytics
    crashLogger = _FirebaseCrashLogger();
  } else {
    logW('Using debugPrint crashLogger');
    crashLogger = _DebugPrintCrashLogger();
  }
  crashLogger.wrap(setup, runApp);
}
