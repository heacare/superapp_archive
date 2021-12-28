import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:hea/models/user.dart';
import 'package:hea/screens/dashboard.dart';
import 'package:hea/screens/error.dart';
import 'package:hea/screens/help_map.dart';
import 'package:hea/screens/profile.dart';
import 'package:hea/services/service_locator.dart';
import 'package:hea/services/user_service.dart';
import 'package:hea/screens/modules.dart';

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

  // TODO
  Widget pageFor(num index) {

    Widget child;
    if (index == 0) {
      child = const DashboardScreen();
    }
    else if (index == 1) {
      child = const ModulesScreen();
    }
    else if (index == 2) {
      child = HelpMapScreen();
    }
    else if (index == 3) {
      child = ProfileScreen();
    }
    else {
      // Should never hit this unless something goes horribly wrong
      child = const ErrorScreen();
    }

    return FutureProvider<User?>(
        initialData: null,
        create: (context) => serviceLocator<UserService>().getCurrentUser(),
        child: child,
        catchError: (context, error) {
          log("$error");
          log("${StackTrace.current}");
          return null;
        },
    );
  }
}
