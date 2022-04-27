import 'package:health/health.dart';

class HealthService {
	final HealthFactory health = HealthFactory();

    // Define the types to get
    final List<HealthDataType> types = [
      HealthDataType.WEIGHT,
      HealthDataType.HEIGHT,
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.BLOOD_OXYGEN,
      HealthDataType.BODY_FAT_PERCENTAGE,
      HealthDataType.BODY_MASS_INDEX,
      HealthDataType.HEART_RATE,
      HealthDataType.STEPS,
      //HealthDataType.SLEEP_IN_BED,
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.SLEEP_AWAKE,
    ];
  
  Future<bool> request() async {
    // OAuth request authorization to data
    return await health.requestAuthorization(types);
  }

  Future<void> log60Days() async {
    try {
      // Fetch data from 1st Jan 2000 till current date
      DateTime startDate = DateTime.now().subtract(Duration(days: 60));
      DateTime endDate = DateTime.now();
      List<HealthDataPoint> healthData =
          await health.getHealthDataFromTypes(startDate, endDate, types);

      List<HealthDataPoint> _healthDataList = [];
      _healthDataList.addAll(healthData);

      // Filter out duplicates
      _healthDataList = HealthFactory.removeDuplicates(_healthDataList);
      await serviceLocator<LoggingService>()
          .createLog('past-health-data', _healthDataList);
    } catch (e) {
      debugPrint("Caught exception in getHealthDataFromTypes: $e");
    }
