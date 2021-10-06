import 'package:flutter/material.dart';
import 'package:health/health.dart';

class HealthSetupScreen extends StatefulWidget {
  const HealthSetupScreen({Key? key}) : super(key: key);

  @override
  State<HealthSetupScreen> createState() => _HealthSetupScreenState();
}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED
}

class _HealthSetupScreenState extends State<HealthSetupScreen> {
  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;

  @override
  void initState() {
    super.initState();
  }

  Future fetchData() async {
    HealthFactory health = HealthFactory();

    // Define the types to get
    List<HealthDataType> types = [
      HealthDataType.WEIGHT,
      HealthDataType.HEIGHT,
      HealthDataType.BODY_FAT_PERCENTAGE,
      HealthDataType.BODY_MASS_INDEX,
    ];

    setState(() => _state = AppState.FETCHING_DATA);

    // OAuth request authorization to data
    bool accessWasGranted = await health.requestAuthorization(types);
    if (!accessWasGranted) {
      print("Authorization not granted");
      setState(() => _state = AppState.DATA_NOT_FETCHED);

      return;
    }

    // TODO On Android requires Google Fit to be installed or data will be empty
    try {
      // Fetch data from 1st Jan 2000 till current date
      DateTime startDate = DateTime(2000);
      DateTime endDate = DateTime.now();
      List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(startDate, endDate, types);

      _healthDataList.addAll(healthData);

      // Filter out duplicates
      _healthDataList = HealthFactory.removeDuplicates(_healthDataList);
      for (var h in _healthDataList) {
        print("${h.typeString}: ${h.value} [${h.unitString}]");
      }

      Navigator.of(context).pop(_healthDataList);
    } catch (e) {
      print("Caught exception in getHealthDataFromTypes: $e");
    }

  }

  Widget _contentFetchingData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: const EdgeInsets.all(20),
            child: const CircularProgressIndicator(
              strokeWidth: 10,
            )),
        const Text('Fetching data...')
      ],
    );
  }

  Widget _contentDataReady() {
    return ListView.builder(
        itemCount: _healthDataList.length,
        itemBuilder: (_, index) {
          HealthDataPoint p = _healthDataList[index];
          return ListTile(
            title: Text("${p.typeString}: ${p.value}"),
            trailing: Text(p.unitString),
            subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
          );
        });
  }

  Widget _contentNoData() {
    return const Text('No Data to show');
  }

  Widget _contentNotFetched() {
    return ElevatedButton(
      child: const Text("Sync health data"),
      onPressed: fetchData,
    );
  }

  Widget _authorizationNotGranted() {
    return Column(
      children: [
        const Text('''
          Authorization not given.
          For Android please check your OAUTH2 client ID is correct in Google Developer Console.
          For iOS check your permissions in Apple Health.
        '''),
        ElevatedButton(
          child: const Text("Try again"),
          onPressed: fetchData
        )
      ]
    );
  }

  Widget _content() {
    if (_state == AppState.DATA_READY) {
      return _contentDataReady();
    } else if (_state == AppState.NO_DATA) {
      return _contentNoData();
    } else if (_state == AppState.FETCHING_DATA) {
      return _contentFetchingData();
    } else if (_state == AppState.AUTH_NOT_GRANTED) {
      return _authorizationNotGranted();
    }

    return _contentNotFetched();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Link Health Data'),
      ),
      body: Center(
          child: _content(),
      )
    );
  }
}
