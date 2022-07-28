import 'dart:async' show unawaited;

import 'package:dynamic_color/dynamic_color.dart' show DynamicColorBuilder;
import 'package:flutter/material.dart'
    show MaterialApp, ThemeData, Brightness, ColorScheme;
import 'package:flutter/services.dart' show SystemChrome, SystemUiMode;
import 'package:flutter/widgets.dart' hide Navigator;
import 'package:flutter_gen/gen_l10n/app_localizations.dart'
    show AppLocalizations;
import 'package:provider/provider.dart'
    show Provider, MultiProvider, ChangeNotifierProvider;

import 'features/account/account.dart' show Account, AppAccount;
import 'features/database/database.dart' show Database, databaseOpen;
import 'features/interim_data_collection/interim_data_collection.dart'
    show interimDataCollectionSetup;
import 'features/onboarding/onboarding.dart' show Onboarding, AppOnboarding;
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
    final Preferences preferences = await AppPreferences.load();
    final Database database = await databaseOpen();
    final Account account = await AppAccount.load(database);
    final Onboarding onboarding =
        await AppOnboarding.load(preferences, account);
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
        onboarding: onboarding,
      ),
    );
  });
}

class App extends StatelessWidget {
  const App({
    super.key,
    required this.preferences,
    required this.account,
    required this.onboarding,
  });

  final Preferences preferences;
  final Account account;
  final Onboarding onboarding;

  @override
  Widget build(final BuildContext context) => DynamicColorBuilder(
        builder:
            (final ColorScheme? lightDynamic, final ColorScheme? darkDynamic) {
          final ThemeData lightThemeData = resolveThemeData(
            Brightness.light,
            lightDynamic,
          );
          final ThemeData darkThemeData = resolveThemeData(
            Brightness.dark,
            darkDynamic,
          );

          return MultiProvider(
            providers: [
              ChangeNotifierProvider<Preferences>.value(value: preferences),
              ChangeNotifierProvider<Account>.value(value: account),
              ChangeNotifierProvider<Onboarding>.value(value: onboarding),
            ],
            child: const ForceRTL(Navigator()),
            builder: (final BuildContext context, final Widget? child) {
              final Preferences preferences = Provider.of<Preferences>(context);
              SystemChrome.setSystemUIOverlayStyle(
                resolveOverlayStyle(preferences.themeMode),
              );
              return MaterialApp(
                title: 'Happily Ever After',
                themeMode: preferences.themeMode,
                theme: lightThemeData,
                darkTheme: darkThemeData,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
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
