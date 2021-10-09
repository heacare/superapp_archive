import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {

  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: const Center(
          child: Text("Well, you are fucked")
      ),
    );
  }

}
