import 'package:flutter/material.dart';

import 'package:hea/data/user_repo.dart';
import 'package:hea/providers/auth.dart';
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
      // User is not onboarded yet
      await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => OnboardingScreen(userId: userId)),
          (route) => false
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
      appBar: AppBar(
        title: const Text("Login/Signup"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // TODO validate email
                  TextFormField(controller: _email, decoration: const InputDecoration(labelText: "Email")),

                  TextFormField(controller: _password, decoration: const InputDecoration(labelText: "Password"), obscureText: true),

                  TextButton(child: const Text("LOGIN"), onPressed: login),
                  TextButton(child: const Text("SIGNUP"), onPressed: signup),

                ],
              )
            )
          )
        )
      ),
    );
  }
}
