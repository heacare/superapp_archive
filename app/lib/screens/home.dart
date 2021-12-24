import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:hea/models/user.dart';
import 'package:hea/screens/dashboard.dart';
import 'package:hea/screens/error.dart';
import 'package:hea/screens/help_map.dart';
import 'package:hea/screens/profile.dart';
import 'package:hea/providers/auth.dart';
import 'package:hea/screens/contents.dart';
import 'package:hea/services/service_locator.dart';
import 'package:hea/services/user_service.dart';

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
    final bottomNavBg = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: pageFor(index),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: "Home", backgroundColor: bottomNavBg),
          BottomNavigationBarItem(icon: const Icon(Icons.book), label: "Content", backgroundColor: bottomNavBg),
          BottomNavigationBarItem(icon: const Icon(Icons.healing), label: "Health", backgroundColor: bottomNavBg),
          BottomNavigationBarItem(icon: const Icon(Icons.verified_user), label: "Profile", backgroundColor: bottomNavBg),
        ],
        currentIndex: index,
        onTap: (i) { setState(() { index = i; }); }
      ),
    );
  }

  // TODO
  Widget pageFor(num index) {

    Widget child;
    if (index == 0) {
      child = const DashboardScreen();
    }
    else if (index == 1) {
      child = const ContentsScreen();
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
        child: child
    );

    // Dead code
    return Scaffold(
      appBar: AppBar(title: Text("Page "+index.toString())),
      body: Center(
          child: Text("Page " + index.toString())
      )
    );
  }
}
