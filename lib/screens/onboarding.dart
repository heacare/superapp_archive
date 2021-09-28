import 'package:flutter/material.dart';

import 'package:hea/data/onboarding_template.dart';

// const onboardingStartId = "onboard_start";
const onboardingStartId = "bmi_0";

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  var currentTemplateId = onboardingStartId;

  List<Widget> fromTemplateInputs(List<OnboardingTemplateInput> inputs) {

    final inputWidgets = inputs.map(
      (input) => TextField(
        keyboardType: ((inputType) {
          if (inputType == "number") {
            return const TextInputType.numberWithOptions(
              signed: false,
              decimal: true
            );
          }
          else if (inputType == "date") {
            return TextInputType.datetime;
          }
          else {
            return TextInputType.text;
          }
        })(input.type),
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: input.text
        ),
      )
    );

    return List<Widget>.from(inputWidgets);
  }

  List<Widget> fromTemplateOptions(List<OnboardingTemplateOption> options) {

    final optionWidgets = options.map(
      (option) {
        return OutlinedButton(
          child: Text(option.text),
          // TODO: Advance to next onboarding template
          onPressed: () => print("Next template: ${option.nextTemplate}"),
        );
      }
    );

    return List<Widget>.from(optionWidgets);
  }

  Widget templateBuilder(BuildContext context, AsyncSnapshot<OnboardingTemplateMap> snapshot) {
    List<Widget> children;

    if (snapshot.hasData) {
      // Retrieve specific OnboardTemplate object
      final template = snapshot.data![currentTemplateId]!;
      children = <Widget>[
        Text(
          template.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40
          )
        ),

        // Optional subtitle
        if (template.subtitle != null)
          Text(
            template.subtitle!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28
            )
          ),

        // TODO: Images

        if (template.inputs.isNotEmpty)
          ...fromTemplateInputs(template.inputs),

        ...fromTemplateOptions(template.options),

        if (template.text != null)
          Text(template.text!)
      ];
    }
    else if (snapshot.hasError) {
      // Error on fetching templates
      children = <Widget>[
        const Text("Oops, something broke")
      ];

      print("Error: ${snapshot.error}");
    }
    else {
      // Loading screen
      children = const <Widget>[
        SizedBox(
          child: CircularProgressIndicator(),
          width: 60,
          height: 60,
        )
      ];
    }

    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: children
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    final templatesFuture = OnboardingTemplate.fetchTemplates();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Onboarding"),
      ),
      body: Center(
          child: FutureBuilder<OnboardingTemplateMap>(
            future: templatesFuture,
            builder: templateBuilder
          )
      )
    );
  }
}