import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

import 'package:hea/utils/kv_wrap.dart';
import 'package:hea/services/service_locator.dart';
import 'package:hea/services/logging_service.dart';

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
