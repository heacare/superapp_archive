import 'package:flutter/material.dart';

import 'package:hea/screens/profile.dart';
import 'package:hea/providers/auth.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text("Page "+index.toString())),
      body: Center(
          child: Text("Page " + index.toString())
      )
    );
  }
}
