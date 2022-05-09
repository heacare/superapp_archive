import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:health/health.dart';

import 'package:hea/services/service_locator.dart';
import 'package:hea/services/logging_service.dart';
import 'package:hea/services/auth_service.dart';

class SleepAutofill {
  final DateTime? inBed;
  final DateTime? asleep;
  final DateTime awake;
  final DateTime? outBed;

  const SleepAutofill(
      {required this.inBed, this.asleep, required this.awake, this.outBed});

  toJson() => {
        "in-bed": inBed?.toIso8601String(),
        "asleep": asleep?.toIso8601String(),
        "awake": awake.toIso8601String(),
        "out-bed": outBed?.toIso8601String(),
      };

  int get sleepLatencyMinutes {
    if (inBed == null || asleep == null) {
      return 0;
    }
    return ((asleep!.minute + asleep!.hour * 60) -
            (inBed!.minute + inBed!.hour * 60)) %
        (24 * 60);
  }

  int get sleepMinutes {
    if (asleep == null) {
      return 0;
    }
    return ((awake.minute + awake.hour * 60) -
            (asleep!.minute + asleep!.hour * 60)) %
        (24 * 60);
  }
}

class HealthService {
  final HealthFactory health = HealthFactory();

  HealthService() {
    Timer(const Duration(seconds: 1), () async {
      var user = serviceLocator<AuthService>().currentUser();
      if (user == null) {
        return;
      }
      if (!await serviceLocator<HealthService>().request()) {
        return;
      }
      await log60Days();
    });
    Timer.periodic(const Duration(hours: 4), (timer) async {
      var user = serviceLocator<AuthService>().currentUser();
      if (user == null) {
        return;
      }
      if (!await serviceLocator<HealthService>().request()) {
        return;
      }
      await log60Days();
    });
  }

  // Define the types to get
  final List<HealthDataType> types = [
    //HealthDataType.WEIGHT,
    //HealthDataType.HEIGHT,
    //HealthDataType.BLOOD_GLUCOSE,
    //HealthDataType.BLOOD_OXYGEN,
    //HealthDataType.BODY_FAT_PERCENTAGE,
    //HealthDataType.BODY_MASS_INDEX,
    //HealthDataType.HEART_RATE,
    //HealthDataType.STEPS,
    HealthDataType.SLEEP_IN_BED,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.SLEEP_AWAKE,
  ];

  Future<bool> request() async {
    // OAuth request authorization to data
    return await health.requestAuthorization(types);
  }

  Future<List<HealthDataPoint>> get60Days() async {
    DateTime startDate = DateTime.now().subtract(const Duration(days: 60));
    DateTime endDate = DateTime.now();
    return await health.getHealthDataFromTypes(startDate, endDate, types);
  }

  Future<void> log60Days() async {
    List<HealthDataPoint> healthData = await get60Days();
    await serviceLocator<LoggingService>()
        .createLog('past-health-data', healthData);
  }

  DateTime earliest(DateTime? a, DateTime b) {
    if (a == null) {
      return b;
    }
    if (a.isAfter(b)) {
      return b;
    }
    return a;
  }

  DateTime latest(DateTime? a, DateTime b) {
    if (a == null) {
      return b;
    }
    if (a.isBefore(b)) {
      return b;
    }
    return a;
  }

  SleepAutofill? processNight(List<HealthDataPoint> healthData) {
    DateTime? inBed;
    DateTime? asleep;
    DateTime? awake;
    DateTime? outBed;

    for (var data in healthData) {
      if (Platform.isIOS) {
        if (data.type == HealthDataType.SLEEP_IN_BED) {
          inBed = earliest(inBed, data.dateFrom);
          outBed = latest(outBed, data.dateTo);
        } else if (data.type == HealthDataType.SLEEP_ASLEEP) {
          inBed = earliest(inBed, data.dateFrom);
          asleep = earliest(asleep, data.dateFrom);
          awake = latest(awake, data.dateTo);
          outBed = latest(outBed, data.dateTo);
        }
      } else if (Platform.isAndroid) {
        if (data.type == HealthDataType.SLEEP_IN_BED) {
          inBed = earliest(inBed, data.dateFrom);
          outBed = latest(outBed, data.dateTo);
        } else if (data.type == HealthDataType.SLEEP_ASLEEP) {
          inBed = earliest(inBed, data.dateFrom);
          asleep = earliest(asleep, data.dateFrom);
          awake = latest(awake, data.dateTo);
          outBed = latest(outBed, data.dateTo);
        }
      }
    }
    if (awake == null) {
      return null;
    }
    return SleepAutofill(
      inBed: inBed,
      asleep: asleep,
      awake: awake,
      outBed: outBed,
    );
  }

