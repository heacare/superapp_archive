import 'package:flutter/material.dart';

import 'package:hea/screens/onboarding.dart';
import 'package:hea/widgets/gradient_button.dart';
import 'package:hea/widgets/select_list.dart';

final List<SelectListItem<String>> choices = [
  SelectListItem(text: "I never drink", value: "NotAtAll"),
  SelectListItem(text: "Once a month", value: "OnceAMonth"),
  SelectListItem(text: "Few times a week", value: "FewTimesAWeek"),
  SelectListItem(text: "Once a week", value: "OnceAWeek"),
  SelectListItem(text: "Everyday", value: "Everyday"),
];

class OnboardingDrinkingScreen extends StatefulWidget {
  const OnboardingDrinkingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingDrinkingScreen> createState() =>
      OnboardingDrinkingScreenState();
}

class OnboardingDrinkingScreenState extends State<OnboardingDrinkingScreen> {
  String choice = choices[0].value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Enabling the safe area
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Do you drink?", style: Theme.of(context).textTheme.headline1),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                  SelectList(
                    items: choices,
                    onChange: (List<String> c) {
                      setState(() {
                        choice = c[0];
                      });
                    },
                  ),
                  const SizedBox(height: 24.0),
                  GradientButton(
                    text: "CONTINUE",
                    onPressed: () {
                      try {
                        Map<String, dynamic> res = <String, dynamic>{
                          "alcoholFreq": choice,
                        };

                        Navigator.of(context, rootNavigator: true)
                            .pop(OnboardingStepReturn(
                          nextStep: OnboardingStep.end,
                          returnData: res,
                        ));
                      } on String catch (e) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(e)));
                      }
                    },
                  ),
                ])),
          ]),
        ),
      ),
    );
  }
}
