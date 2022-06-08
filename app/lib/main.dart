import 'package:flutter/material.dart' show MaterialApp;
import 'package:flutter/services.dart' show SystemChrome;
import 'package:flutter/widgets.dart' hide Navigator;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart' show ChangeNotifierProvider, Provider;

import 'features/preferences/preferences.dart' show Preferences, AppPreferences;
import 'navigator.dart';
import 'old/old.dart' show oldSetup;
import 'system/crashlogger.dart' show crashloggerWrap;
import 'system/firebase.dart' show firebaseInitialize;
import 'system/theme.dart' show Theme;

// ignore: do_not_use_environment
const String compat = String.fromEnvironment('COMPAT');

void main() async {
  crashloggerWrap(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await firebaseInitialize();
  }, () async {
    if (compat != 'disabled') {
      await oldSetup();
    }

    Preferences preferences = await AppPreferences.load();
    runApp(
      App(
        preferences: preferences,
      ),
    );
  });
}

class App extends StatelessWidget {
  const App({super.key, required this.preferences});

  final Preferences preferences;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider.value(
        value: preferences,
        child: const ForceRTL(Navigator()),
        builder: (context, child) {
          Preferences preferences = Provider.of<Preferences>(context);
          SystemChrome.setSystemUIOverlayStyle(
            Theme.resolveOverlayStyle(preferences.themeMode),
          );
          return MaterialApp(
            title: 'Happily Ever After',
            themeMode: preferences.themeMode,
            theme: Theme.lightThemeData,
            darkTheme: Theme.darkThemeData,
            localizationsDelegates: localizationsDelegates,
            supportedLocales: supportedLocales,
            locale: preferences.locale,
            home: child,
          );
        },
      );
}

const List<LocalizationsDelegate<Object>> localizationsDelegates = [
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

const List<Locale> supportedLocales = [
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
