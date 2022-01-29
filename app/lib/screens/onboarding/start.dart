import 'package:flutter/material.dart';
import 'package:hea/widgets/gradient_button.dart';
import 'package:hea/screens/onboarding.dart';

class OnboardingStartScreen extends StatelessWidget {
  OnboardingStartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Enabling the safe area
      body: SafeArea(
          child: Container(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20.0)),
                        color: Colors.grey[200]),
                  )),
                  const SizedBox(height: 30.0),
                  Text("Awesome!",
                      style: Theme.of(context).textTheme.headline1),
                  const SizedBox(height: 10.0),
                  Text(
                      "We've got you all synced up, let's get some more information so we can know you even better.",
                      style: Theme.of(context).textTheme.headline2?.copyWith(
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                          color: Color(0xFF707070))),
                  const SizedBox(height: 24.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: GradientButton(
                      text: "LET'S GO",
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true)
                              .pop(OnboardingStepReturn(
                        nextStep: OnboardingStep.basic_info,
                        returnData: <String, dynamic>{},
                      )),
                    ),
                  ),
                ],
              ))),
    );
  }
}
