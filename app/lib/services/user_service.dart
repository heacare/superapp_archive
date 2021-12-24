import 'dart:developer';

import 'package:hea/models/user.dart';

abstract class UserService {
  Future<User> getCurrentUser();
  bool updateUser(User user);
}

class UserServiceMock implements UserService {
  @override
  Future<User> getCurrentUser() {
    log("Getting placeholder user");
    return Future.delayed(const Duration(milliseconds: 500), () => User.placeholder());
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
  bool updateUser(User user) {
    // TODO: implement submitOnboardData
    throw UnimplementedError();
  }
}