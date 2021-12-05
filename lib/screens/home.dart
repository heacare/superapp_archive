import 'package:flutter/material.dart';
import 'package:hea/screens/dashboard.dart';
import 'package:hea/screens/help_map.dart';

import 'package:hea/screens/profile.dart';
import 'package:hea/providers/auth.dart';

import 'package:hea/screens/contents.dart';

final auth = Authentication();

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var index = 5;

  @override
  Widget build(BuildContext context) {
    final bottomNavBg = Theme.of(context).colorScheme.primary;

    return Scaffold(
        body: pageFor(index),
        bottomNavigationBar: FancyBottomNav(icons: const <IconData>[
          Icons.home,
          Icons.map,
          Icons.book,
          Icons.person
        ], clicked: (i) => print(i)));
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

class FancyBottomNav extends StatefulWidget {
  const FancyBottomNav({Key? key, required this.icons, required this.clicked})
      : super(key: key);

  final List<IconData> icons;
  final void Function(int) clicked;
  @override
  _FancyBottomNavState createState() => _FancyBottomNavState();
}

class _FancyBottomNavState extends State<FancyBottomNav>
    with TickerProviderStateMixin {
  List<AnimationController> controllers = [];

  int currentActive = 0;

  @override
  void initState() {
    super.initState();
    // Setting up the animation controllers
    for (final _ in widget.icons) {
      var controller = AnimationController(
          duration: const Duration(milliseconds: 100), vsync: this);
      controller.value = 0.0;
      controllers.add(controller);
    }

    controllers[0].forward();
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(overflow: Overflow.visible, children: <Widget>[
      Container(
          child: const SizedBox(width: double.infinity, height: 70),
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFC6C6C6))))),
      ..._generateIcons(),
    ]));
  }

  List<Widget> _generateIcons() {
    var width = MediaQuery.of(context).size.width;
    print(width);
    var spacing =
        (width - (70 * widget.icons.length)) / (widget.icons.length + 1);

    List<Widget> icons = [];
    for (var i = 0; i < widget.icons.length; i++) {
      icons.add(AnimatedBottomIcon(
          icon: widget.icons[i],
          animation: controllers[i],
          offset: spacing + i * (spacing + 70),
          click: () {
            controllers[currentActive].reverse();
            controllers[i].forward();
            setState(() {
              currentActive = i;
            });

            widget.clicked(i);
          }));
    }

    return icons;
  }
}

class AnimatedBottomIcon extends AnimatedWidget {
  AnimatedBottomIcon(
      {Key? key,
      required this.icon,
      required Animation<double> animation,
      required this.offset,
      required this.click})
      : super(key: key, listenable: animation);

  final IconData icon;
  final double offset;
  final ColorTween logoTween =
      ColorTween(begin: const Color(0xFFB1B1B1), end: Colors.white);
  final VoidCallback click;

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Positioned(
        left: offset,
        bottom: animation.value * 30,
        child: GestureDetector(
            onTap: () => click(),
            child: Container(
              padding: const EdgeInsets.all(15.0),
              child:
                  Icon(icon, size: 40.0, color: logoTween.evaluate(animation)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context)
                        .colorScheme
                        .secondary
                        .withAlpha((animation.value * 255).toInt()),
                    Theme.of(context)
                        .colorScheme
                        .primary
                        .withAlpha((animation.value * 255).toInt()),
                  ],
                ),
                borderRadius: const BorderRadius.all(Radius.circular(25.0)),
              ),
            )));
  }
}
