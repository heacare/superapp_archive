import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hea/models/onboarding_custom.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:hea/models/onboarding_template.dart';
import 'package:hea/models/user.dart';
import 'home.dart';

const onboardingStartId = "onboard_start";
const onboardingLastId = "birth_control_1";

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  Gender? _gender;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var currentTemplateId = onboardingStartId;
  // TODO: Fetch user using connector
  Map<String, dynamic> user = User.testUser().toJson();

  _advanceNextTemplate(String nextTemplate) {
    if (currentTemplateId != onboardingLastId) {
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

  _updateUserField(String varName, dynamic value) {
    // Check for single level nesting
    if (varName.contains(".")) {
      final idx = varName.indexOf(".");
      final baseName = varName.substring(0, idx);
      varName = varName.substring(idx+1);

      if (user[baseName] == null) {
        user[baseName] = {};
      }
      user[baseName][varName] = value;
    }
    else {
      user[varName] = value;
    }
  }

  Form _fromTemplateInputs(List<OnboardingTemplateInput> inputs) {

    // Return a configured widget
    makeInputWidget(OnboardingTemplateInput input) {

      // Checks for empty fields and type
      getValidator(String? value) {
        if (value == null || value.isEmpty) {
          return "Field is required!";
        }
        if (input.type == "number") {
          if (num.tryParse(value) == null) {
            return "Invalid input!";
          }
        }
        return null;
      }

      getTextInputType() {
        if (input.type == "number") {
          return const TextInputType.numberWithOptions(
              signed: false,
              decimal: true
          );
        }
        else {
          return TextInputType.text;
        }
      }

      if (input.type == "date") {
        return DateTimePicker(
          type: DateTimePickerType.date,
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          dateLabelText: input.text,
          onSaved: (String? value) {
            _updateUserField(input.varName, DateTime.parse(value!));
          },
          validator: getValidator,
        );
      }
      else {
        return TextFormField(
            keyboardType: getTextInputType(),
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: input.text
            ),
            onSaved: (String? value) {
              if (input.type == "number") {
                _updateUserField(input.varName, num.parse(value!));
              }
              else {
                _updateUserField(input.varName, value);
              }
            },
            validator: getValidator
        );
      }

    }

    final inputWidgets;
    if (currentTemplateId == "gender_0") {
      // TODO: Hardcoded options for gender
      // TODO: Missing validator
      inputWidgets = Gender.genderList.map(
          (gender) => RadioListTile<Gender>(
            title: Text(gender.toString()),
            value: gender,
            onChanged: (Gender? value) {
              setState(() => _gender = value);
              user["gender"] = value.toString();
            },
            groupValue: _gender,
          )
      );
    }
    else {
      inputWidgets = inputs.map(
        (input) => makeInputWidget(input)
      );
    }

    return Form(
      key: _formKey,
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
            if (!_formKey.currentState!.validate()) {
              return;
            }

            _formKey.currentState!
              ..save()
              ..reset();
            print("User: $user");

            // Check for additional logic
            if (customNextTemplate[currentTemplateId] != null) {
              print(customNextTemplate[currentTemplateId]!(User.fromJson(user)));
              _advanceNextTemplate(
                customNextTemplate[currentTemplateId]!(User.fromJson(user))
              );
            }
            else {
              _advanceNextTemplate(option.nextTemplate);
            }
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