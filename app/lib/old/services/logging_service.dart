import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;

import '../models/log.dart';
import 'api_manager.dart';
import 'service_locator.dart';
import 'api_endpoint.dart';
import '../../../features/interim_data_collection/interim_data_collection.dart';

abstract class LoggingService {
  Future<void> createLog(String key, dynamic value);
}

class LoggingServiceImpl implements LoggingService {
  ApiManager api = serviceLocator<ApiManager>();

  @override
  Future<void> createLog(String key, dynamic value) async {
    if (!kDebugMode) {
      collectSimpleKv(key, value);
    }
  }
}
