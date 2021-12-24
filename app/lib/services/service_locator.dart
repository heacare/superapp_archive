import 'package:get_it/get_it.dart';
import 'package:hea/services/auth_service.dart';
import 'package:hea/services/api_manager.dart';
import 'package:hea/services/user_service.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  // Will be lazily created for the first time in main after Firebase initializes
  serviceLocator.registerLazySingleton<AuthService>(() => AuthService());

  serviceLocator.registerSingleton<ApiManager>(ApiManager());
  // TODO: Switch to UserServiceImpl
  serviceLocator.registerSingleton<UserService>(UserServiceMock());
}