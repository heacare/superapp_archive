import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hea/providers/storage.dart';
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

class _LoginScreenState extends State<LoginScreen> {
  final _auth = Authentication();

  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FutureBuilder<String>(
                        // TODO Check Firebase perms for storage
                        future: Storage().getFileUrl("health_sync.svg"),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.primary,
                              strokeWidth: 8,
                            );
                          }

                          return SvgPicture.network(snapshot.data!);
                        },
                      ),
                    )
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // TODO validate email
                        TextFormField(controller: _email, decoration: const InputDecoration(labelText: "Email")),
                        TextFormField(controller: _password, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: OutlinedButton(child: const Text("LOGIN"), onPressed: login)
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: OutlinedButton(
                            child: const Text("SIGNUP"),
                            onPressed: signup,
                            style: TextButton.styleFrom(
                              primary: Theme.of(context).colorScheme.primary,
                              backgroundColor: Colors.grey[100]
                            ),
                          )
                        ),
                      ],
                    )
                  )
                ],
              )
            )
          )
        )
      ),
    );
  }
}
