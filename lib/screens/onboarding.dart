import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hea/providers/auth.dart';
import 'package:hea/screens/error.dart';
import 'package:hea/widgets/firebase_svg.dart';
import 'package:hea/widgets/onboard_progress_bar.dart';
import 'package:health/health.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:hea/data/user_repo.dart';
import 'package:hea/models/onboarding_custom.dart';
import 'package:hea/models/onboarding_template.dart';
import 'package:hea/models/user.dart';
import 'health_setup.dart';
import 'home.dart';

import 'package:hea/screens/onboarding/start.dart';

const onboardingStartId = "onboard_start";
const onboardingLastId = "birth_control_2";

enum OnboardingStep {
  health_sync,
  starter,

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<OnboardProgressBarState> _progressBarKey = GlobalKey<OnboardProgressBarState>();

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
    // return FutureBuilder<OnboardingTemplateMap>(
    //   future: templateMapFuture,
    //   builder: _templateBuilder
    // );
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      // Try to open web view within the app
      await launch(url, forceWebView: true, forceSafariVC: true);
    }
    else {
      throw "Failed to open $url";
    }
  }
}
