import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hea/widgets/firebase_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:hea/data/user_repo.dart';
import 'package:hea/models/onboarding_custom.dart';
import 'package:hea/models/onboarding_template.dart';
import 'package:hea/models/user.dart';
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
      else {
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

    if (currentTemplateId == "gender_0") {
      // TODO: Hardcoded options for gender
      return FormBuilderRadioGroup(
        name: "gender",
        // TODO: Fixes bug in library :')
        focusNode: FocusNode(),
        activeColor: Theme.of(context).colorScheme.primary,
        orientation: OptionsOrientation.vertical,
        validator: FormBuilderValidators.required(context),
        onChanged: (String? value) {
          widget.userJson["gender"] = value.toString();
        },
        options: Gender.genderList.map((gender) {
          return FormBuilderFieldOption(
            child: Text(gender.toString(), style: Theme.of(context).textTheme.headline2),
            value: gender.toString()
          );
        })
        .toList(growable: false)
      );

    }
    else {
      return Form(
        key: _formKey,
        child: Wrap(
          children: inputs.map(
            (input) => makeInputWidget(input)
          ).toList(growable: false)
        )
      );
    }

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
                print(customNextTemplate[currentTemplateId]!(user));

                _advanceNextTemplate(
                  customNextTemplate[currentTemplateId]!(user)
                );
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

    // Build input widgets
    Widget inputWidget = _fromTemplateInputs(template.inputs);
    Widget optionWidget = _fromTemplateOptions(template.options, inputWidget);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Optional image
        ((template.imageId != null)
          ? Expanded(child: FirebaseSvg(template.imageId!).load())
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
                      child: Text(template.title, style: Theme.of(context).textTheme.headline1),
                      padding: const EdgeInsets.symmetric(vertical: 24.0)
                  ),

                  // Optional subtitle
                  if (template.subtitle != null)
                    Text(template.subtitle!, style: Theme.of(context).textTheme.headline2),
                ]
              ),

              inputWidget,

              if (template.text != null)
                MarkdownBody(
                  data: template.text!,
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(36.0),
        child: SafeArea(
          child: LinearProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
            backgroundColor: Colors.transparent,
            minHeight: 36.0,
            value: 0.25,
          )
        )
      ),
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