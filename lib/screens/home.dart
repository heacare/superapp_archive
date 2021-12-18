import 'package:flutter/material.dart';
import 'package:hea/screens/dashboard.dart';
import 'package:hea/screens/help_map.dart';

import 'package:hea/screens/profile.dart';
import 'package:hea/providers/auth.dart';

import 'package:hea/screens/contents.dart';

import 'package:hea/widgets/fancy_bottom_bar.dart';

final auth = Authentication();

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pageFor(index),
        bottomNavigationBar: FancyBottomNav(
            icons: const <IconData>[
              Icons.home,
              Icons.map,
              Icons.book,
              Icons.person
            ],
            clicked: (i) => setState(() {
                  index = i;
                })));
  }

  Widget pageFor(num index) {
    if (index == 0) {
      return DashboardScreen();
    }

    if (index == 1) {
      return ContentsScreen();
    }

    if (index == 2) {
      return HelpMapScreen();
    }

    if (index == 3) {
      return ProfileScreen();
    }
    return Scaffold(
        appBar: AppBar(title: Text("Page " + index.toString())),
        body: Center(child: Text("Page " + index.toString())));
  }
}
