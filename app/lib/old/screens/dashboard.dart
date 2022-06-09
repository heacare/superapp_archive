import 'dart:math';
import 'package:flutter/material.dart' hide Page;
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../models/onboarding_types.dart';
import '../services/service_locator.dart';
import '../services/logging_service.dart';
import '../services/sleep_checkin_service.dart';
import '../widgets/avatar_icon.dart';
import '../widgets/page.dart';
import 'sleep_checkin.dart';
import '../utils/kv_wrap.dart';
import '../utils/sleep_notifications.dart';

import '../pages/sleep/lookup.dart';
import '../pages/sleep_review/lookup.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DashboardPage(
        expYears: 0, optYears: 0, socScore: 0, name: "user");
  }
}

class DashboardPage extends StatelessWidget {
  final double expYears;
  final double optYears;
  final double socScore;
  final String name;

  const DashboardPage(
      {Key? key,
      required this.expYears,
      required this.optYears,
      required this.socScore,
      required this.name})
      : super(key: key);

  // TODO: ideally this logic should be stored and retrieved from the backend
  factory DashboardPage.fromUser(User user) {
    Random random = Random((user.height + user.age).round());
    // Wow imagine only considering two genders in 2021, omg cancelled
    double expYears = user.gender == Gender.Male
        ? 72.4
        : 74.6 + (3.5 * random.nextDouble()) - 5;
    double optYears =
        user.gender == Gender.Male ? 87 : 92 + (2.5 * random.nextDouble()) - 2;
    double socScore = random.nextInt(21) + 5.0;
    String name = user.name;
    return DashboardPage(
        expYears: expYears, optYears: optYears, socScore: socScore, name: name);
  }

  @override
  Widget build(BuildContext context) {
    serviceLocator<LoggingService>().createLog('navigate', 'home');
    final moduleListView = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: const [
          ModuleListItem(
              title: "Sleep and Recovery",
              description:
                  "Learn about the benefits and howtos of a good night of sleep",
              gradient1: Color(0xFF00ABE9),
              gradient2: Color(0xFF7FDDFF),
              icon: FontAwesomeIcons.solidMoon),
          SizedBox(height: 10.0),
          /*
              ModuleListItem(
                  title: "Mental Hygiene",
                  description:
                      "Sneak preview of our upcoming Mental Hygiene module",
                  gradient1: const Color(0xFFFFC498),
                  gradient2: const Color(0xFFFF7A60),
                  icon: FontAwesomeIcons.peopleArrows,
                  module: modules[1])
			  */
        ]);

    Widget moduleCheckinListView =
        Consumer<SleepCheckinProgress>(builder: (context, progress, child) {
      TimeOfDay? diaryReminderTimes =
          kvReadTimeOfDay("sleep", "diary-reminder-times");
      List<Widget> list = [];
      if (diaryReminderTimes != null) {
        list.add(ModuleCheckinItem(
            "Sleep check-in day ${progress.dayCounter} of ${progress.total}",
            "Keep track of how you slept last night",
            (context) => const SleepCheckin(),
            progress.todayDone));
      }
      bool reviewForce =
          serviceLocator<SharedPreferences>().getBool('review-force') ?? false;
      debugPrint(reviewForce.toString());
      if ((progress.allDone && progress.lastCheckIn != null) || reviewForce) {
        bool show = true;
        if (progress.lastCheckIn != null) {
          // Last check-in time
          DateTime last = progress.lastCheckIn!;
          DateTime now = DateTime.now();
          show = now.isAfter(last.add(const Duration(days: 30)));
          debugPrint("last check in show: $show");
        }
        if (reviewForce) {
          show = true;
        }
        if (kvRead<bool>("sleep", "review-done") ?? false) {
          show = false;
          debugPrint("review done, no show");
        }
        list.add(ModuleCheckinItem("30-day post-journey check-in",
            "Let us know how you are sleeping now", (context) {
          String? s =
              serviceLocator<SharedPreferences>().getString('sleep_review');
          PageBuilder resume = sleep_review.lookup(s);
          serviceLocator<LoggingService>().createLog('navigate', s);
          serviceLocator<LoggingService>().createLog('navigate', 'home');
          scheduleSleepNotifications(debounce: false);
          return resume();
        }, !show));
      }
      if (list.isNotEmpty) {
        return Column(
            children:
                list.expand((w) => [w, const SizedBox(height: 10)]).toList());
      }
      return const Text("Not available");
    });

    String goodMorning = "Good morning";
    if (name.isNotEmpty) {
      goodMorning += ", $name";
    }

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
                                Text("Dashboard",
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                                Text(goodMorning,
                                    style:
                                        Theme.of(context).textTheme.titleSmall),
                              ])),
                          const AvatarIcon(),
                        ])))),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /*
                DeathClock(
                    lifeScore: expYears, sleepScore: 30, socialScore: 60),
			    */
                const SizedBox(height: 20.0),
                Text("Modules", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10.0),
                moduleListView,
                const SizedBox(height: 30.0),
                Text("Check-ins",
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 10.0),
                ChangeNotifierProvider.value(
                  value: serviceLocator<SleepCheckinService>().getProgress(),
                  child: moduleCheckinListView,
                ),
                const SizedBox(height: 30.0),
              ],
            ),
          ),
        ));
  }
}

class UpcomingEvent extends StatelessWidget {
  final String title;
  final String provider;
  final DateTime time;

