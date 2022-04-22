import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter/foundation.dart';
import 'dart:async';

import 'package:hea/services/logging_service.dart';
import 'package:hea/services/service_locator.dart';
import 'package:hea/utils/kv_wrap.dart';

class SleepCheckinProgress extends ChangeNotifier {
  int total = 7;
  int day = 1;
  bool todayDone = false;
  bool allDone = false;
  DateTime? lastCheckIn;

  addDay() {
    day = day + 1;
    kvWrite("sleep", "day", day);
    lastCheckIn = DateTime.now();
    kvWrite("sleep", "last-check-in", lastCheckIn!.toIso8601String());
    recalculate();
    notifyListeners();
  }

  SleepCheckinProgress() {
    reload();
    Timer.periodic(const Duration(hours: 1), (timer) {
      reload();
      notifyListeners();
    });
  }

  reload() {
    day = kvRead<int>("sleep", "day") ?? day;
    total = kvRead<int>("sleep", "day-total") ?? total;
    String? lastCheckInString = kvRead<String>("sleep", "last-check-in");
    if (lastCheckInString != null) {
      lastCheckIn = DateTime.parse(lastCheckInString);
    }
    recalculate();
  }

  recalculate() {
    allDone = day > total;
    if (lastCheckIn != null) {
      DateTime endDay = DateTime(
          lastCheckIn!.year, lastCheckIn!.month, lastCheckIn!.day, 23, 59);
      DateTime now = DateTime.now();
      todayDone = allDone || now.isBefore(endDay);
    } else {
      todayDone = allDone;
    }
  }

  reset() {
    day = 1;
    kvDelete("sleep", "day");
    total = 7;
    kvDelete("sleep", "day-total");
    lastCheckIn = null;
    kvDelete("sleep", "last-check-in");
    recalculate();
    notifyListeners();
  }
}

class SleepCheckinData {
  String didWindDown = "yes";
  List<String> didCalmActivities = [];
  String interruptions = "";
  TimeOfDay timeGoBed = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay timeAsleepBed = const TimeOfDay(hour: 0, minute: 0);
  int easyAsleep = 2;
  TimeOfDay timeOutBed = const TimeOfDay(hour: 0, minute: 0);
  int easyWake = 2;

  toJSON() => {
        "did-wind-down": didWindDown,
        "did-calm-activities": didCalmActivities,
        "interruptions": interruptions,
        "time-go-bed": JTimeOfDay.from(timeGoBed).toJSON(),
        "time-asleep-bed": JTimeOfDay.from(timeAsleepBed).toJSON(),
        "easy-asleep": easyAsleep,
        "time-out-bed": JTimeOfDay.from(timeOutBed).toJSON(),
        "easy-wake": easyWake,
      };
}

abstract class SleepCheckinService {
  SleepCheckinProgress getProgress();
  Future<void> add(SleepCheckinData data);
  reset();
}

class SleepCheckinServiceImpl implements SleepCheckinService {
  SleepCheckinProgress? progress;

  @override
  SleepCheckinProgress getProgress() {
    progress ??= SleepCheckinProgress();
    return progress!;
  }

  @override
  Future<void> add(SleepCheckinData data) async {
    Map<String, dynamic> log = {
      "data": data.toJSON(),
      "previous-check-in": kvRead<String>("sleep", "last-check-in"),
    };
    await serviceLocator<LoggingService>().createLog("sleep-checkin", log);
    SleepCheckinProgress progress = getProgress();
    progress.addDay();
  }

  @override
  reset() {
    Map<String, dynamic> log = {
      "reset": true,
    };
    serviceLocator<LoggingService>().createLog("sleep-checkin", log);
    SleepCheckinProgress progress = getProgress();
    progress.reset();
  }
}
