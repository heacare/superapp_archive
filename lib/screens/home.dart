import 'package:flutter/material.dart';

import 'package:hea/providers/auth.dart';

import 'package:hea/screens/contents.dart';

final auth = Authentication();

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Happily Ever After - Home"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Hello welcome to mai shiny app"),
            TextButton(child: Text("VIEW CONTENT"), onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ContentsScreen() ));
            })
          ]
        )
      ),
    );
  }
}
