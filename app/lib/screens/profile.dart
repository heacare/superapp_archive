import 'package:flutter/material.dart';
import 'package:hea/models/user.dart';

import 'package:hea/providers/auth.dart';
import 'package:hea/screens/login.dart';
import 'package:hea/widgets/avatar_icon.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Future logout() async {
    await Authentication().logout();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
      return LoginScreen();
    }), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<User?>(
        builder: (context, user, _) {
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return loaded(user);
        }
    );
  }

  Widget loaded(User user) {
    final name = user.name;
    final height = user.height.toString() + "m";
    final weight = user.weight.toString() + "kg";
    final country = user.country;
    final gender = user.gender;
    final icon = user.icon;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                      child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: AvatarIcon(icon: icon, radius: 100)),
                      Text(name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24.0)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(weight,
                                style: const TextStyle(fontSize: 18.0)),
                            Text(height,
                                style: const TextStyle(fontSize: 18.0)),
                          ],
                        ),
                      )
                    ],
                  )),
                  OutlinedButton(child: const Text("Logout"), onPressed: logout)
                ])));
  }
}
