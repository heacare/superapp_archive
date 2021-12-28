import 'package:flutter/material.dart';
import 'package:hea/widgets/icon_gradient_button.dart';
import 'package:hea/screens/onboarding.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OnboardingFollowupScreen extends StatelessWidget {
  OnboardingFollowupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Enabling the safe area
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                child: Text("Would you like to tell me more?",
                  style: Theme.of(context).textTheme.headline1),
                padding: const EdgeInsets.symmetric(vertical: 16.0)),
              Text("Based on your answers, I think these follow ups are good for me to get to know you better!",
                style: Theme.of(context).textTheme.headline2),
              Expanded( child: Column (
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconGradientButton (
                    title: "Sleep & Recovery",
                    text: "Survey review of sleep health",
                    icon: FaIcon(FontAwesomeIcons.solidMoon, color: Colors.white),
                    iconColor: Color(0x0C000000),
                    firstColor: Color(0xFF00ABE9),
                    secondColor: Color(0xFF7FDDFF),
                    onPressed: () {
                      // TODO: onboarding stuff
                    },
                  ),
                  const SizedBox(height: 9.0),
                  IconGradientButton (
                    title: "Psychosocial Health",
                    text: "Survey review of mental health",
                    icon: FaIcon(FontAwesomeIcons.peopleArrows, color: Colors.white),
                    iconColor: Color(0x0C000000),
                    firstColor: Color(0xFFFFC498),
                    secondColor: Color(0xFFFF7A60),
                    onPressed: () {
                      // TODO: onboarding stuff
                    },
                  ),
                  const SizedBox(height: 9.0),
                  SizedBox(
                    height: 50.0,
                    child: ElevatedButton(
                      child: const Text("SKIP"),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop(OnboardingStepReturn(
                            nextStep: OnboardingStep.end,
                            returnData: <String, dynamic>{},
                          ));
                      },
                      style: TextButton.styleFrom(
                          primary: Colors.black,
                          backgroundColor: Colors.grey[200],
                          elevation: 0.0),
                    ),
                  )
                ]
              )),
          ]),
        ),
      ),
    );
  }
}
