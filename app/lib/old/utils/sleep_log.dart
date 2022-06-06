// ignore_for_file: depend_on_referenced_packages

import 'package:collection/collection.dart';

import 'kv_wrap.dart';
import '../services/service_locator.dart';
import '../services/logging_service.dart';

Map<String, dynamic> lastDump = {};

const deepCollectionEquality = DeepCollectionEquality();

Future<void> sleepLog() async {
  Map<String, dynamic> dump = kvDump("sleep");
  if (deepCollectionEquality.equals(lastDump, dump)) {
    return;
  }
  await serviceLocator<LoggingService>().createLog('sleep', dump);
  lastDump = dump;
}
