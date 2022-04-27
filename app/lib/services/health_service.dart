import 'dart:io';
import 'package:health/health.dart';

import 'package:hea/services/service_locator.dart';
import 'package:hea/services/logging_service.dart';

class SleepAutofill {
  final DateTime? inBed;
  final DateTime? asleep;
  final DateTime awake;

  const SleepAutofill({required this.inBed, this.asleep, required this.awake});

  toJson() => {
        "in-bed": inBed?.toIso8601String(),
        "asleep": asleep?.toIso8601String(),
        "awake": awake.toIso8601String(),
      };
}

class HealthService {
  final HealthFactory health = HealthFactory();

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

  Future<SleepAutofill?> autofillRead1Day() async {
    DateTime now = DateTime.now();
    DateTime thisMorning = DateTime(now.year, now.month, now.day, 0, 0);
    DateTime startDate = thisMorning.subtract(const Duration(hours: 12));
    DateTime endDate = DateTime.now();
    List<HealthDataPoint> healthData =
        await health.getHealthDataFromTypes(startDate, endDate, types);
    DateTime? inBed;
    DateTime? asleep;
    DateTime? awake;
    if (Platform.isIOS) {
      for (var data in healthData) {
        if (data.type == HealthDataType.SLEEP_IN_BED) {
          awake = data.dateTo;
          inBed = data.dateFrom;
        }
      }
      for (var data in healthData) {
        if (data.type == HealthDataType.SLEEP_ASLEEP) {
          awake = data.dateTo;
          asleep = data.dateFrom;
        }
      }
    } else if (Platform.isAndroid) {
      for (var data in healthData) {
        if (data.type == HealthDataType.SLEEP_ASLEEP) {
          awake = data.dateTo;
          if (data.sourceName == "com.northcube.sleepcycle") {
            inBed = data.dateFrom;
          } else {
            asleep = data.dateFrom;
          }
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
    );
  }
}
