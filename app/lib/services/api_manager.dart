import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:hea/services/service_locator.dart';
import 'package:hea/services/auth_service.dart';
import 'package:hea/services/api_endpoint.dart';

// Set with flutter run ... --dart-define API_BASE=<addr>
const apiBaseUrl =
    String.fromEnvironment("API_BASE", defaultValue: "api.alpha.hea.care");

class ApiManagerException implements Exception {
  final String message;
  ApiManagerException({required this.message}) {
    debugPrint(message);
  }
}

class ApiManager {
  String? _jwtToken;

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    if (_jwtToken == null) await fetchJwtToken();

    return http.post(_buildUri(endpoint), body: jsonEncode(body), headers: {
      'accept': "application/json",
      'Authorization': 'Bearer $_jwtToken',
      'Content-Type': 'application/json; charset=UTF-8'
    });
  }

  Future<http.Response> get(String endpoint,
      {Map<String, String>? queryParams}) async {
    if (_jwtToken == null) await fetchJwtToken();

    return http.get(_buildUri(endpoint, queryParams: queryParams), headers: {
      'accept': "application/json",
      'Authorization': 'Bearer $_jwtToken'
    });
  }

  // TODO: Cache token with flutter_secure_storage
  fetchJwtToken() async {
    final firebaseToken =
        await serviceLocator<AuthService>().currentUserToken();
    if (firebaseToken == null) return null;

    final response = await http.post(_buildUri(ApiEndpoint.jwtToken),
        body: jsonEncode({"firebaseToken": firebaseToken}),
        headers: {
          'accept': "application/json",
          'Authorization': 'Bearer $_jwtToken',
          'Content-Type': 'application/json; charset=UTF-8'
        });

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        throw ApiManagerException(message: "Expected JWT token");
      }
      _jwtToken = jsonDecode(response.body)["jwt"];
      debugPrint("JWT Token: $_jwtToken");
    } else {
      throw ApiManagerException(message: "Failed to obtain JWT token");
    }
  }

  Uri _buildUri(String endpoint, {Map<String, String>? queryParams}) {
    return Uri.https(apiBaseUrl, endpoint, queryParams);
  }
}
