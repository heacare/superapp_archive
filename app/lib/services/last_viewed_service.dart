import 'dart:convert';
import 'package:hea/models/user.dart';
import 'package:hea/services/api_manager.dart';
import 'package:hea/services/service_locator.dart';
import 'api_endpoint.dart';

abstract class LastViewedService {
  Future<Widget> getLastViewed();
  Future updateLastViewed(Widget w);
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
      throw ApiManagerException(
          message: "Failure in updateUser: ${resp.statusCode} - ${resp.body}");
    }
  }
}
