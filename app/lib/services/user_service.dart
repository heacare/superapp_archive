import 'dart:convert';
import 'dart:developer';
import 'package:hea/main.dart';
import 'package:hea/models/user.dart';
import 'package:hea/services/api_manager.dart';
import 'package:hea/services/service_locator.dart';

import 'api_manager.dart' as api_manager;

// If user's responded level does not correspond to this, user is not fully onboarded
const onboardedRespondedLevel = "filledv1";

abstract class UserService {
  Future<User> getCurrentUser();

  Future<bool> isCurrentUserOnboarded();

  bool updateUser(User user);
}

class UserServiceImpl implements UserService {
  ApiManager api = serviceLocator<ApiManager>();

  @override
  Future<User> getCurrentUser() async {
    final resp = await api.get(api_manager.userInfoEndpoint);
    if (resp.statusCode == 200) {
      return User.fromJson(jsonDecode(resp.body));
    } else {
      throw ApiManagerException(
          message: "Failure in getCurrentUser: ${resp.statusCode}");
    }
  }

  @override
  Future<bool> isCurrentUserOnboarded() async {
    final resp = await api.get(api_manager.userInfoEndpoint);
    if (resp.statusCode == 200) {
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      return (json["level"] ?? "") == onboardedRespondedLevel;
    } else {
      throw ApiManagerException(
          message: "Failure in getCurrentUser: ${resp.statusCode}");
    }
  }

  @override
  bool updateUser(User user) {
    // TODO: implement submitOnboardData
    throw UnimplementedError();
  }
}

// For testing
class UserServiceMock implements UserService {
  @override
  Future<User> getCurrentUser() {
    log("Getting placeholder user");
    return Future.delayed(
        const Duration(milliseconds: 500), () => User.placeholder());
  }

  @override
  Future<bool> isCurrentUserOnboarded() {
    return Future.delayed(const Duration(milliseconds: 500), () => true);
  }

  @override
  bool updateUser(User user) {
    log("Update user data: $user");
    return true;
  }
}
