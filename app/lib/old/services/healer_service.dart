import 'dart:convert';
import 'api_endpoint.dart';
import 'api_manager.dart';
import 'service_locator.dart';
import '../models/healer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const onboardedRespondedLevel = "filledv1";

abstract class HealerService {
  Future<List<Healer>> getNearby(LatLng location);
  Future<List<Availability>> getHealerAvailability();
  Future<void> bookHealerAvailability(Availability availability);
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
      return rawHealers.map((healer) => Healer.fromJson(healer)).toList();
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

  @override
  Future<void> bookHealerAvailability(Availability availability) async {
    final resp = await api.post(ApiEndpoint.healerBook, availability.toJson());
    if (resp.statusCode != 200) {
      throw ApiManagerException(
          message: "Failure in getHealerAvailability: ${resp.statusCode}");
    }
  }
}
