import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hea/services/logging_service.dart';
import 'package:hea/services/service_locator.dart';
import 'package:hea/utils/kv_wrap.dart';

class SleepCheckinProgress extends ChangeNotifier {
  int total = 7;
  int day = 0;
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

  get dayCounter {
    if (todayDone) {
      return day;
    }
    return day + 1;
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
    allDone = day >= total;
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
    day = 0;
    kvDelete("sleep", "day");
    total = 7;
    kvDelete("sleep", "day-total");
    lastCheckIn = null;
    kvDelete("sleep", "last-check-in");
    recalculate();
    notifyListeners();
  }

  start() {
    reload();
    notifyListeners();
  }
}

class SleepCheckinData {
  String didWindDown = "";
  List<String> didCalmActivities = [];
  String interruptions = "";
  TimeOfDay? timeGoBed;
  TimeOfDay? timeAsleepBed;
  int easyAsleep = 2;
  TimeOfDay? timeOutBed;
  int easyWake = 2;

  Duration get slept {
    if (timeOutBed == null || timeAsleepBed == null) {
      return const Duration();
    }
    return Duration(
        minutes: ((timeOutBed!.minute + timeOutBed!.hour * 60) -
                (timeAsleepBed!.minute + timeAsleepBed!.hour * 60)) %
            (24 * 60));
  }

  toJson() => {
        "did-wind-down": didWindDown,
        "did-calm-activities": didCalmActivities,
        "interruptions": interruptions,
        "time-go-bed": timeGoBed == null ? null : JTimeOfDay.from(timeGoBed!),
        "time-asleep-bed":
            timeAsleepBed == null ? null : JTimeOfDay.from(timeAsleepBed!),
        "easy-asleep": easyAsleep,
        "time-out-bed":
            timeOutBed == null ? null : JTimeOfDay.from(timeOutBed!),
        "easy-wake": easyWake,
      };

  SleepCheckinData();

  factory SleepCheckinData.fromJson(Map<String, dynamic> data) {
    SleepCheckinData s = SleepCheckinData();
    s.didWindDown = data["did-wind-down"];
    s.didCalmActivities = List.from(data["did-calm-activities"].map((s) => s));
    s.interruptions = data["interruptions"];
    s.timeGoBed = data["time-go-bed"] == null
        ? null
        : JTimeOfDay.fromJson(data["time-go-bed"]);
    s.timeAsleepBed = data["time-asleep-bed"] == null
        ? null
        : JTimeOfDay.fromJson(data["time-asleep-bed"]);
    s.easyAsleep = data["easy-asleep"];
    s.timeOutBed = data["time-out-bed"] == null
        ? null
        : JTimeOfDay.fromJson(data["time-out-bed"]);
    s.easyWake = data["easy-wake"];
    return s;
  }
}

abstract class SleepCheckinService {
  SleepCheckinProgress getProgress();
  Future<void> add(SleepCheckinData data);
  List<SleepCheckinData> storageRead();
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
      "data": data.toJson(),
      "previous-check-in": kvRead<String>("sleep", "last-check-in"),
    };
    await serviceLocator<LoggingService>().createLog("sleep-checkin", log);
    storageAppend(data);
    SleepCheckinProgress progress = getProgress();
    progress.addDay();
  }

  @override
  List<SleepCheckinData> storageRead() {
    String json =
        serviceLocator<SharedPreferences>().getString('checkin-sleep') ?? "[]";
    List<dynamic> object = jsonDecode(json);
    return object.map((d) => SleepCheckinData.fromJson(d)).toList();
  }

  storageAppend(SleepCheckinData data) async {
    List<SleepCheckinData> list = storageRead();
    list.insert(0, data);
    String json = jsonEncode(list);
    serviceLocator<SharedPreferences>().setString('checkin-sleep', json);
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
