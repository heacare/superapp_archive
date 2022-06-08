import 'dart:math' show max;
import 'package:flutter/material.dart' hide Navigator;
import 'package:flutter/material.dart' as material show Navigator;

import 'package:provider/provider.dart' show Consumer;

import 'system/log.dart';
import 'features/preferences/preferences.dart';
import 'features/preferences/preferences_screen.dart';
import 'features/account/account_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'demo.dart';

class ForceRTL extends StatelessWidget {
  const ForceRTL(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Key _key = UniqueKey();
    return Consumer<Preferences>(
      builder: (context, preferences, child) {
        if (preferences.forceRTL) {
          return Directionality(
            key: _key,
            textDirection: TextDirection.rtl,
            child: child!,
          );
        }
        return Container(
          key: _key,
          child: child,
        );
      },
      child: child,
    );
  }
}

typedef PreferredSizeWidgetBuilder = PreferredSizeWidget Function(
    BuildContext context);

class NavigatorPage {
  const NavigatorPage(
      {required this.key,
      required this.tooltip,
      required this.label,
      required this.icon,
      required this.selectedIcon,
      this.screen,
      this.desktopScreen,
      this.appBar,
      this.desktopAppBar});

  final String key;
  final String tooltip;
  final String label;
  final Icon icon;
  final Icon selectedIcon;

  final WidgetBuilder? screen;
  final WidgetBuilder? desktopScreen;

  final PreferredSizeWidgetBuilder? appBar;
  final PreferredSizeWidgetBuilder? desktopAppBar;
}

final WidgetBuilder _preferencesButton = (context) => IconButton(
      icon: const Icon(Icons.settings),
      tooltip: 'Settings',
      onPressed: () async {
        /*
        material.Navigator.of(context).push(
          route((context) => const PreferencesPage())
        );
        */
        await material.Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ForceRTL(PreferencesPage())));
      },
    );

final List<NavigatorPage> _navigatorPages = [
  NavigatorPage(
    key: 'home',
    tooltip: '',
    label: 'Home',
    icon: const Icon(Icons.chair_outlined),
    selectedIcon: const Icon(Icons.chair),
    screen: (context) => const DashboardScreen(),
    desktopScreen: (context) => const DashboardScreen(),
  ),
  NavigatorPage(
    key: 'health',
    tooltip: '',
    label: 'Health',
    icon: const Icon(Icons.analytics_outlined),
    selectedIcon: const Icon(Icons.analytics),
    screen: (context) => const DemoScreen(),
    desktopScreen: (context) => const DemoScreen(),
  ),
  NavigatorPage(
    key: 'account',
    tooltip: '',
    label: 'Account',
    icon: const Icon(Icons.person_outline),
    selectedIcon: const Icon(Icons.person),
    screen: (context) => const AccountScreen(),
    appBar: (context) => AppBar(
      title: const Text("Account"),
      centerTitle: true,
      actions: [_preferencesButton(context)],
    ),
    desktopScreen: (context) => const AccountScreen(),
    desktopAppBar: (context) => AppBar(
      title: const Text("Account"),
      centerTitle: true,
    ),
  ),
  NavigatorPage(
    key: 'settings',
    tooltip: '',
    label: 'Settings',
    icon: const Icon(Icons.settings_outlined),
    selectedIcon: const Icon(Icons.settings),
    desktopScreen: (context) => const PreferencesScreen(),
    desktopAppBar: (context) => AppBar(
      title: const Text("Settings"),
      centerTitle: true,
    ),
  ),
];

final List<NavigatorPage> _pages =
    _navigatorPages.where((page) => page.screen != null).toList();
final List<NavigationDestination> _destinations = _pages
    .map((page) => NavigationDestination(
          tooltip: page.tooltip,
          label: page.label,
          icon: page.icon,
          selectedIcon: page.selectedIcon,
        ))
    .toList();

final List<NavigatorPage> _desktopPages =
    _navigatorPages.where((page) => page.desktopScreen != null).toList();
final List<NavigationRailDestination> _desktopDestinations = _desktopPages
    .map((page) => NavigationRailDestination(
          label: Text(page.label),
          icon: page.icon,
          selectedIcon: page.selectedIcon,
        ))
    .toList();

class Navigator extends StatefulWidget {
  const Navigator({super.key});

  @override
  State<Navigator> createState() => _NavigatorState();
}

class _NavigatorState extends State<Navigator> {
  String _selectedKey = "";

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 1024) {
        return _build(context);
      } else {
        return _buildDesktop(context);
      }
    });
  }

  int _selectedIndex(List<NavigatorPage> pages) {
    return max(pages.indexWhere((page) => page.key == _selectedKey), 0);
  }

  void _setCurrentIndex(List<NavigatorPage> pages, int index) {
    _selectedKey = pages[index].key;
  }

  Widget _build(BuildContext context) {
    int selectedIndex = _selectedIndex(_pages);
    NavigatorPage selectedPage = _pages[selectedIndex];

    return Scaffold(
      appBar: selectedPage.appBar?.call(context),
      body: selectedPage.screen!.call(context),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _setCurrentIndex(_pages, index);
          });
        },
        selectedIndex: selectedIndex,
        destinations: _destinations,
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    int selectedIndex = _selectedIndex(_desktopPages);
    NavigatorPage selectedPage = _desktopPages[selectedIndex];

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            onDestinationSelected: (int index) {
              setState(() {
                _setCurrentIndex(_desktopPages, index);
              });
            },
            selectedIndex: selectedIndex,
            destinations: _desktopDestinations,
            labelType: NavigationRailLabelType.all,
            leading: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Image.asset("assets/brand/mark_160.png", width: 48),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                if (selectedPage.desktopAppBar != null)
                  selectedPage.desktopAppBar!(context),
                if (selectedPage.desktopScreen != null)
                  Expanded(child: selectedPage.desktopScreen!(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
