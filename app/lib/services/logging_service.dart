import 'package:hea/models/log.dart';
import 'package:hea/services/api_manager.dart';
import 'package:hea/services/service_locator.dart';
import 'api_endpoint.dart';

abstract class LoggingService {
  Future<void> createLog(String key, dynamic value);
}

class LoggingServiceImpl implements LoggingService {
  ApiManager api = serviceLocator<ApiManager>();

  @override
  Future<void> createLog(String key, dynamic value) async {
    final resp = await api.post(ApiEndpoint.logCreate,
        Log.fromDynamic(key, DateTime.now(), value).toJson());
    if (resp.statusCode == 201) {
      return;
    } else {
      throw ApiManagerException(
          message: "Failure in createLog: ${resp.statusCode}");
    }
  }
}
