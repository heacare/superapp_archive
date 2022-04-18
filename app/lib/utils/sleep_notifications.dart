import 'package:shared_preferences/shared_preferences.dart';

import 'package:hea/services/service_locator.dart';
import 'package:hea/services/notification_service.dart';
import 'package:hea/utils/kv_wrap.dart';

// Hours
const int firstReminder = 12;
const int nextReminder = 6;
// Channel
const String channel = "sleep_content";

// Base ID
const int baseId = 100;

Future<void> scheduleSleepNotifications() async {
  String? s = serviceLocator<SharedPreferences>().getString('sleep');
  Map sleepData = kvDump("sleep");
  await serviceLocator<NotificationService>().cancelAllSchedules();
  if (s == "NowFirstThingsFirst" ||
      s == "NowTimeGoneBed" ||
      s == "NowMinutesFallAsleep" ||
      s == "NowTimeOutBed" ||
      s == "NowGetSleep") {
    // Set #2
    // Objective: user to get sleep efficiency score <take user to begin Chp 2>
    int count =
        serviceLocator<SharedPreferences>().getInt("now-efficiency") ?? 0;
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 2 * 10 + 1,
        "sleep_content",
        "Sleep quality check",
        "To begin your sleep journey, complete the sleep quality check.",
        minHoursLater: firstReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 2 * 10 + 2,
        "sleep_content",
        "Sleep quality check",
        "Are you unknowingly wasting time in bed? What is disturbing your rest?",
        minHoursLater: firstReminder + nextReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 2 * 10 + 3,
        "sleep_content",
        "Sleep quality check",
        "We miss you ☹️. Do you need some help? Feel free to contact us directly",
        minHoursLater: firstReminder + nextReminder * 2);
  } else {
    // Cancel
  }
}
