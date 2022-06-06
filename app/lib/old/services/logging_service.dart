import '../models/log.dart';
import 'api_manager.dart';
import 'service_locator.dart';
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
    } else if (resp.statusCode == 401) {
      // TODO
      return;
    } else {
      throw ApiManagerException(
          message: "Failure in createLog: ${resp.statusCode}");
    }
  }
}
