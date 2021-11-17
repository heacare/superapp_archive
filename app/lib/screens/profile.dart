import 'package:flutter/material.dart';
import 'package:hea/data/user_repo.dart';
import 'package:hea/models/user.dart';

import 'package:hea/providers/auth.dart';
import 'package:hea/screens/login.dart';
import 'package:hea/widgets/avatar_icon.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<User?> userFuture = UserRepo().getCurrent();

  Future logout() async {
    await Authentication().logout();
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(builder: (context) {
      return LoginScreen();
    }), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: userFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error!");
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data == null) {
            return const Text("No user?!");
          }
          return loaded(context, snapshot.data as User);
        });
  }

  Widget loaded(BuildContext context, User user) {
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
