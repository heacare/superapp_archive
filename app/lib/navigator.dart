import 'package:flutter/material.dart';

import 'package:provider/provider.dart' show Provider;

import 'features/preferences/preferences.dart';
import 'demo.dart';
import 'system/log.dart';

class Navigator extends StatefulWidget {
  const Navigator({super.key});

  @override
  State<Navigator> createState() => _NavigatorState();
}

class _NavigatorState extends State<Navigator> {
  int _currentIndex = 0;

  final List<Widget> _children = const [
    DemoScreen(),
    DemoScreen(),
    DemoScreen(),
    DemoScreen(),
  ];

  final List<BottomNavigationBarItem> _items = const [
    BottomNavigationBarItem(label: "Add", icon: Icon(Icons.add)),
    BottomNavigationBarItem(label: "History", icon: Icon(Icons.history)),
    BottomNavigationBarItem(label: "Meh", icon: Icon(Icons.analytics_outlined)),
    BottomNavigationBarItem(label: "Settings", icon: Icon(Icons.settings)),
  ];

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Happily Ever After'),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: _items,
          currentIndex: _currentIndex,
          onTap: (int i) {
            setState(() {
              _currentIndex = i;
            });
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Preferences preferences =
                Provider.of<Preferences>(context, listen: false);
            if (preferences.themeMode == ThemeMode.system) {
              preferences.setThemeMode(ThemeMode.light);
            } else if (preferences.themeMode == ThemeMode.light) {
              preferences.setThemeMode(ThemeMode.dark);
            } else if (preferences.themeMode == ThemeMode.dark) {
              preferences.setThemeMode(ThemeMode.system);
            }

            final snackBar = SnackBar(
              content: Text(
                'Using ${preferences.themeMode} theme',
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          tooltip: "Change theme",
          child: const Icon(Icons.palette),
        ),
        body: _children[_currentIndex]);
  }
}
