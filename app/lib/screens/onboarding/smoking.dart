import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:hea/providers/auth.dart';
import 'package:hea/screens/home.dart';
import 'package:hea/screens/onboarding.dart';
import 'package:hea/widgets/navigable_text.dart';
import 'package:hea/widgets/gradient_button.dart';
import 'package:hea/widgets/safearea_container.dart';
import 'package:hea/widgets/switch_button.dart';
import 'package:hea/widgets/select_list.dart';

final List<SelectListItem> choices = [
  SelectListItem(text: "Less than a pack", value: "LessOnePack"),
  SelectListItem(text: "One to two packs", value: "OneToTwoPacks"),
  SelectListItem(text: "Three to five packs", value: "ThreeToFivePacks"),
  SelectListItem(text: "More than five packs", value: "FivePacks"),
];

class OnboardingSmokingScreen extends StatefulWidget {
  OnboardingSmokingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingSmokingScreen> createState() => OnboardingSmokingScreenState();
}

class OnboardingSmokingScreenState extends State<OnboardingSmokingScreen> {
  final _formKey = GlobalKey<FormState>();

  bool smokes = false;
  bool past_smokes = false;
  String packs = choices[0].value;

  _validateEntries() {
    Map<String, dynamic> res = <String, dynamic> {
      "isSmoker": smokes,
    };

    if (past_smokes) {
      res["smokingYears"] = past_smokes;
    }

    if (smokes || past_smokes) {
      res["smokingPacksPerDay"] = packs;
    }

    return res;
  }

  Widget _buildForm() {
    List<Widget> children = [
      Padding(
        child: Text("Do you smoke?",
          style: Theme.of(context).textTheme.headline1),
        padding: const EdgeInsets.symmetric(vertical: 16.0)),
      const SizedBox(height: 24.0),
      SwitchButton(
        selected: smokes,
        onChange: (bool selected) {
          setState(() { smokes = selected; });
        },
      ),
    ];

    if (!smokes) {
      children.addAll([
        const SizedBox(height: 24.0),
        Padding(
          child: Text("Have you smoked in the past?",
            style: Theme.of(context).textTheme.headline2),
          padding: const EdgeInsets.symmetric(vertical: 16.0)),
        SwitchButton(
          selected: past_smokes,
          onChange: (bool selected) {
            setState(() { past_smokes = selected; });
          },
        ),
      ]);
    }

    if (smokes || past_smokes) {
      children.addAll([
        const SizedBox(height: 24.0),
        Padding(
          child: Text("Have many packs a day?",
            style: Theme.of(context).textTheme.headline2),
          padding: const EdgeInsets.symmetric(vertical: 16.0)),
        SelectList(
          items: choices,
          onChange: (String c) {
            setState(() { packs = c; });
          },
        ),
      ]);
    }

    return Form (
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Enabling the safe area
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
          child: CustomScrollView(
          slivers: [
            SliverList (
              delegate: SliverChildListDelegate([
                _buildForm(),
              ])
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Align (
                alignment: Alignment.bottomCenter,
                child: GradientButton (
                  text: "CONTINUE",
                  onPressed: () {
                    try {
                      Map<String, dynamic> res = _validateEntries();
                      Navigator.of(context, rootNavigator: true).pop(OnboardingStepReturn(
                          nextStep: OnboardingStep.drinking,
                          returnData: res,
                        ));
                    } on String catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e)));
                    }
                  },
                ),
              ))
            )
          ]
        ))
      ),
    );
  }
}
