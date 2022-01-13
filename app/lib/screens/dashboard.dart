import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hea/models/user.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hea/widgets/avatar_icon.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<User?>(builder: (context, user, _) {
      if (user == null) {
        return const Center(child: CircularProgressIndicator());
      }
      return DashboardPage.fromUser(user);
    });
  }
}

class DashboardPage extends StatelessWidget {
  final double expYears;
  final double optYears;
  final double socScore;

  DashboardPage(
      {Key? key,
      required this.expYears,
      required this.optYears,
      required this.socScore})
      : super(key: key);

  // TODO: ideally this logic should be stored and retrieved from the backend
  factory DashboardPage.fromUser(User user) {
    Random random = Random((user.height + user.age).round());
    // Wow imagine only considering two genders in 2021, omg cancelled
    double expYears =
        user.gender == "Male" ? 72.4 : 74.6 + (3.5 * random.nextDouble()) - 5;
    double optYears =
        user.gender == "Male" ? 87 : 92 + (2.5 * random.nextDouble()) - 2;
    double socScore = random.nextInt(21) + 5.0;
    return DashboardPage(
        expYears: expYears, optYears: optYears, socScore: socScore);
  }

  @override
  Widget build(BuildContext context) {
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
                                Text("Dashboard",
                                    style:
                                        Theme.of(context).textTheme.headline1),
                                Text("Good morning",
                                    style:
                                        Theme.of(context).textTheme.headline4),
                              ])),
                          AvatarIcon(),
                        ])))),
        body: Container(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DeathClock(
                    lifeScore: expYears, sleepScore: 30, socialScore: 60),
                SizedBox(height: 20.0),
                Text("Notifications",
                    style: Theme.of(context).textTheme.headline3),
                SizedBox(height: 10.0),
                UpcomingEvent(
                    title: "Health", provider: "Dan", time: DateTime.now())
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

  UpcomingEvent(
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
            margin: EdgeInsets.only(right: 15.0),
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              color: Color(0x0F000000),
            ),
            child: Center(
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

  DeathClock(
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
                  Color(0xFFFF7FAA),
                  Color(0xFFFF5576),
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
