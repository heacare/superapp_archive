import 'package:flutter/material.dart';

import 'package:hea/providers/auth.dart';
import 'package:hea/screens/login.dart';

class ProfileScreen extends StatefulWidget {

  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Future logout() async {
    await Authentication().logout();
    Navigator.of(context).pushAndRemoveUntil(
      new MaterialPageRoute(builder: (context) { return LoginScreen(); }),
      (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Column(
              children: [

                ListTile(title: const Text("hello"), leading: const Text('Name'))

              ],
            )
          ),

          Card(
            child: TextButton(child: const Text("Logout"), onPressed: logout)
          )
        ]
      )

    );
  }

}
