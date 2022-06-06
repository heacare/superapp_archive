import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show MaterialApp;

import 'package:provider/provider.dart' show ChangeNotifierProvider, Provider;

import 'firebase.dart' show firebaseInitialize;
import 'intl.dart' show intlInitialize;
import 'crashlogger.dart' show crashloggerWrap;
import 'theme.dart' show HEAThemeData;
import 'display_options.dart' show DisplayOptions;

import 'demo.dart' show DemoScreen;

import 'old/old.dart' show oldMain;

const devel = String.fromEnvironment("DEVEL", defaultValue: "");

void main() async {
  if (devel != "playground") {
    await oldMain();
    return;
  }

  crashloggerWrap(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await firebaseInitialize();
    await intlInitialize();
  }, () async {
    runApp(const App());
  });
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DisplayOptions()..load(),
        builder: (context, child) {
          return MaterialApp(
            title: 'Happily Ever After',
            themeMode: Provider.of<DisplayOptions>(context).themeMode,
            theme: HEAThemeData.lightThemeData,
            darkTheme: HEAThemeData.darkThemeData,
            home: child,
          );
        },
        child: const DemoScreen());
  }
}
