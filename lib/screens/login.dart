import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:hea/data/user_repo.dart';
import 'package:hea/providers/auth.dart';
import 'package:hea/screens/home.dart';
import 'package:hea/screens/onboarding.dart';
import 'package:hea/widgets/navigable_text.dart';
import 'package:hea/widgets/gradient_button.dart';

const svgAssetName = "assets/svg/login.svg";

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

enum LoginChoice {
  unselected,
  login,
  signUp
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = Authentication();

  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  var _loginChoice = LoginChoice.unselected;

  void login() async {
    if (!_formKey.currentState!.validate()) { return; }

    try {
      await _auth.login(_email.text, _password.text);
      await navigateSuccess();
    } on AuthenticationException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  void signup() async {
    if (!_formKey.currentState!.validate()) { return; }

    try {
      await _auth.signup(_email.text, _password.text);
      await navigateSuccess();
    } on AuthenticationException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future navigateSuccess() async {
    final userId = _auth.currentUser()!.uid;
    final user = await UserRepo().get(userId);

    if (user == null) {
      await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
          (route) => false
      );
    }
    else {
      // User already finished onboarding
      await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false
      );
    }

  }

  Widget _credsOrText() {

    if (_loginChoice == LoginChoice.unselected) {
      // Show welcome text
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
              child: Text("Say hello to longevity!", style: Theme.of(context).textTheme.headline1),
              padding: const EdgeInsets.symmetric(vertical: 16.0)
          ),
          Text(
              "We provide proactive, preventive & personalised healthcare to keep you at the apex of your health.",
              style: Theme.of(context).textTheme.headline2
          ),

          const SizedBox(height: 24.0),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: GradientButton (
              text: "LOGIN",
              onPressed: () => setState(() => _loginChoice = LoginChoice.login),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: SizedBox (
              height: 50.0,
              child: ElevatedButton(
                child: const Text("JOIN US"),
                onPressed: () => setState(() => _loginChoice = LoginChoice.signUp),
                style: TextButton.styleFrom(
                  primary: Colors.black,
                  backgroundColor: Colors.grey[100]
                ),
              ),
            )
          ),
        ]
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NavigableText(
          onPressed: () => setState(() => _loginChoice = LoginChoice.unselected),
          text: _loginChoice == LoginChoice.login ? "Welcome back to HEA" : "Let's make you superhuman",
        ),

        const SizedBox(height: 24.0),

        TextFormField(
          controller: _email,
          decoration: const InputDecoration(labelText: "Email"),
          validator: FormBuilderValidators.email(context),
        ),

        const SizedBox(height: 8.0),

        TextFormField(
          controller: _password,
          decoration: const InputDecoration(labelText: "Password"),
          obscureText: true
        ),

        const SizedBox(height: 36.0),

        GradientButton(
          text: "LET'S GO",
          onPressed: () {
            _loginChoice == LoginChoice.login ? login() : signup();
          },
        ),
      ]
    );

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder, svgAssetName),
      context
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column (
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        Expanded(
          child: Container (
            color: Colors.grey[200],
          ),
        ),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _credsOrText(),
            ],
          )
        ),
      ],
    );
  }
}
