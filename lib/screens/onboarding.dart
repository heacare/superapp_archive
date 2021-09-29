import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:hea/models/onboarding_template.dart';
import 'package:hea/models/user.dart';
import 'home.dart';

const onboardingStartId = "onboard_start";
const onboardingLastId = "smoking_2";

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  Gender? _gender = Gender.others;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  var currentTemplateId = onboardingStartId;
  // TODO: Fetch user using connector
  Map<String, dynamic> user = User.testUser().toJson();

  _advanceNextTemplate(String nextTemplate) {
    if (nextTemplate != onboardingLastId) {
      setState(() => currentTemplateId = nextTemplate);
    }
    else {
      // Return to home screen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false
      );
    }
  }

  Form _fromTemplateInputs(List<OnboardingTemplateInput> inputs) {

    // Return a configured TextInputType from option
    getTextInputType(OnboardingTemplateInput input) {
      final inputType = input.type;

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
    }

    final inputWidgets;
    if (currentTemplateId == "gender_0") {
      // TODO: Hardcoded options for gender
      inputWidgets = Gender.genderList.map(
          (gender) => RadioListTile<Gender>(
            title: Text(gender.toString()),
            value: gender,
            onChanged: (Gender? value) {
              setState(() => _gender = value);
              user["gender"] = value.toString();
            },
            groupValue: _gender
          )
      );
    }
    else {
      inputWidgets = inputs.map(
        (input) => TextFormField(
            keyboardType: getTextInputType(input),
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: input.text
            ),
            onSaved: (String? value) {
              user[input.varName] = value;
            },
          )
      );
    }

    return Form(
      key: _formState,
      child: Wrap(
        children: List<Widget>.from(inputWidgets)
      )
    );
  }

  List<Widget> _fromTemplateOptions(List<OnboardingTemplateOption> options, Form inputForm) {

    final optionWidgets = options.map(
      (option) {
        return OutlinedButton(
          child: Text(option.text),
          onPressed: () {
            // Update user fields
            _formState.currentState!
                ..save()
                ..reset();
            print("User: $user");

            _advanceNextTemplate(option.nextTemplate);
          }
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

      // Build input widgets
      Form inputForm = _fromTemplateInputs(template.inputs);
      List<Widget> optionWidgets = _fromTemplateOptions(template.options, inputForm);

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
        inputForm,

        if (template.text != null)
          MarkdownBody(
            data: template.text!,
            // Support opening links
            onTapLink: (text, href, title) => _launchUrl(href!),
          ),

        ...optionWidgets
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