import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:country_picker/country_picker.dart';

import 'package:flutter/material.dart';
import 'package:hea/widgets/gradient_button.dart';
import 'package:hea/screens/onboarding.dart';

class OnboardingBasicInfoScreen extends StatefulWidget {
  OnboardingBasicInfoScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingBasicInfoScreen> createState() => OnboardingBasicInfoScreenState();
}


class OnboardingBasicInfoScreenState extends State<OnboardingBasicInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _height = TextEditingController();
  final _weight = TextEditingController();

  String birthdate = '';
  String gender = 'male';
  String country = 'Singapore';

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

    if (_weight.text == '') {
      throw 'Enter your weight please!';
    }

    return <String, dynamic> {
      "name": _name.text,
      "height": _height.text,
      "weight": _weight.text,
      "gender": gender,
      "birthdate": birthdate,
      "country": country,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Enabling the safe area
      body: SafeArea(
          child: Container(
              padding: const EdgeInsets.all(30.0),
              child:  Form (
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      child: Text("Tell me more about yourself...",
                        style: Theme.of(context).textTheme.headline1),
                        padding: const EdgeInsets.symmetric(vertical: 16.0)),
                     const SizedBox(height: 24.0),
                     Text(
                        "My name is",
                        style: Theme.of(context).textTheme.headline2),
                     const SizedBox(height: 8.0),
                     TextFormField(
                       controller: _name,
                       decoration: const InputDecoration(labelText: "Name"),
                     ),
                     const SizedBox(height: 24.0),
                     Text(
                        "And I was born on",
                        style: Theme.of(context).textTheme.headline2),
                     const SizedBox(height: 8.0),
                     DateTimePicker (
                       type: DateTimePickerType.date,
                       dateLabelText: 'Date',
                       firstDate: DateTime(2000),
                       lastDate: DateTime.now(),
                       onChanged: (val) => setState(() { birthdate = val; }),
                     ),
                     const SizedBox(height: 24.0),
                     Text(
                        "I identify as a",
                        style: Theme.of(context).textTheme.headline2),
                     SizedBox (
                       height: 50.0,
                       child: Ink (
                         decoration: BoxDecoration (
                           color: Color(0xFFE5E5E5),
                           borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                         ),
                         padding: const EdgeInsets.symmetric(horizontal: 20.0),
                         child: DropdownButton<String> (
                           value: gender,
                           isExpanded: true,
                           underline: Container(),
                           items: <DropdownMenuItem<String>> [
                             DropdownMenuItem<String> (
                               value: 'male',
                               child: Text('Male'),
                               enabled: true,
                             ),
                             DropdownMenuItem<String> (
                               value: 'female',
                               child: Text('Female'),
                               enabled: true,
                             ),
                           ],
                           onChanged: (val) => setState(() { gender = val != null ? val : ''; }),
                         )
                       )
                     ),
                     const SizedBox(height: 24.0),
                     Text(
                        "My height and weight is",
                        style: Theme.of(context).textTheme.headline2),
                     Row (
                       children: [
                         Expanded (
                           child: TextFormField(
                             controller: _height,
                             decoration: const InputDecoration(
                               labelText: "Height",
                               suffixText: "cm",
                             ),
                             validator: FormBuilderValidators.numeric(context),
                             keyboardType: TextInputType.number
                           )
                         ),
                         Expanded (
                           child: Text(
                              "and",
                              style: Theme.of(context).textTheme.headline2,
                              textAlign: TextAlign.center),
                         ),
                         Expanded (
                           child: TextFormField(
                             controller: _weight,
                             decoration: const InputDecoration(
                               labelText: "Weight",
                               suffixText: "kg",
                             ),
                             validator: FormBuilderValidators.numeric(context),
                             keyboardType: TextInputType.number
                           )
                         ),
                       ],
                     ),
                     const SizedBox(height: 24.0),
                     Text(
                        "I live in",
                        style: Theme.of(context).textTheme.headline2),
                     SizedBox(
                       height: 50.0,
                       child: ElevatedButton(
                         child: Text(country),
                         onPressed: () =>showCountryPicker(
                           context: context,
                           showPhoneCode: false, // optional. Shows phone code before the country name.
                           onSelect: (Country c) {
                             setState(() { country = c.name; });
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
                           Navigator.of(context, rootNavigator: true).pop(OnboardingStepReturn(
                               nextStep: OnboardingStep.basic_info,
                               returnData: res,
                             ));
                         } on String catch (e) {
                           ScaffoldMessenger.of(context)
                               .showSnackBar(SnackBar(content: Text(e)));
                         }
                       },
                     ),
                   ],
                )
              )
            )),
    );
  }
}
