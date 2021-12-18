import 'package:flutter/material.dart';
import 'package:hea/providers/auth.dart';
import 'package:hea/data/user_repo.dart';
import 'package:hea/models/user.dart';

import 'package:hea/screens/home.dart';
import 'package:hea/screens/onboarding/start.dart';
import 'package:hea/screens/onboarding/health_setup.dart';
import 'package:hea/screens/onboarding/basic_info.dart';
import 'package:hea/screens/onboarding/smoking.dart';
import 'package:hea/screens/onboarding/drinking.dart';
import 'package:hea/screens/onboarding/followup.dart';

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
  OnboardingStepReturn({@required this.nextStep = OnboardingStep.end, @required this.returnData = const <String, dynamic>{}});

  OnboardingStep nextStep;
  Map<String, dynamic> returnData;
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key,}) :
        super(key: key);

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
    final authUser = Authentication().currentUser()!;
    userJson = User(authUser.uid).toJson();
  }

  void _reroute() {
    late Widget nextScreen;
    switch (currentStep) {
      case OnboardingStep.health_sync:
        nextScreen = HealthSetupScreen();
        break;
      case OnboardingStep.starter:
        nextScreen = OnboardingStartScreen();
        break;
      case OnboardingStep.basic_info:
        nextScreen = OnboardingBasicInfoScreen();
        break;
      case OnboardingStep.smoking:
        nextScreen = OnboardingSmokingScreen();
        break;
      case OnboardingStep.drinking:
        nextScreen = OnboardingDrinkingScreen();
        break;
      case OnboardingStep.followups:
        nextScreen = OnboardingFollowupScreen();
        break;
      case OnboardingStep.end:
      default:
        // Push to Firestore
        UserRepo().insert(User.fromJson(userJson));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Welcome to Happily Ever After!")
          )
        );

        // Return to home screen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false
        );

        return;
      break;
    }

    WidgetsBinding.instance!.addPostFrameCallback((_) =>
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => nextScreen)
      ).then((value) {
        OnboardingStepReturn res = value;
        userJson.addAll(res.returnData);
        currentStep = res.nextStep;
        _reroute();
      })
    );
  }

  @override
  Widget build(BuildContext context) {
    _reroute();
    return Container();
  }
}