  Future<SleepAutofill?> autofillRead30Day() async {
    if (!await request()) {
      return null;
    }

    DateTime now = DateTime.now();
    DateTime thisMorning = DateTime(now.year, now.month, now.day, 0, 0);
    DateTime startDate =
        thisMorning.subtract(const Duration(days: 30, hours: 12));
    DateTime endDate = DateTime.now();
    List<HealthDataPoint> healthData =
        await health.getHealthDataFromTypes(startDate, endDate, [
      HealthDataType.SLEEP_IN_BED,
      HealthDataType.SLEEP_ASLEEP,
    ]);

    List<SleepAutofill> entries = [];
    DateTime periodEnd = startDate.add(const Duration(days: 1));
    while (periodEnd.isBefore(endDate)) {
      DateTime periodStart = periodEnd.subtract(const Duration(days: 1));
      List<HealthDataPoint> nightData = [];
      healthData.removeWhere((point) {
        if (point.dateFrom.isAfter(periodStart) &&
            point.dateFrom.isBefore(periodEnd)) {
          // Muahahaha abusing functional programming
          nightData.add(point);
          return true;
        }
        return false;
      });
      SleepAutofill? nightAutofill = processNight(nightData);
      if (nightAutofill != null) {
        entries.add(nightAutofill);
      }
      periodEnd = periodEnd.add(const Duration(days: 1));
    }

    TimeOfDay? inBed = meanTimeOfDay(entries
        .where((e) => e.inBed != null)
        .map((e) => TimeOfDay(hour: e.inBed!.hour, minute: e.inBed!.minute)));
    TimeOfDay? asleep = meanTimeOfDay(entries
        .where((e) => e.asleep != null)
        .map((e) => TimeOfDay(hour: e.asleep!.hour, minute: e.asleep!.minute)));
    TimeOfDay? awake = meanTimeOfDay(entries
        .map((e) => TimeOfDay(hour: e.awake.hour, minute: e.awake.minute)));
    TimeOfDay? outBed = meanTimeOfDay(entries
        .where((e) => e.asleep != null)
        .map((e) => TimeOfDay(hour: e.outBed!.hour, minute: e.outBed!.minute)));
    if (awake == null) {
      return null;
    }

    DateTime? withTimeOfDay(DateTime date, TimeOfDay? time) {
      if (time == null) {
        return null;
      }
      return DateTime(date.year, date.month, date.day, time.hour, time.minute);
    }

    return SleepAutofill(
      inBed: withTimeOfDay(startDate, inBed),
      asleep: withTimeOfDay(startDate, asleep),
      awake: withTimeOfDay(startDate, awake)!,
      outBed: withTimeOfDay(startDate, outBed),
    );
  }

  Future<SleepAutofill?> autofillRead1Day() async {
    if (!await request()) {
      return null;
    }

    DateTime now = DateTime.now();
    DateTime thisMorning = DateTime(now.year, now.month, now.day, 0, 0);
    DateTime startDate = thisMorning.subtract(const Duration(hours: 12));
    DateTime endDate = DateTime.now();
    List<HealthDataPoint> healthData =
        await health.getHealthDataFromTypes(startDate, endDate, [
      HealthDataType.SLEEP_IN_BED,
      HealthDataType.SLEEP_ASLEEP,
    ]);

    return processNight(healthData);
  }
}

TimeOfDay? meanTimeOfDay(Iterable<TimeOfDay> items) {
  const double elipson = 0.0000001;
  // For fun, let's do some trigonometry
  double x = 0;
  double y = 0;
  for (var item in items) {
    double minutes = item.minute + item.hour * 60;
    double angle = minutes / 24 / 60 * 2 * pi;
    x += cos(angle);
    y += sin(angle);
  }
  if (-elipson < x && x < elipson && -elipson < y && y < elipson) {
    return null;
  }
  double angle = atan2(y, x);
  int minutes = (angle / 2 / pi * 24 * 60).toInt();
  return TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
}
