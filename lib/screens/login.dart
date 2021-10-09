import 'package:flutter/material.dart';
import 'package:hea/widgets/firebase_svg.dart';
import 'package:health/health.dart';

import 'package:hea/data/user_repo.dart';
import 'package:hea/models/user.dart';
import 'package:hea/providers/auth.dart';
import 'package:hea/screens/health_setup.dart';
import 'package:hea/screens/home.dart';
import 'package:hea/screens/onboarding.dart';

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
      var userJson = User(userId).toJson();

      // Pull health data
      List<HealthDataPoint> healthData = await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const HealthSetupScreen())
      );
      userJson["healthData"] = healthData.map((e) => e.toJson()).toList();

      // Onboarding
      await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => OnboardingScreen(userJson: userJson))
      );
    }
    else {
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
              child: Text("Welcome!", style: Theme.of(context).textTheme.headline1),
              padding: const EdgeInsets.symmetric(vertical: 16.0)
          ),
          Text(
              "We’re glad you decided to join us, in building a happier, healthier you.",
              style: Theme.of(context).textTheme.headline2
          ),

          const SizedBox(height: 24.0),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: OutlinedButton(
              child: const Text("LOGIN"),
              onPressed: () => setState(() => _loginChoice = LoginChoice.login)
            )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: OutlinedButton(
              child: const Text("SIGNUP"),
              onPressed: () => setState(() => _loginChoice = LoginChoice.signUp),
              style: TextButton.styleFrom(
                primary: Theme.of(context).colorScheme.primary,
                backgroundColor: Colors.grey[100]
              ),
            )
          ),
        ]
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IconButton(
              icon: const BackButtonIcon(),
              iconSize: 36.0,
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.all(0.0),
              splashRadius: 24.0,
              constraints: const BoxConstraints(),
              onPressed: () => setState(() => _loginChoice = LoginChoice.unselected),
            ),
            const SizedBox(width: 16.0),
            Text(
                _loginChoice == LoginChoice.login ? "Login" : "Sign Up",
                style: Theme.of(context).textTheme.headline1
            ),
          ]
        ),

        const SizedBox(height: 24.0),
        TextFormField(controller: _email, decoration: const InputDecoration(labelText: "Email")),
        const SizedBox(height: 8.0),
        TextFormField(controller: _password, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
        const SizedBox(height: 36.0),
        OutlinedButton(
          child: const Text("LET'S GO"),
          onPressed: () {
            _loginChoice == LoginChoice.login ? login() : signup();
          },
        ),
      ]
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                Expanded(
                  flex: 3,
                  child: Transform.translate(
                    child: FirebaseSvg("login.svg").load(),
                    offset: Offset(-MediaQuery.of(context).size.width / 6, 0.0)
                  )
                ),

                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _credsOrText(),
                      ],
                    )
                  )
                ),

              ],
            )
          )
        )
      ),
    );
  }
}
