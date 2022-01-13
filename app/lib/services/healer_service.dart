import 'package:hea/services/service_locator.dart';
import 'package:hea/models/healer.dart';
import 'package:location/location.dart';
import 'api_endpoint.dart';

const onboardedRespondedLevel = "filledv1";

abstract class HealerService {
  Future<List<Healer>> getNearby(LatLng location);
  Future<List<Availability>> getHealerAvailability();
}

class HealerServiceImpl implements HealerService {
  ApiManager api = serviceLocator<ApiManager>();

  @override
  Future<List<Healer>> getNearby(LatLng location) async {
    final resp = await api.get(ApiEndpoint.healerNeaby);
    if (resp.statusCode == 200) {
      return jsonDecode(resp.body)
          .map((healer) => Healer.fromJson(healer))
          .toList();
    } else {
      throw ApiManagerException(
          message: "Failure in getNearbyHealer: ${resp.statusCode}");
    }
  }

  @override
  Future<List<Availability>> getHealerAvailability() async {
    final resp = await api.get(ApiEndpoint.healerAvailability);
    if (resp.statusCode == 200) {
      return jsonDecode(resp.body)
          .map((availability) => Availability.fromJson(availability))
          .toList();
    } else {
      throw ApiManagerException(
          message: "Failure in getHealerAvailability: ${resp.statusCode}");
    }
  }
}
