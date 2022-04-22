import 'package:get_it/get_it.dart';
import 'package:hea/screens/sleep_checkin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hea/services/auth_service.dart';
import 'package:hea/services/api_manager.dart';
import 'package:hea/services/content_service.dart';
import 'package:hea/services/user_service.dart';
import 'package:hea/services/healer_service.dart';
import 'package:hea/services/logging_service.dart';
import 'package:hea/services/notification_service.dart';
import 'package:hea/services/sleep_checkin_service.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  // Will be lazily created for the first time in main after Firebase initializes
  serviceLocator.registerLazySingleton<AuthService>(() => AuthService());

  serviceLocator.registerSingleton<ApiManager>(ApiManager());
  serviceLocator.registerSingleton<ContentService>(ContentServiceImpl());
  serviceLocator.registerSingleton<UserService>(UserServiceImpl());
  serviceLocator.registerSingleton<HealerService>(HealerServiceImpl());
  serviceLocator.registerSingleton<LoggingService>(LoggingServiceImpl());
  serviceLocator
      .registerSingleton<SleepCheckinService>(SleepCheckinServiceImpl());

  serviceLocator.registerSingletonAsync<SharedPreferences>(
      () => SharedPreferences.getInstance());
  serviceLocator.registerSingletonAsync<NotificationService>(
      () => NotificationService.create());
}
