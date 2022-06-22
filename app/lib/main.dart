import 'dart:async' show unawaited;

import 'package:dynamic_color/dynamic_color.dart' show DynamicColorBuilder;
import 'package:flutter/material.dart' show MaterialApp, ThemeData, Brightness;
import 'package:flutter/services.dart' show SystemChrome, SystemUiMode;
import 'package:flutter/widgets.dart' hide Navigator;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart'
    show Provider, MultiProvider, ChangeNotifierProvider;

import 'features/account/account.dart' show Account, AppAccount;
import 'features/database/database.dart' show Database, databaseOpen;
import 'features/interim_data_collection/interim_data_collection.dart';
import 'features/preferences/preferences.dart' show Preferences, AppPreferences;
import 'navigator.dart';
import 'old/old.dart' show oldSetup, LifecycleHandler;
import 'system/additional_licenses.dart' show licensesInitialize;
import 'system/crashlogger.dart' show crashloggerWrap;
import 'system/firebase.dart' show firebaseInitialize;
import 'system/theme.dart' show resolveThemeData, resolveOverlayStyle;

// ignore: do_not_use_environment
const String compat = String.fromEnvironment('COMPAT');

void main() async {
  await crashloggerWrap(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await firebaseInitialize();
  }, () async {
    if (compat != 'disabled') {
      await oldSetup();
    }

    licensesInitialize();
    // TODO(serverwentdown): Improve shared_preferences and sqflite startup time
    Preferences preferences = await AppPreferences.load();
    Database database = await databaseOpen();
    Account account = await AppAccount.load(database);
    interimDataCollectionSetup(account);
    unawaited(
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
      ),
    );
    runApp(
      App(
        preferences: preferences,
        account: account,
      ),
    );
  });
}

class App extends StatelessWidget {
  const App({
    super.key,
    required this.preferences,
    required this.account,
  });

  final Preferences preferences;
  final Account account;

  @override
  Widget build(BuildContext context) => DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) {
          ThemeData lightThemeData = resolveThemeData(
            Brightness.light,
            lightDynamic,
          );
          ThemeData darkThemeData = resolveThemeData(
            Brightness.dark,
            darkDynamic,
          );

          return MultiProvider(
            providers: [
              ChangeNotifierProvider<Preferences>.value(value: preferences),
              ChangeNotifierProvider<Account>.value(value: account),
            ],
            child: const ForceRTL(Navigator()),
            builder: (context, child) {
              Preferences preferences = Provider.of<Preferences>(context);
              SystemChrome.setSystemUIOverlayStyle(
                resolveOverlayStyle(preferences.themeMode),
              );
              return MaterialApp(
                title: 'Happily Ever After',
                themeMode: preferences.themeMode,
                theme: lightThemeData,
                darkTheme: darkThemeData,
                localizationsDelegates: localizationsDelegates,
                supportedLocales: supportedLocales,
                locale: preferences.locale,
                restorationScopeId: 'root',
                home: compat != 'disabled'
                    ? LifecycleHandler(true, child!)
                    : child,
              );
            },
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
