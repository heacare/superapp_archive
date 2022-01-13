import 'dart:convert';
import 'package:hea/services/api_endpoint.dart';
import 'package:hea/services/api_manager.dart';
import 'package:hea/services/service_locator.dart';
import 'package:hea/models/healer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const onboardedRespondedLevel = "filledv1";

abstract class HealerService {
  Future<List<Healer>> getNearby(LatLng location);
  Future<List<Availability>> getHealerAvailability();
}

class HealerServiceImpl implements HealerService {
  ApiManager api = serviceLocator<ApiManager>();

  @override
  Future<List<Healer>> getNearby(LatLng location) async {
    Map<String, String> queryParams = {
      'lat': location.latitude.toString(),
      'lng': location.longitude.toString()
    };

    final resp =
        await api.get(ApiEndpoint.healerNearby, queryParams: queryParams);
    if (resp.statusCode == 200) {
      List rawHealers = jsonDecode(resp.body)["healers"];
      return rawHealers.map((healer) => Healer.fromJson(healer)).toList()
          as List<Healer>;
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
