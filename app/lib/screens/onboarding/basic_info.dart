import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:country_picker/country_picker.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hea/widgets/gradient_button.dart';
import 'package:hea/screens/onboarding.dart';
import 'package:hea/models/onboarding_types.dart';

class OnboardingBasicInfoScreen extends StatefulWidget {
  const OnboardingBasicInfoScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingBasicInfoScreen> createState() =>
      OnboardingBasicInfoScreenState();
}

class OnboardingBasicInfoScreenState extends State<OnboardingBasicInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _height = TextEditingController();
  final _weight = TextEditingController();

  String birthdate = '';
  String gender = describeEnum(Gender.values[0]);

  String country = 'SG';
  String countryName = 'Singapore';

  _validateEntries() {
    if (!_formKey.currentState!.validate()) {
      throw 'Some fields have not been filled properly';
    }

    if (birthdate == '') {
      throw 'Enter your birthdate please!';
    }

    if (_name.text == '') {
      throw 'Enter your name please!';
    }

    if (_height.text == '') {
      throw 'Enter your height please!';
    }

    num height = 0;
    try {
      height = num.parse(_height.text);
    } catch (e) {
      throw 'Height must be a number!';
    }

    if (_weight.text == '') {
      throw 'Enter your weight please!';
    }

    num weight = 0;
    try {
      weight = num.parse(_weight.text);
    } catch (e) {
      throw 'Weight must be a number!';
    }

    return <String, dynamic>{
      "name": _name.text,
      "height": height / 100,
      "weight": weight,
      "gender": gender,
      "birthday": birthdate,
      "country": country,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Enabling the safe area
      body: SafeArea(
          child: SingleChildScrollView(
              child: Container(
                  padding: const EdgeInsets.all(30.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Tell me more about yourself...",
                              style: Theme.of(context).textTheme.headline1),
                          const SizedBox(height: 24.0),
                          Text("My name is",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      height: 1.4,
                                      color: const Color(0xFF414141))),
                          const SizedBox(height: 8.0),
                          TextFormField(
                            controller: _name,
                            decoration: const InputDecoration(
                                labelText: "Daniel",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0)))),
                          ),
                          const SizedBox(height: 24.0),
                          Text("And I was born on",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      height: 1.4,
                                      color: const Color(0xFF414141))),
                          const SizedBox(height: 8.0),
                          DateTimePicker(
                            type: DateTimePickerType.date,
                            dateLabelText: '19/02/1973',
                            firstDate: DateTime.now()
                                .subtract(const Duration(years: 150)),
                            lastDate: DateTime.now(),
                            onChanged: (val) => setState(() {
                              birthdate = val;
                            }),
                          ),
                          const SizedBox(height: 24.0),
                          Text("I identify as a",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      height: 1.4,
                                      color: const Color(0xFF414141))),
                          const SizedBox(height: 8.0),
                          SizedBox(
                              height: 50.0,
                              child: Ink(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF5F5F5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3.0)),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: DropdownButton<String>(
                                    value: gender,
                                    isExpanded: true,
                                    underline: Container(),
                                    items: Gender.values
                                        .map((gender) =>
                                            DropdownMenuItem<String>(
                                              value: describeEnum(gender),
                                              child: Text(describeEnum(gender)),
                                              enabled: true,
                                            ))
                                        .toList(),
                                    onChanged: (val) => setState(() {
                                      gender = val ?? '';
                                    }),
                                  ))),
                          const SizedBox(height: 24.0),
                          Text("My height and weight is",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      height: 1.4,
                                      color: const Color(0xFF414141))),
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              Expanded(
                                  child: TextFormField(
                                      controller: _height,
                                      decoration: const InputDecoration(
                                        labelText: "170cm",
                                        suffixText: "cm",
                                      ),
                                      validator: FormBuilderValidators.numeric(
                                          context),
                                      keyboardType: TextInputType.number)),
                              Expanded(
                                child: Text("and",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        ?.copyWith(
                                            fontWeight: FontWeight.w400,
                                            height: 1.4,
                                            color: const Color(0xFF414141)),
                                    textAlign: TextAlign.center),
                              ),
                              Expanded(
                                  child: TextFormField(
                                      controller: _weight,
                                      decoration: const InputDecoration(
                                        labelText: "60kg",
                                        suffixText: "kg",
                                      ),
                                      validator: FormBuilderValidators.numeric(
                                          context),
                                      keyboardType: TextInputType.number)),
                            ],
                          ),
                          const SizedBox(height: 24.0),
                          Text("I live in",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      height: 1.4,
                                      color: const Color(0xFF414141))),
                          const SizedBox(height: 8.0),
                          SizedBox(
                            height: 50.0,
                            child: ElevatedButton(
                              child: Text(countryName),
                              onPressed: () => showCountryPicker(
                                context: context,
                                showPhoneCode:
                                    false, // optional. Shows phone code before the country name.
                                onSelect: (Country c) {
                                  setState(() {
                                    country = c.countryCode;
                                    countryName = c.name;
                                  });
                                },
                              ),
                              style: TextButton.styleFrom(
                                  primary: Colors.black,
                                  backgroundColor: Colors.grey[100]),
                            ),
                          ),
                          const SizedBox(height: 36.0),
                          GradientButton(
                            text: "LET'S GO",
                            onPressed: () {
                              try {
                                Map<String, dynamic> res = _validateEntries();
                                Navigator.of(context, rootNavigator: true)
                                    .pop(OnboardingStepReturn(
                                  nextStep: OnboardingStep.smoking,
                                  returnData: res,
                                ));
                              } on String catch (e) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text(e)));
                              }
                            },
                          ),
                        ],
                      ))))),
    );
  }
}
