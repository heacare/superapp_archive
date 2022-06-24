import 'dart:math' show max;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Navigator;
import 'package:flutter/material.dart' as material show Navigator;
import 'package:provider/provider.dart' show Consumer;

import 'features/account/account_screen.dart' show AccountScreen;
import 'features/dashboard/dashboard_screen.dart' show DashboardScreen;
import 'features/demo.dart' show DemoScreen;
import 'features/preferences/preferences.dart' show Preferences;
import 'features/preferences/preferences_screen.dart'
    show PreferencesPage, PreferencesScreen;

class ForceRTL extends StatelessWidget {
  const ForceRTL(this.child, {super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) {
      return child;
    }
    Key key = UniqueKey();
    return Consumer<Preferences>(
      builder: (context, preferences, child) {
        if (preferences.forceRTL) {
          return Directionality(
            key: key,
            textDirection: TextDirection.rtl,
            child: child!,
          );
        }
        return Visibility(
          key: key,
          child: child!,
        );
      },
      child: child,
    );
  }
}

typedef _PreferredSizeWidgetBuilder = PreferredSizeWidget Function(
  BuildContext context,
);

class _NavigatorPage {
  const _NavigatorPage({
    required this.key,
    required this.tooltip,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.screen,
    this.desktopScreen,
    this.appBar,
    this.desktopAppBar,
  });

  final String key;
  final String tooltip;
  final String label;
  final Icon icon;
  final Icon selectedIcon;

  final WidgetBuilder? screen;
  final WidgetBuilder? desktopScreen;

  final _PreferredSizeWidgetBuilder? appBar;
  final _PreferredSizeWidgetBuilder? desktopAppBar;
}

Route _preferencesRouteBuilder(context, arguments) => MaterialPageRoute(
      builder: (context) => const ForceRTL(PreferencesPage()),
    );

Widget _preferencesButton(context) => IconButton(
      icon: const Icon(Icons.settings),
      tooltip: 'Settings',
      onPressed: () async {
        material.Navigator.of(context).restorablePush(_preferencesRouteBuilder);
      },
    );

final List<_NavigatorPage> _navigatorPages = [
  _NavigatorPage(
    key: 'home',
    tooltip: '',
    label: 'Home',
    icon: const Icon(Icons.chair_outlined),
    selectedIcon: const Icon(Icons.chair),
    screen: (context) => const DashboardScreen(),
    desktopScreen: (context) => const DashboardScreen(),
  ),
  _NavigatorPage(
    key: 'health',
    tooltip: '',
    label: 'Health',
    icon: const Icon(Icons.analytics_outlined),
    selectedIcon: const Icon(Icons.analytics),
    screen: (context) => const DemoScreen(),
    desktopScreen: (context) => const DemoScreen(),
  ),
  _NavigatorPage(
    key: 'account',
    tooltip: '',
    label: 'Account',
    icon: const Icon(Icons.person_outline),
    selectedIcon: const Icon(Icons.person),
    screen: (context) => const AccountScreen(),
    appBar: (context) => AppBar(
      title: const Text('Account'),
      centerTitle: true,
      actions: [_preferencesButton(context)],
    ),
    desktopScreen: (context) => const AccountScreen(),
    desktopAppBar: (context) => AppBar(
      title: const Text('Account'),
      centerTitle: true,
    ),
  ),
  _NavigatorPage(
    key: 'settings',
    tooltip: '',
    label: 'Settings',
    icon: const Icon(Icons.settings_outlined),
    selectedIcon: const Icon(Icons.settings),
    desktopScreen: (context) => const PreferencesScreen(),
    desktopAppBar: (context) => AppBar(
      title: const Text('Settings'),
      centerTitle: true,
    ),
  ),
];

final List<_NavigatorPage> _pages =
    _navigatorPages.where((page) => page.screen != null).toList();
final List<NavigationDestination> _destinations = _pages
    .map(
      (page) => NavigationDestination(
        tooltip: page.tooltip,
        label: page.label,
        icon: page.icon,
        selectedIcon: page.selectedIcon,
      ),
    )
    .toList();

final List<_NavigatorPage> _desktopPages =
    _navigatorPages.where((page) => page.desktopScreen != null).toList();
final List<NavigationRailDestination> _desktopDestinations = _desktopPages
    .map(
      (page) => NavigationRailDestination(
        label: Text(page.label),
        icon: page.icon,
        selectedIcon: page.selectedIcon,
      ),
    )
    .toList();

class Navigator extends StatefulWidget {
  const Navigator({super.key});

  @override
  State<Navigator> createState() => _NavigatorState();
}

class _NavigatorState extends State<Navigator> with RestorationMixin {
  final RestorableString _selectedKey = RestorableString('');

  @override
  void dispose() {
    _selectedKey.dispose();
    super.dispose();
  }

  @override
  String get restorationId => 'navigator';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedKey, 'selected_key');
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 1024) {
            return _build(context);
          } else {
            return _buildDesktop(context);
          }
        },
      );

  int _selectedIndex(List<_NavigatorPage> pages) =>
      max(pages.indexWhere((page) => page.key == _selectedKey.value), 0);

  void _setCurrentIndex(List<_NavigatorPage> pages, int index) {
    _selectedKey.value = pages[index].key;
  }

  Widget _build(BuildContext context) {
    int selectedIndex = _selectedIndex(_pages);
    _NavigatorPage selectedPage = _pages[selectedIndex];
    return Scaffold(
      appBar: selectedPage.appBar?.call(context),
      body: selectedPage.screen!.call(context),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
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
    _NavigatorPage selectedPage = _desktopPages[selectedIndex];
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            onDestinationSelected: (index) {
              setState(() {
                _setCurrentIndex(_desktopPages, index);
              });
            },
            selectedIndex: selectedIndex,
            destinations: _desktopDestinations,
            labelType: NavigationRailLabelType.all,
            leading: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Image.asset(
                'assets/brand/mark_160.png',
                width: 48,
                height: 48,
              ),
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
