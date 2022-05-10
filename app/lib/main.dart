import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';

import 'package:hea/screens/error.dart';
import 'package:hea/screens/home.dart';
import 'package:hea/screens/login.dart';
import 'package:hea/screens/onboarding.dart';
import 'package:hea/services/auth_service.dart';
import 'package:hea/services/service_locator.dart';
import 'package:hea/services/user_service.dart';
import 'package:hea/services/logging_service.dart';
import 'package:hea/services/notification_service.dart';
import 'package:hea/utils/sleep_notifications.dart';
import 'package:hea/utils/kv_wrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupServiceLocator();
  await findSystemLocale();
  initializeDateFormatting(Intl.systemLocale);
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  static _AppState of(BuildContext context) {
    _RestartInheritedWidget? result =
        context.findAncestorWidgetOfExactType<_RestartInheritedWidget>();
    return result!.data;
  }

  @override
  _AppState createState() => _AppState();
}

enum UserStatus {
  signedOut,
  registered,
  onboarded,
}

class _AppState extends State<App> {
  Key _key = UniqueKey();

  void restart() async {
    setState(() {
      _key = UniqueKey();
    });
  }

  ThemeData _getThemeData() {
    const primaryColor = Color(0xFFFA6E78);
    const accentColor = Color(0xFFFD9D5C);

    const primaryTextColor = Color(0xFF414141);
    const secondaryTextColor = Color(0xFF707070);

    // Stolen from https://medium.com/@filipvk/creating-a-custom-color-swatch-in-flutter-554bcdcb27f3
    MaterialColor createMaterialColor(int argb) {
      Color color = Color(argb);

      List strengths = <double>[.05];
      final swatch = <int, Color>{};
      final int r = color.red, g = color.green, b = color.blue;

      for (int i = 1; i < 10; i++) {
        strengths.add(0.1 * i);
      }
      for (var strength in strengths) {
        final double ds = 0.5 - strength;
        swatch[(strength * 1000).round()] = Color.fromRGBO(
          r + ((ds < 0 ? r : (255 - r)) * ds).round(),
          g + ((ds < 0 ? g : (255 - g)) * ds).round(),
          b + ((ds < 0 ? b : (255 - b)) * ds).round(),
          1,
        );
      }
      return MaterialColor(color.value, swatch);
    }

    final colorScheme = ColorScheme.fromSwatch(
        primarySwatch: createMaterialColor(primaryColor.value),
        accentColor: createMaterialColor(accentColor.value));

    return ThemeData(
        primaryColor: Colors.white,
        colorScheme: colorScheme,
        fontFamily: "Poppins",
        textTheme: const TextTheme(
            headline1: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                height: 1.1,
                color: primaryTextColor),
            headline2: TextStyle(
                fontSize: 21.0,
                fontWeight: FontWeight.w600,
                height: 1.2,
                color: primaryTextColor),
            headline3: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                height: 1.2,
                color: primaryTextColor),
            headline4: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
                height: 1.2,
                color: secondaryTextColor),
            bodyText1: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.0,
                height: 1.6,
                color: primaryTextColor),
            bodyText2: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.25,
                height: 1.4,
                color: primaryTextColor),
            overline: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              color: primaryTextColor,
            )),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            padding: const EdgeInsets.all(0.0),
            textStyle: const TextStyle(
                letterSpacing: 1.0,
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                height: 1.5,
                color: primaryTextColor),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(12.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            primary: Colors.white,
            backgroundColor: Colors.transparent,
            textStyle: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                height: 1.5,
                color: primaryTextColor),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
            fillColor: const Color(0xFFEBEBEB),
            filled: true,
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 2.0)),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: accentColor, width: 2.0))
            // TODO Error looks funky
            ),
        textSelectionTheme: ThemeData.light().textSelectionTheme);
  }

  @override
  Widget build(BuildContext context) {
    getUserData() async {
      await serviceLocator.allReady();

      // Authentication user exists separately from user data, so we have to check for the case where
      // the user signed up but uninstalled/reset the app before finishing onboarding
      final authService = serviceLocator<AuthService>();

      if (authService.currentUser() == null) {
        return UserStatus.signedOut;
      } else {
        authService.currentUserToken()?.then((token) => debugPrint(token));
        await serviceLocator<LoggingService>()
            .createLog('sleep', kvDump("sleep"));
        return await serviceLocator<UserService>().isCurrentUserOnboarded()
            ? UserStatus.onboarded
            : UserStatus.registered;
      }
    }

    final Future<UserStatus> hasUserData = getUserData();
    return _RestartInheritedWidget(
        key: _key,
        data: this,
        child: FutureBuilder(
          future: hasUserData,
          builder: (context, AsyncSnapshot<UserStatus> snapshot) {
            return MaterialApp(
                title: 'Happily Ever After',
                theme: _getThemeData(),
                // TODO design a loading page and a 'error' page
                // Match Firebase initialization result
                home: AnnotatedRegion<SystemUiOverlayStyle>(
                    value: SystemUiOverlayStyle.dark.copyWith(
                      systemNavigationBarColor: const Color(0xFFFFFFFF),
                      systemNavigationBarIconBrightness: Brightness.dark,
                      statusBarColor: const Color(0x40FFFFFF),
                    ),
                    child: NotificationHandler(
                        snapshot.connectionState == ConnectionState.done,
                        LifecycleHandler(mainScreen(snapshot)))));
          },
        ));
  }

  Widget mainScreen(AsyncSnapshot<UserStatus> snapshot) {
    if (snapshot.hasError) {
      debugPrint("Encountered error: ${snapshot.error}");
      return const ErrorScreen();
    }

    if (snapshot.connectionState != ConnectionState.done) {
      return Scaffold(
          body: Container(
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      ));
    }

    if (snapshot.hasData) {
      switch (snapshot.requireData) {
        case UserStatus.signedOut:
          return const LoginScreen();

        case UserStatus.registered:
          return const OnboardingScreen();

        case UserStatus.onboarded:
          return const HomeScreen();
      }
    }

    // Something has gone horribly wrong somehow
    return const ErrorScreen();
  }
}

class _RestartInheritedWidget extends InheritedWidget {
  final _AppState data;

  const _RestartInheritedWidget({
    required Key key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_RestartInheritedWidget old) {
    return false;
  }
}

class NotificationHandler extends StatelessWidget {
  final bool ready;
  final Widget child;
  const NotificationHandler(this.ready, this.child, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (ready) {
      serviceLocator<NotificationService>().ensureListen(context);
      scheduleSleepNotifications();
    }
    return child;
  }
}

class LifecycleHandler extends StatefulWidget {
  const LifecycleHandler(this.child, {Key? key}) : super(key: key);

  final Widget child;

  @override
  State<LifecycleHandler> createState() => LifecycleHandlerState();
}

class LifecycleHandlerState extends State<LifecycleHandler>
    with WidgetsBindingObserver {
  bool lastState = false;

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    bool active = state == AppLifecycleState.resumed ||
        state == AppLifecycleState.inactive;
    if (lastState == active) {
      return;
    }
    lastState = active;
    serviceLocator<LoggingService>().createLog("state", active);
  }
}
