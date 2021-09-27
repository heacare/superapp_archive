import 'package:flutter/material.dart';

import 'package:hea/providers/auth.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final auth = Authentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login/Signup"),
      ),
      body: Center(
          child: Row(
            children: [
            ]
          ),
      ),
    );
  }

}
