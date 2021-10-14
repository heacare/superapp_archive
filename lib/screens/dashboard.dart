import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hea/data/user_repo.dart';
import 'package:hea/models/user.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<User?> userFuture = UserRepo().getCurrent();
    return FutureBuilder(
        future: userFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error!");
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data == null) {
            return const Text("No user?!");
          }
          return DashboardPage.fromUser(snapshot.data as User);
        });
  }
}

class DashboardPage extends StatelessWidget {
  final double expYears;
  final double optYears;
  final double socScore;

  DashboardPage({
    Key? key,
    required this.expYears,
    required this.optYears,
    required this.socScore
  }) : super(key: key);

  // TODO: ideally this logic should be stored and retrieved from the backend
  factory DashboardPage.fromUser(User user){
    Random random = Random((user.height+user.age).round());
    // Wow imagine only considering two genders in 2021, omg cancelled
    double expYears = user.gender == "Male" ? 72.4 : 74.6
        + (3.5 * random.nextDouble()) - 5;
    double optYears = user.gender == "Male" ? 87 : 92
        + (2.5 * random.nextDouble()) - 2;
    double socScore = random.nextInt(21) + 5.0;
    return DashboardPage(
      expYears: expYears,
      optYears: optYears,
      socScore: socScore
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DeathClock(expYears: expYears, optYears: optYears),
            Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  child: Text(
                    "Good morning, looks like you're on track for a great day!",
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.center,
                  ),
                )),
            ScoreBoard(optYears: optYears, socScore: socScore),
          ],
        ),
      ),
    );
  }
}


class DeathClock extends StatelessWidget {
  final double expYears;
  final double optYears;
  final double max = 100;
  final double min = 0;

  DeathClock({Key? key, required this.expYears, required this.optYears})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const gaugeWidth = 0.15;

    return Container(
      child: SfRadialGauge(
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
              thicknessUnit: GaugeSizeUnit.factor,
              color: Color.fromARGB(255, 238, 238, 238),
            ),
            pointers: [
              RangePointer(
                animationType: AnimationType.ease,
                value: optYears,
                color: Theme.of(context).colorScheme.primary,
                width: gaugeWidth,
                sizeUnit: GaugeSizeUnit.factor,
                cornerStyle: CornerStyle.bothCurve,
              ),
              RangePointer(
                value: expYears,
                color: Theme.of(context).colorScheme.secondary,
                width: gaugeWidth,
                sizeUnit: GaugeSizeUnit.factor,
                cornerStyle: CornerStyle.bothCurve,
              ),
            ],
            annotations: [
              GaugeAnnotation(
                  verticalAlignment: GaugeAlignment.center,
                  horizontalAlignment: GaugeAlignment.center,
                  axisValue: max/2,
                  positionFactor: 0.85,
                  widget: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        expYears.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.headline1?.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 70,
                          color: Theme.of(context).colorScheme.secondary
                        ),
                      ),
                      Text(
                        "years",
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.secondary
                        ),
                      ),
                  ],
                ))
            ],
          )
        ],
      ),
    );
  }
}

class ScoreCard extends StatelessWidget {
  final IconData icon;
  final double value;
  final String label;
  final Color color;

  ScoreCard({Key? key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double size = 60;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: size,
                color: color,
              ),
              Text(
                  value.toStringAsFixed(0),
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: color,
                    fontSize: size,
                    fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyText1,
          )
        ],
      ),
    );
  }
}

class ScoreBoard extends StatelessWidget {
  final double optYears;
  final double socScore;
  final double iconSize = 24;

  const ScoreBoard({Key? key, required this.optYears, required this.socScore})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ScoreCard(
            icon: Icons.favorite,
            value: optYears,
            label: "optimal years",
            color: Theme.of(context).colorScheme.primary,
          ),
          VerticalDivider(color: Colors.red),
          ScoreCard(
            icon: Icons.psychology,
            value: socScore,
            label: "social score",
            color: Colors.deepOrange,
          )
        ],
      ),
    );
  }
}
