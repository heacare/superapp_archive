import 'package:get_it/get_it.dart';
import 'package:hea/services/api_manager.dart';
import 'package:hea/services/user_service.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerSingleton<ApiManager>(ApiManager());
  // TODO: Switch to UserServiceImpl
  serviceLocator.registerSingleton<UserService>(UserServiceMock());
}