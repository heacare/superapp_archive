import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import 'dashboard.dart';
import 'error.dart';
//import 'package:hea/screens/healers.dart';
import 'profile.dart';
import '../services/service_locator.dart';
import '../services/user_service.dart';
//import 'package:hea/providers/map.dart';
import '../utils/sleep_log.dart';

import '../widgets/fancy_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var index = 0;

  @override
  Widget build(BuildContext context) {
    super.activate();
    sleepLog();
    return Scaffold(
        body: pageFor(index),
        bottomNavigationBar: FancyBottomNav(
            icons: const <IconData>[Icons.home, /* Icons.map, */ Icons.person],
            clicked: (i) => setState(() {
                  index = i;
                })));
  }

  Widget pageFor(num index) {
    Widget child;
    if (index == 0) {
      child = const DashboardScreen();
    } else if (index == 1) {
      /*
      child = ChangeNotifierProvider<MapProvider>(
        create: (_) => MapProvider(),
        builder: (context, _) => HealersScreen());
      } else if (index == 2) {
      */
      child = const ProfileScreen();
    } else {
      // Should never hit this unless something goes horribly wrong
      child = const ErrorScreen();
    }

    return FutureProvider<User?>(
      initialData: null,
      create: (context) => serviceLocator<UserService>().getCurrentUser(),
      child: child,
    );
  }
}
