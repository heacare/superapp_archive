import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:hea/models/onboarding_types.dart';
import 'package:hea/screens/onboarding.dart';
import 'package:hea/widgets/gradient_button.dart';
import 'package:hea/widgets/switch_button.dart';
import 'package:hea/widgets/select_list.dart';

final List<SelectListItem<SmokingPacks>> choices = [
  SelectListItem(text: "Less than a pack", value: SmokingPacks.LessOnePack),
  SelectListItem(text: "One to two packs", value: SmokingPacks.OneToTwoPacks),
  SelectListItem(
      text: "Three to five packs", value: SmokingPacks.ThreeToFivePacks),
  SelectListItem(text: "More than five packs", value: SmokingPacks.FivePacks),
];

// final List<SelectListItem> choices = [
//   SelectListItem(text: "Less than a pack", value: "LessOnePack"),
//   SelectListItem(text: "One to two packs", value: "OneToTwoPacks"),
//   SelectListItem(text: "Three to five packs", value: "ThreeToFivePacks"),
//   SelectListItem(text: "More than five packs", value: "FivePacks"),
// ];

class OnboardingSmokingScreen extends StatefulWidget {
  OnboardingSmokingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingSmokingScreen> createState() =>
      OnboardingSmokingScreenState();
}

class OnboardingSmokingScreenState extends State<OnboardingSmokingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _smokeYears = TextEditingController();

  bool smokes = false;
  bool past_smokes = false;
  SmokingPacks packs = choices[0].value;

  _validateEntries() {
    Map<String, dynamic> res = <String, dynamic>{
      "isSmoker": smokes || past_smokes,
    };

    if (past_smokes) {
      res["smokingYears"] = past_smokes;
    }

    if (smokes || past_smokes) {
      res["smokingPacksPerDay"] = describeEnum(packs);

      if (_smokeYears.text == "") {
        throw 'Please enter the number of years you\'ve smoked!';
      }

      num smokeYears = 0;
      try {
        smokeYears = num.parse(_smokeYears.text);
      } catch (e) {
        throw 'Smoking years must be a number!';
      }

      res["smokingYears"] = smokeYears;
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
          setState(() {
            smokes = selected;
          });
        },
      ),
    ];

    if (!smokes) {
      children.addAll([
        const SizedBox(height: 24.0),
        Padding(
            child: Text("Have you smoked in the past?",
                style: Theme.of(context).textTheme.headline2?.copyWith(
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                    color: Color(0xFF414141))),
            padding: const EdgeInsets.symmetric(vertical: 16.0)),
        SwitchButton(
          selected: past_smokes,
          onChange: (bool selected) {
            setState(() {
              past_smokes = selected;
            });
          },
        ),
      ]);
    }

    if (smokes || past_smokes) {
      children.addAll([
        const SizedBox(height: 24.0),
        Padding(
            child: Text("Have many packs a day?",
                style: Theme.of(context).textTheme.headline2?.copyWith(
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                    color: Color(0xFF414141))),
            padding: const EdgeInsets.symmetric(vertical: 16.0)),
        SelectList(
          items: choices,
          onChange: (SmokingPacks c) {
            setState(() {
              packs = c;
            });
          },
        ),
        const SizedBox(height: 24.0),
        Padding(
            child: Text("For how long?",
                style: Theme.of(context).textTheme.headline2?.copyWith(
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                    color: Color(0xFF414141))),
            padding: const EdgeInsets.symmetric(vertical: 16.0)),
        TextFormField(
            controller: _smokeYears,
            decoration: const InputDecoration(
              labelText: "1",
              suffixText: " years",
            ),
            validator: FormBuilderValidators.numeric(context),
            keyboardType: TextInputType.number),
      ]);
    }

    return Form(
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
              child: CustomScrollView(slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                  _buildForm(),
                ])),
                SliverFillRemaining(
                    hasScrollBody: false,
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: GradientButton(
                            text: "CONTINUE",
                            onPressed: () {
                              try {
                                Map<String, dynamic> res = _validateEntries();
                                Navigator.of(context, rootNavigator: true)
                                    .pop(OnboardingStepReturn(
                                  nextStep: OnboardingStep.drinking,
                                  returnData: res,
                                ));
                              } on String catch (e) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text(e)));
                              }
                            },
                          ),
                        )))
              ]))),
    );
  }
}
