import 'dart:convert';
import 'dart:developer';
import 'package:hea/models/user.dart';
import 'package:hea/services/api_manager.dart';
import 'package:hea/services/service_locator.dart';
import 'api_endpoint.dart';

// If user's responded level does not correspond to this, user is not fully onboarded
const onboardedRespondedLevel = "filledv1";

abstract class UserService {
  Future<User> getCurrentUser();
  Future<bool> isCurrentUserOnboarded();
  Future updateUser(User user);
}

class UserServiceImpl implements UserService {
  ApiManager api = serviceLocator<ApiManager>();

  @override
  Future<User> getCurrentUser() async {
    final resp = await api.get(ApiEndpoint.userInfo);
    if (resp.statusCode == 200) {
      return User.fromJson(jsonDecode(resp.body));
    } else {
      throw ApiManagerException(
          message: "Failure in getCurrentUser: ${resp.statusCode}");
    }
  }

  @override
  Future<bool> isCurrentUserOnboarded() async {
    final resp = await api.get(ApiEndpoint.userInfo);
    if (resp.statusCode == 200) {
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      return (json["level"] ?? "") == onboardedRespondedLevel;
    } else {
      throw ApiManagerException(
          message: "Failure in getCurrentUser: ${resp.statusCode}");
    }
  }

  // TODO: Test with new onboarding
  @override
  Future updateUser(User user) async {
    final resp = await api.post(ApiEndpoint.userOnboard, user.toJson());
    if (resp.statusCode != 201) {
      throw ApiManagerException(message: "Failure in updateUser: ${resp.statusCode} - ${resp.body}");
    }
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
  Future updateUser(User user) {
    log("Update user data: $user");
    return Future.delayed(const Duration(milliseconds: 500));
  }
}
