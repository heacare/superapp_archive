import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:hea/services/service_locator.dart';
import 'package:hea/services/auth_service.dart';

// TODO Change to prod backend
// Android emulator routes to localhost on 10.0.2.2
const apiBaseUrl = "10.0.2.2:3000";

// Endpoints
const jwtTokenEndpoint = "/api/auth/verify";

class ApiManagerException implements Exception {
  final String message;
  ApiManagerException({required this.message});
}

class ApiManager {
  String? _jwtToken;

  post(String endpoint, Map<String, String> body) async {
    if (_jwtToken == null) _fetchJwtToken();

    return http.post(_buildUri(endpoint), body: jsonEncode(body), headers: {
      'accept': "application/json",
      'Authorization': 'Bearer $_jwtToken',
      'Content-Type': 'application/json; charset=UTF-8'
    });
  }

  get(String endpoint) async {
    if (_jwtToken == null) _fetchJwtToken();

    return http.get(_buildUri(endpoint), headers: {
      'accept': "application/json",
      'Authorization': 'Bearer $_jwtToken',
      'Content-Type': 'application/json; charset=UTF-8'
    });
  }

  // TODO: Cache token with flutter_secure_storage
  _fetchJwtToken() async {
    final firebaseToken =
        await serviceLocator<AuthService>().currentUserToken();
    if (firebaseToken == null) return null;

    final response = await http.post(_buildUri(jwtTokenEndpoint),
        body: jsonEncode({"firebaseToken": firebaseToken}),
        headers: {
          'accept': "application/json",
          'Authorization': 'Bearer $_jwtToken',
          'Content-Type': 'application/json; charset=UTF-8'
        });

    if (response.statusCode == 201) {
      if (response.body.isEmpty) {
        throw ApiManagerException(message: "Expected JWT token");
      }
      _jwtToken = jsonDecode(response.body)["jwt"];
      log("JWT Token: $_jwtToken");
    }
    else {
      throw ApiManagerException(message: "Failed to obtain JWT token");
    }
  }

  Uri _buildUri(String endpoint) {
    // TODO: HTTPS?
    return Uri.http(apiBaseUrl, endpoint);
  }
}
