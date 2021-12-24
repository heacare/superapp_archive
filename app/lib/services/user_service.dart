import 'dart:developer';
import 'package:hea/models/user.dart';

enum RespondedLevel {
  uninit,
  filledv1
}
// If user's responded level does not correspond to this, user is not fully onboarded
const onboardedRespondedLevel = RespondedLevel.filledv1;

abstract class UserService {
  Future<User> getCurrentUser();
  Future<bool> isCurrentUserOnboarded();
  bool updateUser(User user);
}

// For testing
class UserServiceMock implements UserService {
  @override
  Future<User> getCurrentUser() {
    log("Getting placeholder user");
    return Future.delayed(const Duration(milliseconds: 500), () => User.placeholder());
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

class UserServiceImpl implements UserService {
  @override
  Future<User> getCurrentUser() {
    // TODO: implement getUserData
    throw UnimplementedError();
  }

  @override
  Future<bool> isCurrentUserOnboarded() {
    // TODO: implement getCurrentUserRespondedLevel
    throw UnimplementedError();
  }

  @override
  bool updateUser(User user) {
    // TODO: implement submitOnboardData
    throw UnimplementedError();
  }
}