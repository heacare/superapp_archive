import 'package:flutter/material.dart';
import 'package:hea/widgets/firebase_svg.dart';
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

      Navigator.of(context, rootNavigator: true).pop(_healthDataList);
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
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
              strokeWidth: 8,
            ))
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

  Widget _contentNotFetched() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FirebaseSvg("health_sync.svg").load()
          )
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                child: Text("Sync with Apple Health", style: Theme.of(context).textTheme.headline1),
                padding: const EdgeInsets.symmetric(vertical: 16.0)
              ),
              Text(
                "Let’s get some data from you so we can accurately make predictions and offer advice.",
                style: Theme.of(context).textTheme.headline2
              ),
              Padding(
                child: OutlinedButton(
                  child: const Text("SYNC TO APPLE"),
                  onPressed: fetchData,
                ),
                padding: const EdgeInsets.symmetric(vertical: 32.0)
              )
            ],
          )
        )
      ]
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
      body: Center(
        child: _content(),
      )
    );
  }
}
