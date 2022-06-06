import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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
    _jwtToken = "";
  }

  Uri _buildUri(String endpoint, {Map<String, String>? queryParams}) {
    return Uri.https(apiBaseUrl, endpoint, queryParams);
  }
}
