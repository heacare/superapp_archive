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
  final DateTime? awake;
  final DateTime? outBed;

  const SleepAutofill(
      {required this.inBed,
      required this.asleep,
      required this.awake,
      required this.outBed});

  toJson() => {
        "in-bed": inBed?.toIso8601String(),
        "asleep": asleep?.toIso8601String(),
        "awake": awake?.toIso8601String(),
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
    if (asleep == null || awake == null) {
      return 0;
    }
    return ((awake!.minute + awake!.hour * 60) -
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
      await log60Days();
    });
    Timer.periodic(const Duration(hours: 8), (timer) async {
      var user = serviceLocator<AuthService>().currentUser();
      if (user == null) {
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
    if (!await request()) {
      return [];
    }

    DateTime startDate = DateTime.now().subtract(const Duration(days: 60));
    DateTime endDate = DateTime.now();
    return await health.getHealthDataFromTypes(startDate, endDate, types);
  }

  Future<bool> log60Days() async {
    List<HealthDataPoint> healthData = await get60Days();
    await serviceLocator<LoggingService>()
        .createLog('past-health-data', healthData);
    return healthData.isNotEmpty;
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
        // NOTE: For now, all Android data collected is not gonna be used for
        // autofill of sleep latency and sleep efficiency, because we cannot
        // yet "invert" the AWAKE state to find the ASLEEP state until we have
        // enough work put into the health plugin.
        if (data.type == HealthDataType.SLEEP_IN_BED) {
          inBed = earliest(inBed, data.dateFrom);
          outBed = latest(outBed, data.dateTo);
        } else if (data.type == HealthDataType.SLEEP_ASLEEP) {
          inBed = earliest(inBed, data.dateFrom);
          //asleep = earliest(asleep, data.dateFrom);
          //awake = latest(awake, data.dateTo);
          outBed = latest(outBed, data.dateTo);
        }
      }
    }
    for (var data in healthData) {
      if (Platform.isAndroid) {
        if (data.type == HealthDataType.SLEEP_AWAKE) {
          // For now, pick the earliest end of an AWAKE segment, which should
          // indicate a rough time of falling asleep. This AWAKE segment should
          // end very recently.
          const acceptable = Duration(hours: 1, minutes: 30);
          if (inBed != null && data.dateFrom.isBefore(inBed.add(acceptable))) {
            asleep = earliest(asleep, data.dateTo);
          }
          if (outBed != null &&
              data.dateFrom.isAfter(outBed.subtract(acceptable))) {
            awake = latest(asleep, data.dateFrom);
          }
        }
      }
    }
    if (healthData.isEmpty) {
      return null;
    }
    return SleepAutofill(
      inBed: inBed,
      asleep: asleep,
      awake: awake,
      outBed: outBed,
    );
  }

  Timer? cacheExpire;
  SleepAutofill? cache30Day;

  Future<SleepAutofill?> autofillRead30Day() async {
    if (!await request()) {
      return null;
    }

    if (cache30Day != null) {
      return cache30Day;
    }
    cacheExpire = Timer(const Duration(minutes: 10), () {
      cache30Day = null;
    });

    final stopwatch = Stopwatch();

    DateTime now = DateTime.now();
    DateTime thisMorning = DateTime(now.year, now.month, now.day, 0, 0);
    DateTime startDate =
        thisMorning.subtract(const Duration(days: 30, hours: 12));
    DateTime endDate = DateTime.now();

    stopwatch.start();
    List<HealthDataPoint> healthData =
        await health.getHealthDataFromTypes(startDate, endDate, [
      HealthDataType.SLEEP_IN_BED,
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.SLEEP_AWAKE,
    ]);
    int stopwatchFetch = stopwatch.elapsedMicroseconds;

    List<SleepAutofill> entries = [];
    DateTime periodEnd = startDate.add(const Duration(days: 1));
    int stopwatchProcessing = 0;
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
      stopwatchProcessing = stopwatch.elapsedMicroseconds;
      SleepAutofill? nightAutofill = processNight(nightData);
      if (nightAutofill != null) {
        entries.add(nightAutofill);
      }
      periodEnd = periodEnd.add(const Duration(days: 1));
    }
    int stopwatchProcessed = stopwatch.elapsedMicroseconds;

    TimeOfDay? inBed = meanTimeOfDay(entries
        .where((e) => e.inBed != null)
        .map((e) => TimeOfDay(hour: e.inBed!.hour, minute: e.inBed!.minute)));
    TimeOfDay? asleep = meanTimeOfDay(entries
        .where((e) => e.asleep != null)
        .map((e) => TimeOfDay(hour: e.asleep!.hour, minute: e.asleep!.minute)));
    TimeOfDay? awake = meanTimeOfDay(entries
        .where((e) => e.awake != null)
        .map((e) => TimeOfDay(hour: e.awake!.hour, minute: e.awake!.minute)));
    TimeOfDay? outBed = meanTimeOfDay(entries
        .where((e) => e.outBed != null)
        .map((e) => TimeOfDay(hour: e.outBed!.hour, minute: e.outBed!.minute)));
    int stopwatchCalculatedMean = stopwatch.elapsedMicroseconds;
    stopwatch.stop();
    serviceLocator<LoggingService>().createLog('perf-autofill-30-day', {
      "t-fetch": stopwatchFetch,
      "d-processNightx1": stopwatchProcessed - stopwatchProcessing,
      "t-processed": stopwatchProcessed,
      "t-calculatedMean": stopwatchCalculatedMean,
    });

    DateTime? withTimeOfDay(DateTime date, TimeOfDay? time) {
      if (time == null) {
        return null;
      }
      return DateTime(date.year, date.month, date.day, time.hour, time.minute);
    }

    cache30Day = SleepAutofill(
      inBed: withTimeOfDay(startDate, inBed),
      asleep: withTimeOfDay(startDate, asleep),
      awake: withTimeOfDay(startDate, awake),
      outBed: withTimeOfDay(startDate, outBed),
    );
    serviceLocator<LoggingService>()
        .createLog('sleep-autofill-30-day', cache30Day);
    return cache30Day;
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
      HealthDataType.SLEEP_AWAKE,
    ]);

    SleepAutofill? day = processNight(healthData);
    serviceLocator<LoggingService>().createLog("sleep-autofill", day);
    return day;
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
