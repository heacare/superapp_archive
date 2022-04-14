import 'package:flutter/material.dart';
import 'package:hea/models/user.dart';
import 'package:health/health.dart';

import 'package:hea/screens/login.dart';
import 'package:hea/services/api_manager.dart';
import 'package:hea/services/auth_service.dart';
import 'package:hea/services/notification_service.dart';
import 'package:hea/services/service_locator.dart';
import 'package:hea/widgets/avatar_icon.dart';
import 'package:hea/widgets/gradient_button.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future logout() async {
    await serviceLocator<AuthService>().logout();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
      return LoginScreen();
    }), (route) => false);
  }

  Future<void> sendDemoHealthData() async {
    HealthFactory health = HealthFactory();

    // Define the types to get
    List<HealthDataType> types = [
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

    // OAuth request authorization to data
    bool accessWasGranted = await health.requestAuthorization(types);
    if (!accessWasGranted) {
      print("Authorization not granted");
      return;
    }

    // TODO On Android requires Google Fit to be installed or data will be empty
    try {
      // Fetch data from 1st Jan 2000 till current date
      DateTime startDate = DateTime(2000);
      DateTime endDate = DateTime.now();
      List<HealthDataPoint> healthData =
          await health.getHealthDataFromTypes(startDate, endDate, types);

      List<HealthDataPoint> _healthDataList = [];
      _healthDataList.addAll(healthData);

      // Filter out duplicates
      _healthDataList = HealthFactory.removeDuplicates(_healthDataList);
      for (var h in _healthDataList) {
        print(
            "${h.typeString}: ${h.dateFrom} ${h.dateTo} ${h.value} [${h.unitString}]");
      }
    } catch (e) {
      print("Caught exception in getHealthDataFromTypes: $e");
    }
  }

  Future<void> triggerDemoNotification() async {
    await serviceLocator<NotificationService>().showReminder(
        0,
        "sleep_reminders",
        "Time to wind down",
        "Remember to _____ today",
        "wind-down");
    await serviceLocator<NotificationService>().showDemoContentReminder(
        1,
        "sleep_content",
        "Hop right in",
        "Hi <name>! To get started, tell us how you'll be getting your sleep and health data");
  }

  @override
  Widget build(BuildContext context) {
    serviceLocator<ApiManager>().get("/");
    return Consumer<User?>(builder: (context, user, _) {
      if (user == null) {
        return const Center(child: CircularProgressIndicator());
      }
      return loaded(user);
    });
  }

  Widget loaded(User user) {
    final name = user.name;
    final height = user.height.toString() + "m";
    final weight = user.weight.toString() + "kg";
    final country = user.country;
    final gender = user.gender;
    final icon = user.icon;

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(150),
            child: SafeArea(
                child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                Text("Settings",
                                    style:
                                        Theme.of(context).textTheme.headline1),
                                SizedBox(height: 4.0),
                                Text("Modify your preferences",
                                    style:
                                        Theme.of(context).textTheme.headline4),
                              ])),
                          AvatarIcon(),
                        ])))),
        body: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GradientButton(
                      text: "Notification Preferences",
                      onPressed: () => serviceLocator<NotificationService>()
                          .showPreferences()),
                  const SizedBox(height: 8.0),
                  GradientButton(text: "Logout", onPressed: logout),
                  const SizedBox(height: 32.0),
                  GradientButton(
                      text: "Send Demo Health Data",
                      onPressed: sendDemoHealthData),
                  const SizedBox(height: 8.0),
                  GradientButton(
                      text: "Trigger Demo Notification",
                      onPressed: triggerDemoNotification)
                ])));
  }
}
