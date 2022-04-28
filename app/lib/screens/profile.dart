import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hea/services/sleep_checkin_service.dart';
import 'package:hea/screens/login.dart';
import 'package:hea/models/user.dart';
import 'package:hea/services/api_manager.dart';
import 'package:hea/services/auth_service.dart';
import 'package:hea/services/notification_service.dart';
import 'package:hea/services/health_service.dart';
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

  Future<void> send60DaysHealthData() async {
    if (!await serviceLocator<HealthService>().request()) {
      return;
    }
    await serviceLocator<HealthService>().log60Days();
    SleepAutofill? day =
        await serviceLocator<HealthService>().autofillRead1Day();
    await serviceLocator<LoggingService>().createLog("sleep-autofill", day);
  }

  Future<void> scheduleDemoNotification() async {
    await serviceLocator<NotificationService>().showContentReminder(
        1,
        "sleep_content",
        "Hop right in",
        "Hi {name}! To get started, tell us how you'll be getting your sleep and health data",
        minHoursLater: 1);
  }

  SleepAutofill? sleep;

  @override
  Widget build(BuildContext context) {
    serviceLocator<ApiManager>().get("/"); // What is this for?

    serviceLocator<HealthService>().autofillRead1Day().then((data) {
      setState(() {
        sleep = data;
      });
    });

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
                          await send60DaysHealthData();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: const Text("Health data sent")));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())));
                        }
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
                  Text(
                      "In-bed: ${sleep?.inBed} Asleep: ${sleep?.asleep} Awake: ${sleep?.awake}"),
                ])));
  }
}
