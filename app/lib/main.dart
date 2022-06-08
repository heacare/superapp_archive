import 'package:flutter/widgets.dart' hide Navigator;
import 'package:flutter/material.dart' show MaterialApp;
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:provider/provider.dart' show ChangeNotifierProvider, Provider;

import 'system/firebase.dart' show firebaseInitialize;
import 'system/crashlogger.dart' show crashloggerWrap;
import 'system/theme.dart' show Theme;
import 'features/preferences/preferences.dart' show Preferences, AppPreferences;
import 'navigator.dart';

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
  }, () async {
    Preferences preferences = await AppPreferences.load();
    runApp(App(
      preferences: preferences,
    ));
  });
}

class App extends StatelessWidget {
  const App({super.key, required this.preferences});

  final Preferences preferences;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: preferences,
      child: const Navigator(),
      builder: (context, child) {
        Preferences preferences = Provider.of<Preferences>(context);
        return MaterialApp(
          title: 'Happily Ever After',
          //themeMode: preferences.themeMode,
          //theme: Theme.lightThemeData,
          darkTheme: Theme.darkThemeData,
          localizationsDelegates: localizationsDelegates,
          supportedLocales: supportedLocales,
          locale: preferences.locale,
          home: child,
        );
      },
    );
  }
}

const localizationsDelegates = [
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

const supportedLocales = [
  // Enable all English locales
  Locale.fromSubtags(languageCode: 'en', scriptCode: 'SG'),
  Locale.fromSubtags(languageCode: 'en', scriptCode: 'ZA'),
  Locale.fromSubtags(languageCode: 'en', scriptCode: 'NZ'),
  Locale.fromSubtags(languageCode: 'en', scriptCode: 'IN'),
  Locale.fromSubtags(languageCode: 'en', scriptCode: 'IE'),
  Locale.fromSubtags(languageCode: 'en', scriptCode: 'GB'),
  Locale.fromSubtags(languageCode: 'en', scriptCode: 'CA'),
  Locale.fromSubtags(languageCode: 'en', scriptCode: 'AU'),
  Locale.fromSubtags(languageCode: 'en', scriptCode: 'US'),
  Locale.fromSubtags(languageCode: 'en'),
];
