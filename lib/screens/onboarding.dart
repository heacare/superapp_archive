import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:hea/model/onboarding_template.dart';

// const onboardingStartId = "onboard_start";
const onboardingStartId = "smoking_2";

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  var currentTemplateId = onboardingStartId;

  List<Widget> _fromTemplateInputs(List<OnboardingTemplateInput> inputs) {

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

  List<Widget> _fromTemplateOptions(List<OnboardingTemplateOption> options) {

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

  Widget _templateBuilder(BuildContext context, AsyncSnapshot<OnboardingTemplateMap> snapshot) {
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
          ..._fromTemplateInputs(template.inputs),

        if (template.text != null)
          MarkdownBody(
              data: template.text!,
              onTapLink: (text, href, title) => _launchUrl(href!),
          ),

        ..._fromTemplateOptions(template.options),
      ];
    }
    else if (snapshot.hasError) {
      // Error on fetching templates
      children = <Widget>[
        const Text("Oops, something broke")
      ];

      throw "Error in fetching templates: ${snapshot.error}";
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
            builder: _templateBuilder
          )
      )
    );
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