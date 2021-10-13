import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hea/widgets/error_display.dart';
import 'package:hea/widgets/firebase_svg.dart';
import 'package:hea/widgets/onboard_progress_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:hea/data/user_repo.dart';
import 'package:hea/models/onboarding_custom.dart';
import 'package:hea/models/onboarding_template.dart';
import 'package:hea/models/user.dart';
import 'home.dart';

const onboardingStartId = "onboard_start";
const onboardingLastId = "birth_control_2";

class OnboardingScreen extends StatefulWidget {
  Map<String, dynamic> userJson;

  // Pass a JSON representing User since we don't have reflection
  OnboardingScreen({Key? key, required this.userJson}) :
        super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<OnboardProgressBarState> _progressBarKey = GlobalKey<OnboardProgressBarState>();

  late Future<OnboardingTemplateMap> templateMapFuture;

  var currentTemplateId = onboardingStartId;
  late OnboardingTemplate currentTemplate;

  _advanceNextTemplate(String nextTemplate) {
    if (currentTemplateId != onboardingLastId) {
      setState(() => currentTemplateId = nextTemplate);

      // Only advance progress bar if this template had input fields
      if (currentTemplate.inputs.isNotEmpty || currentTemplate.options.length > 1) {
        _progressBarKey.currentState!.nextStage();
      }
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

  Widget _fromTemplateInputs(List<OnboardingTemplateInput> inputs) {

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
        // Health API gives data in kg/m
        if (input.varName == "weight" || input.varName == "height") {
          for (var h in widget.userJson["healthData"]) {
            if (h["data_type"] == input.varName) {
              return (h["value"] as num).toStringAsFixed(2);
            }
          }
        }

        return null;
      }

      if (input.type == "date") {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: DateTimePicker(
            type: DateTimePickerType.date,
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            dateLabelText: input.text,
            onSaved: (String? value) {
              // Use Timestamp objects for all datetimes
              _updateUserField(input.varName, Timestamp.fromDate(DateTime.parse(value!)));
            },
            validator: getValidator,
          )
        );
      }
      else if (input.type == "radio") {
        return FormBuilderRadioGroup(
            name: input.varName,
            decoration: InputDecoration(
              labelText: input.text
            ),
            // TODO: Fixes bug in library :')
            focusNode: FocusNode(),
            activeColor: Theme.of(context).colorScheme.primary,
            orientation: OptionsOrientation.vertical,
            validator: FormBuilderValidators.required(context),
            onChanged: (String? value) {
              _updateUserField(input.varName, value);
            },
            options: input.choices.map((choice) {
              return FormBuilderFieldOption(
                child: Text(choice),
                value: choice
              );
            }).toList(growable: false)
        );
      }
      else {
        // Input types: number, text
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: TextFormField(
            keyboardType: getTextInputType(),
            decoration: InputDecoration(
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
          )
        );
      }

    }

    return Form(
      key: _formKey,
      child: Wrap(
        children: inputs.map(
          (input) => makeInputWidget(input)
        ).toList(growable: false)
      )
    );

  }

  Widget _fromTemplateOptions(List<OnboardingTemplateOption> options, Widget inputForm) {

    final optionWidgets = options.map(
      (option) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: OutlinedButton(
            child: Text(option.text),
            onPressed: () {
              // Update user fields
              if (_formKey.currentState != null) {
                if (!_formKey.currentState!.validate()) {
                  // Invalid data
                  return;
                }

                _formKey.currentState!
                  ..save()
                  ..reset();
              }
              
              // Check for additional logic
              if (customNextTemplate[currentTemplateId] != null) {
                User user = User.fromJson(widget.userJson);
                final nextTemplateId = customNextTemplate[currentTemplateId]!(user);

                _advanceNextTemplate(nextTemplateId);
              }
              else {
                _advanceNextTemplate(option.nextTemplate);
              }
            }
          )
        );
      }
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List<Widget>.from(optionWidgets),
    );
  }

  Widget _templateBuilder(BuildContext context, AsyncSnapshot<OnboardingTemplateMap> snapshot) {

    if (snapshot.hasError) {
      // Error on fetching templates
      print("Error in fetching templates: ${snapshot.error}");
      return const ErrorDisplay();
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
    final templateMap = snapshot.data!;
    currentTemplate = templateMap[currentTemplateId]!;

    // TODO Improve this
    // Rough estimate based on how many require user input (ignoring branching)
    final numStages = templateMap.values.where(
      (template) => template.inputs.isNotEmpty || template.options.length > 1
    ).length;

    // Build input widgets
    Widget inputWidget = _fromTemplateInputs(currentTemplate.inputs);
    Widget optionWidget = _fromTemplateOptions(currentTemplate.options, inputWidget);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(36.0),
        child: SafeArea(
          child: OnboardProgressBar(key: _progressBarKey, numStages: numStages)
        )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          // Optional image
          ((currentTemplate.imageId != null)
            ? Expanded(child: FirebaseSvg(currentTemplate.imageId!).load())
            : const Spacer()
          ),

          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        child: Text(currentTemplate.title, style: Theme.of(context).textTheme.headline1),
                        padding: const EdgeInsets.symmetric(vertical: 24.0)
                      ),

                      // Optional subtitle
                      if (currentTemplate.subtitle != null)
                        Text(currentTemplate.subtitle!, style: Theme.of(context).textTheme.headline2),
                    ]
                  ),

                  inputWidget,

                  if (currentTemplate.text != null)
                    MarkdownBody(
                      data: currentTemplate.text!,
                      // Support opening links
                      onTapLink: (text, href, title) => _launchUrl(href!),
                    ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: optionWidget
                  )
                ]
              )
            )
          ],
        )
      )
    );

  }

  @override
  initState() {
    super.initState();
    templateMapFuture = OnboardingTemplate.fetchTemplates();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<OnboardingTemplateMap>(
      future: templateMapFuture,
      builder: _templateBuilder
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