  const UpcomingEvent(
      {Key? key,
      required this.title,
      required this.provider,
      required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), //color of shadow
            blurRadius: 5, // blur radius
            offset: const Offset(0, 2), // changes position of shadow
          )
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Row(children: <Widget>[
        Container(
            margin: const EdgeInsets.only(right: 15.0),
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              color: Color(0x0F000000),
            ),
            child: const Center(
                child:
                    FaIcon(FontAwesomeIcons.solidHeart, color: Colors.white))),
        Expanded(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Text("Health Checkup",
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      ?.copyWith(color: Colors.white)),
              Text("Dan Green • Tuesday, 3PM",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: Colors.white))
            ])),
      ]),
    );
  }
}

class DeathClock extends StatelessWidget {
  final double lifeScore;
  final double sleepScore;
  final double socialScore;
  final double max = 100;
  final double min = 0;

  const DeathClock(
      {Key? key,
      required this.lifeScore,
      required this.sleepScore,
      required this.socialScore})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const gaugeWidth = 25.0;

    return SfRadialGauge(
      enableLoadingAnimation: true,
      animationDuration: 700,
      axes: [
        RadialAxis(
          minimum: min,
          maximum: max,
          startAngle: 270,
          endAngle: 270,
          showLabels: false,
          showTicks: false,
          axisLineStyle: const AxisLineStyle(
            thickness: gaugeWidth,
            color: Color.fromARGB(255, 238, 238, 238),
          ),
          pointers: [
            RangePointer(
              animationType: AnimationType.ease,
              value: lifeScore,
              gradient: const SweepGradient(
                colors: <Color>[
                  Color(0xFFF5877A),
                  Color(0xFFFCB553),
                ],
              ),
              width: gaugeWidth,
              cornerStyle: CornerStyle.bothCurve,
            ),
          ],
        ),
        RadialAxis(
          minimum: min,
          maximum: max,
          radiusFactor: 0.77,
          startAngle: 270,
          endAngle: 270,
          showLabels: false,
          showTicks: false,
          axisLineStyle: const AxisLineStyle(
            thickness: gaugeWidth,
            color: Color.fromARGB(255, 238, 238, 238),
          ),
          pointers: [
            RangePointer(
              animationType: AnimationType.ease,
              value: sleepScore,
              gradient: const SweepGradient(
                colors: <Color>[
                  Color(0xFF7FDDFF),
                  Color(0xFF00ABE9),
                ],
              ),
              width: gaugeWidth,
              cornerStyle: CornerStyle.bothCurve,
            ),
          ],
        ),
        RadialAxis(
          minimum: min,
          maximum: max,
          radiusFactor: 0.59,
          startAngle: 270,
          endAngle: 270,
          showLabels: false,
          showTicks: false,
          axisLineStyle: const AxisLineStyle(
            thickness: gaugeWidth,
            color: Color.fromARGB(255, 238, 238, 238),
          ),
          pointers: [
            RangePointer(
              animationType: AnimationType.ease,
              value: socialScore,
              gradient: const SweepGradient(
                colors: <Color>[
                  Color(0xFFFFC498),
                  Color(0xFFFF7A60),
                ],
              ),
              width: gaugeWidth,
              cornerStyle: CornerStyle.bothCurve,
            ),
          ],
          annotations: [
            GaugeAnnotation(
                horizontalAlignment: GaugeAlignment.center,
                verticalAlignment: GaugeAlignment.center,
                angle: 90,
                widget: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Text(lifeScore.toStringAsFixed(1),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline1),
                    Text("years", style: Theme.of(context).textTheme.bodyText1),
                  ],
                ))
          ],
        )
      ],
    );
  }
}

class ModuleListItem extends StatelessWidget {
  final String title;
  final String description;
  final Color gradient1;
  final Color gradient2;
  final IconData icon;

  const ModuleListItem(
      {Key? key,
      required this.title,
      required this.description,
      required this.gradient1,
      required this.gradient2,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          String? s = serviceLocator<SharedPreferences>().getString('sleep');
          PageBuilder resume = sleep.lookup(s);
          serviceLocator<LoggingService>().createLog('navigate', s);
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => resume()));
          serviceLocator<LoggingService>().createLog('navigate', 'home');
          scheduleSleepNotifications(debounce: false);
        },
        child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            decoration: const BoxDecoration(
              color: Color(0xFFEBEBEB),
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: Row(children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(right: 15.0),
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          gradient1,
                          gradient2,
                        ]),
                  ),
                  child: Center(child: FaIcon(icon, color: Colors.white))),
              Expanded(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 5.0),
                    Text(description,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: const Color(0xFF707070)))
                  ])),
            ])));
  }
}

class ModuleCheckinItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final WidgetBuilder nextPage;
  final bool fade;

  const ModuleCheckinItem(this.title, this.subtitle, this.nextPage, this.fade,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          if (fade) {
            return;
          }
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: nextPage));
        },
        child: Opacity(
            opacity: fade ? 0.2 : 1.0,
            child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 20.0),
                decoration: const BoxDecoration(
                  color: Color(0xFFEBEBEB),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                child: Row(children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(right: 15.0),
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF00ABE9),
                              Color(0xFF7FDDFF),
                            ]),
                      ),
                      child: const Center(
                          child: FaIcon(FontAwesomeIcons.solidMoon,
                              color: Colors.white))),
                  Expanded(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                        Text(title,
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 5.0),
                        Text(subtitle,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: const Color(0xFF707070)))
                      ])),
                ]))));
  }
}