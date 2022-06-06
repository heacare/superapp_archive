// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../utils/kv_wrap.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/sleep_checkin_service.dart';
import '../services/notification_service.dart';
import '../services/health_service.dart';
import '../services/logging_service.dart';
import '../services/service_locator.dart';
import '../widgets/avatar_icon.dart';
import '../widgets/gradient_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool developerExpanded = false;

  Future logout() async {
    await serviceLocator<LoggingService>().createLog('logout', '');
  }

  Future<String> send60DaysHealthData() async {
    bool hasData = await serviceLocator<HealthService>().log60Days();
    await serviceLocator<HealthService>().autofillRead1Day();
    await serviceLocator<HealthService>().autofillRead30Day();
    return hasData ? "Health data sent" : "No health data available";
  }

  @override
  Widget build(BuildContext context) {
    serviceLocator<LoggingService>().createLog('navigate', 'profile');
    return loaded();
  }

  Widget loaded() {
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
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GradientButton(
                      text: "Notification preferences",
                      onPressed: () => serviceLocator<NotificationService>()
                          .showPreferences()),
                  const SizedBox(height: 8.0),
                  GradientButton(text: "Logout", onPressed: logout),
                  const SizedBox(height: 32.0),
                  GradientButton(
                      text: "Send 60 days health data",
                      onPressed: () async {
                        try {
                          String info = await send60DaysHealthData();
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(info)));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())));
                        }
                      }),
                  const SizedBox(height: 32.0),
                  GradientButton(
                      text:
                          "${developerExpanded ? "Hide" : "Show"} developer options",
                      onPressed: () {
                        setState(() {
                          developerExpanded = !developerExpanded;
                        });
                      }),
                  if (developerExpanded)
                    Column(children: [
                      const SizedBox(height: 8.0),
                      GradientButton(
                          text: "Show autofill sleep data",
                          onPressed: () async {
                            var sleep = await serviceLocator<HealthService>()
                                .autofillRead1Day();
                            var sleep30 = await serviceLocator<HealthService>()
                                .autofillRead30Day();
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: const Text("Autofill sleep data"),
                                      content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("1-day",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge),
                                            Text(
                                                "In-bed: ${sleep?.inBed}\nAsleep: ${sleep?.asleep}\nAwake: ${sleep?.awake}\nOut-bed: ${sleep?.outBed}"),
                                            Text("30-day",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge),
                                            Text(
                                                "In-bed: ${sleep30?.inBed}\nAsleep: ${sleep30?.asleep}\nAwake: ${sleep30?.awake}\nOut-bed: ${sleep30?.outBed}"),
                                          ]),
                                      actions: [
                                        TextButton(
                                            child: const Text("Close"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            }),
                                      ]);
                                });
                          }),
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
                                              serviceLocator<
                                                      SleepCheckinService>()
                                                  .reset();
                                              serviceLocator<
                                                      SharedPreferences>()
                                                  .remove('data-sleep');
                                              serviceLocator<LoggingService>()
                                                  .createLog(
                                                      "sleep", {"reset": true});
                                              serviceLocator<
                                                      SharedPreferences>()
                                                  .remove('sleep');
                                              serviceLocator<
                                                      SharedPreferences>()
                                                  .remove('review-force');
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
                                              serviceLocator<
                                                      SleepCheckinService>()
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
                                              var s = SleepCheckinData();
                                              s.timeGoBed = const TimeOfDay(
                                                  hour: 23, minute: 59);
                                              s.timeAsleepBed = const TimeOfDay(
                                                  hour: 0, minute: 0);
                                              s.timeOutBed = const TimeOfDay(
                                                  hour: 0, minute: 1);
                                              serviceLocator<
                                                      SleepCheckinService>()
                                                  .add(s);
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
                                              serviceLocator<
                                                      SharedPreferences>()
                                                  .remove('sleep');
                                              Navigator.of(context).pop();
                                            }),
                                      ]);
                                });
                          }),
                      const SizedBox(height: 8.0),
                      GradientButton(
                          text: "Disable daily check-in",
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: const Text(
                                          "Are you sure you want to disable daily check-ins?"),
                                      actions: [
                                        TextButton(
                                            child: const Text("No"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            }),
                                        TextButton(
                                            child: const Text("Yes"),
                                            onPressed: () {
                                              kvDelete("sleep",
                                                  "diary-reminder-times");
                                              Navigator.of(context).pop();
                                            }),
                                      ]);
                                });
                          }),
                      const SizedBox(height: 8.0),
                      GradientButton(
                          text: "Enable 30-day check-in",
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: const Text(
                                          "Are you sure you want to re-enable 30-day check-in?"),
                                      actions: [
                                        TextButton(
                                            child: const Text("No"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            }),
                                        TextButton(
                                            child: const Text("Yes"),
                                            onPressed: () {
                                              kvDelete("sleep", "review-done");
                                              serviceLocator<
                                                      SharedPreferences>()
                                                  .setBool(
                                                      'review-force', true);
                                              Navigator.of(context).pop();
                                            }),
                                      ]);
                                });
                          }),
                      const SizedBox(height: 8.0),
                    ])
                ])));
  }
}
