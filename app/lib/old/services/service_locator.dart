import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_manager.dart';
import 'content_service.dart';
import 'user_service.dart';
import 'healer_service.dart';
import 'logging_service.dart';
import 'notification_service.dart';
import 'sleep_checkin_service.dart';
import 'health_service.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  // Will be lazily created for the first time in main after Firebase initializes
  serviceLocator.registerSingleton<ApiManager>(ApiManager());
  serviceLocator.registerSingleton<ContentService>(ContentServiceImpl());
  serviceLocator.registerSingleton<UserService>(UserServiceImpl());
  serviceLocator.registerSingleton<HealerService>(HealerServiceImpl());
  serviceLocator.registerSingleton<LoggingService>(LoggingServiceImpl());
  serviceLocator
      .registerSingleton<SleepCheckinService>(SleepCheckinServiceImpl());
  serviceLocator.registerSingleton<HealthService>(HealthService());

  serviceLocator.registerSingletonAsync<SharedPreferences>(
      () => SharedPreferences.getInstance());
  serviceLocator.registerSingletonAsync<NotificationService>(
      () => NotificationService.create());
}
