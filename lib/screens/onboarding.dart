import 'package:flutter/material.dart';

import 'package:hea/data/onboarding_template.dart';

const onboardingStartId = "onboard_start";

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  var currentTemplateId = onboardingStartId;
  var templates = OnboardingTemplate.fetchTemplates();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Onboarding"),
      ),
      body: Center(
          child: Column(
            // children: [
            //   Text(template.title),
            //   if (template.subtitle != null)
            //     Text(template.subtitle!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 40))
            // ]
          )
      ),
    );
  }
}