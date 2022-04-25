import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hea/services/sleep_checkin_service.dart';
import 'package:hea/screens/login.dart';
import 'package:hea/models/user.dart';
import 'package:hea/services/api_manager.dart';
import 'package:hea/services/auth_service.dart';
import 'package:hea/services/notification_service.dart';
import 'package:hea/services/logging_service.dart';
import 'package:hea/services/service_locator.dart';
import 'package:hea/widgets/avatar_icon.dart';
import 'package:hea/widgets/gradient_button.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future logout() async {
    await serviceLocator<LoggingService>().createLog('logout', '');
    await serviceLocator<AuthService>().logout();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
      return const LoginScreen();
    }), (route) => false);
  }

  Future<void> sendPastHealthData() async {
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
      debugPrint("Authorization not granted");
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
      await serviceLocator<LoggingService>()
          .createLog('past-health-data', _healthDataList);
    } catch (e) {
      debugPrint("Caught exception in getHealthDataFromTypes: $e");
    }
  }

  Future<void> scheduleDemoNotification() async {
    await serviceLocator<NotificationService>().showContentReminder(
        1,
        "sleep_content",
        "Hop right in",
        "Hi {name}! To get started, tell us how you'll be getting your sleep and health data",
        minHoursLater: 1);
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
    // ignore: unused_local_variable
    final name = user.name;
    // ignore: unused_local_variable
    final height = user.height.toString() + "m";
    // ignore: unused_local_variable
    final weight = user.weight.toString() + "kg";
    // ignore: unused_local_variable
    final country = user.country;
    // ignore: unused_local_variable
    final gender = user.gender;
    // ignore: unused_local_variable
    final icon = user.icon;

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(150),
            child: SafeArea(
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 30.0),
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
                                const SizedBox(height: 4.0),
                                Text("Modify your preferences",
                                    style:
                                        Theme.of(context).textTheme.headline4),
                              ])),
                          const AvatarIcon(),
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
                      text: "Send Past Health Data",
                      onPressed: sendPastHealthData),
                  const SizedBox(height: 8.0),
                  GradientButton(
                      text: "Reset all content state",
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: const Text(
                                      "Are you sure you want to reset all content state?"),
                                  actions: [
                                    TextButton(
                                        child: const Text("No"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }),
                                    TextButton(
                                        child: const Text("Yes"),
                                        onPressed: () {
                                          serviceLocator<SleepCheckinService>()
                                              .reset();
                                          serviceLocator<SharedPreferences>()
                                              .remove('data-sleep');
                                          serviceLocator<LoggingService>()
                                              .createLog(
                                                  "sleep", {"reset": true});
                                          serviceLocator<SharedPreferences>()
                                              .remove('sleep');
                                          Navigator.of(context).pop();
                                        }),
                                  ]);
                            });
                      }),
                  const SizedBox(height: 8.0),
                  GradientButton(
                      text: "Reset daily check-in",
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: const Text(
                                      "Are you sure you want to reset daily check-in?"),
                                  actions: [
                                    TextButton(
                                        child: const Text("No"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }),
                                    TextButton(
                                        child: const Text("Yes"),
                                        onPressed: () {
                                          serviceLocator<SleepCheckinService>()
                                              .reset();
                                          Navigator.of(context).pop();
                                        }),
                                  ]);
                            });
                      }),
                  const SizedBox(height: 8.0),
                  GradientButton(
                      text: "Skip 1 day of daily check-in",
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: const Text(
                                      "Are you sure you want to skip 1 day of daily check-in?"),
                                  actions: [
                                    TextButton(
                                        child: const Text("No"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }),
                                    TextButton(
                                        child: const Text("Yes"),
                                        onPressed: () {
                                          serviceLocator<SleepCheckinService>()
                                              .add(SleepCheckinData());
                                          Navigator.of(context).pop();
                                        }),
                                  ]);
                            });
                      }),
                  const SizedBox(height: 8.0),
                  GradientButton(
                      text: "Jump to start of content",
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: const Text(
                                      "Are you sure you want to jump to start of content?"),
                                  actions: [
                                    TextButton(
                                        child: const Text("No"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }),
                                    TextButton(
                                        child: const Text("Yes"),
                                        onPressed: () {
                                          serviceLocator<SharedPreferences>()
                                              .remove('sleep');
                                          Navigator.of(context).pop();
                                        }),
                                  ]);
                            });
                      }),
                  const SizedBox(height: 8.0),
                ])));
  }
}
