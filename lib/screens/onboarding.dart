import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:hea/data/user_repo.dart';
import 'package:hea/models/onboarding_custom.dart';
import 'package:hea/models/onboarding_template.dart';
import 'package:hea/models/user.dart';
import 'package:hea/providers/storage.dart';
import 'home.dart';

const onboardingStartId = "onboard_start";
const onboardingLastId = "birth_control_1";

class OnboardingScreen extends StatefulWidget {
  Map<String, dynamic> userJson;

  // Pass a JSON representing User since we don't have reflection
  OnboardingScreen({Key? key, required this.userJson}) :
        super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  Gender? _gender;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var currentTemplateId = onboardingStartId;
  late Future<OnboardingTemplateMap> templateMapFuture;

  _advanceNextTemplate(String nextTemplate) {
    if (currentTemplateId != onboardingLastId) {
      setState(() => currentTemplateId = nextTemplate);
    }
    else {
      // Push to Firestore
      UserRepo().insert(User.fromJson(widget.userJson));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Welcome to Happily Ever After!")
        )
      );

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

      if (widget.userJson[baseName] == null) {
        widget.userJson[baseName] = {};
      }
      widget.userJson[baseName][varName] = value;
    }
    else {
      widget.userJson[varName] = value;
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

      getInitialValue() {
        // TODO Assumes data units (kilogram/meters)
        if (input.varName == "weight" || input.varName == "height") {
          for (var h in widget.userJson["healthData"]) {
            if (h["data_type"] == input.varName) {
              return h["value"].toString();
            }
          }
        }

        return null;
      }

      if (input.type == "date") {
        return DateTimePicker(
          type: DateTimePickerType.date,
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          dateLabelText: input.text,
          onSaved: (String? value) {
            // Use Timestamp objects for all datetimes
            _updateUserField(input.varName, Timestamp.fromDate(DateTime.parse(value!)));
          },
          validator: getValidator,
        );
      }
      else {
        return TextFormField(
            keyboardType: getTextInputType(),
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: input.text,
            ),
            onSaved: (String? value) {
              if (input.type == "number") {
                _updateUserField(input.varName, num.parse(value!));
              }
              else {
                _updateUserField(input.varName, value);
              }
            },
            validator: getValidator,
            initialValue: getInitialValue(),
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
              widget.userJson["gender"] = value.toString();
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
        return TextButton(
          child: Text(option.text),
          onPressed: () {
            // Update user fields
            if (!_formKey.currentState!.validate()) {
              return;
            }

            _formKey.currentState!
              ..save()
              ..reset();

            // Check for additional logic
            if (customNextTemplate[currentTemplateId] != null) {
              User user = User.fromJson(widget.userJson);
              print(customNextTemplate[currentTemplateId]!(user));

              _advanceNextTemplate(
                customNextTemplate[currentTemplateId]!(user)
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

    if (snapshot.hasError) {
      // Error on fetching templates
      print("Error in fetching templates: ${snapshot.error}");
      return Text("Oops, something broke", style: Theme.of(context).textTheme.headline1);
    }
    else if (!snapshot.hasData) {
      // Loading screen
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
          strokeWidth: 8,
        ),
      );
    }

    // Retrieve specific OnboardTemplate object
    final template = snapshot.data![currentTemplateId]!;
    print("imageId: ${template.imageId}");

    // Build input widgets
    Form inputForm = _fromTemplateInputs(template.inputs);
    List<Widget> optionWidget = _fromTemplateOptions(template.options, inputForm);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Optional image
        if (template.imageId != null)
          Expanded(
            child: FutureBuilder<String>(
              future: Storage().getFileUrl(template.imageId!),
              builder: (context, snapshot) {
                // TODO Null check issues
                return SvgPicture.network(snapshot.data!);
              },
            )
          ),

        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                      child: Text(template.title, style: Theme.of(context).textTheme.headline1),
                      padding: const EdgeInsets.symmetric(vertical: 16.0)
                  ),

                  // Optional subtitle
                  if (template.subtitle != null)
                    Text(template.subtitle!, style: Theme.of(context).textTheme.headline2),
                ]
              ),

              inputForm,

              if (template.text != null)
                MarkdownBody(
                  data: template.text!,
                  // Support opening links
                  onTapLink: (text, href, title) => _launchUrl(href!),
                ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List<Widget>.from(optionWidget),
                )
              )
            ]
          )
        )
      ],
    );

  }

  @override
  initState() {
    super.initState();
    templateMapFuture = OnboardingTemplate.fetchTemplates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<OnboardingTemplateMap>(
          future: templateMapFuture,
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