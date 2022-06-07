import 'package:flutter/material.dart';

import 'demo.dart';

class Navigator extends StatefulWidget {
  const Navigator({super.key});

  @override
  State<Navigator> createState() => _NavigatorState();
}

class _NavigatorState extends State<Navigator> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    const DemoScreen(),
    const DemoScreen(),
    const DemoScreen(),
    const DemoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          items: [
            BottomNavigationBarItem(label: "", icon: Icon(Icons.add)),
            BottomNavigationBarItem(label: "", icon: Icon(Icons.history)),
            BottomNavigationBarItem(
                label: "", icon: Icon(Icons.analytics_outlined)),
            BottomNavigationBarItem(label: "", icon: Icon(Icons.settings)),
          ],
          selectedItemColor: Colors.black,
          onTap: (int i) {
            setState(() {
              _currentIndex = i;
            });
          },
        ),
        body: _children[_currentIndex]);
  }
}
