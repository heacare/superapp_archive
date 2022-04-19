import 'package:health/health.dart';
import 'package:get_it/get_it.dart';

import 'package:hea/services/auth_service.dart';
import 'package:hea/services/service_locator.dart';
import 'package:hea/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:hea/models/user.dart';

import 'package:hea/screens/home.dart';
import 'package:hea/screens/onboarding/start.dart';
import 'package:hea/screens/onboarding/health_setup.dart';
import 'package:hea/screens/onboarding/basic_info.dart';
import 'package:hea/screens/onboarding/smoking.dart';
import 'package:hea/screens/onboarding/drinking.dart';
import 'package:hea/screens/onboarding/followup.dart';

final getIt = GetIt.instance;

enum OnboardingStep {
  health_sync,
  starter,
  basic_info,
  smoking,
  drinking,
  followups,
  end,
}

class OnboardingStepReturn {
  OnboardingStepReturn({required this.nextStep, required this.returnData});

  OnboardingStep nextStep;
  Map<String, dynamic> returnData;
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late OnboardingStep currentStep;

  // No reflections so we have to update through a map
  late final Map<String, dynamic> userJson;

  @override
  initState() {
    super.initState();
    currentStep = OnboardingStep.health_sync;

    // Onboard user
    final authUser = serviceLocator<AuthService>().currentUser()!;
    userJson = User(authUser.uid).toJson();

    // Pull health data
    WidgetsBinding.instance!.addPostFrameCallback((_) => Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => const HealthSetupScreen()))
            .then((value) {
          List<HealthDataPoint> healthData = value;
          userJson["healthData"] = healthData.map((e) => e.toJson()).toList();
        }));
  }

  void _reroute() {
    late Widget nextScreen;
    switch (currentStep) {
      case OnboardingStep.health_sync:
        nextScreen = const HealthSetupScreen();
        break;
      case OnboardingStep.starter:
        nextScreen = const OnboardingStartScreen();
        break;
      case OnboardingStep.basic_info:
        nextScreen = const OnboardingBasicInfoScreen();
        break;
      case OnboardingStep.smoking:
        nextScreen = const OnboardingSmokingScreen();
        break;
      case OnboardingStep.drinking:
        nextScreen = const OnboardingDrinkingScreen();
        break;
      case OnboardingStep.followups:
        nextScreen = const OnboardingFollowupScreen();
        break;
      case OnboardingStep.end:
      default:
        // Update through user service
        getIt<UserService>().updateUser(User.fromJson(userJson));

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Welcome to Happily Ever After!")));

        // Return to home screen
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false);

        return;
    }

    WidgetsBinding.instance!.addPostFrameCallback((_) => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => nextScreen))
            .then((value) {
          OnboardingStepReturn res = value;
          userJson.addAll(res.returnData);
          currentStep = res.nextStep;
          _reroute();
        }));
  }

  @override
  Widget build(BuildContext context) {
    _reroute();
    return Container();
  }
}
