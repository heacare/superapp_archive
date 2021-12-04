import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:hea/providers/auth.dart';
import 'package:hea/screens/error.dart';
import 'package:hea/screens/home.dart';
import 'package:hea/screens/login.dart';
import 'package:hea/screens/onboarding.dart';

import 'data/user_repo.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

enum UserStatus {
  signedOut,
  registered,
  onboarded,
}

class _AppState extends State<App> {

  final Future<FirebaseApp> _firebaseInit = Firebase.initializeApp();

  ThemeData _getThemeData() {

    const primaryColor = Color(0xFFFF5576);
    const accentColor = Color(0xFFFF7FAA);

    const primaryTextColor = Color(0xFF000000);
    const secondaryTextColor = Color(0xFF707070);

    const textColor = Color(0xFF191919);

    // Stolen from https://medium.com/@filipvk/creating-a-custom-color-swatch-in-flutter-554bcdcb27f3
    MaterialColor createMaterialColor(int argb) {
      Color color = Color(argb);

      List strengths = <double>[.05];
      final swatch = <int, Color>{};
      final int r = color.red, g = color.green, b = color.blue;

      for (int i = 1; i < 10; i++) {
        strengths.add(0.1 * i);
      }
      strengths.forEach((strength) {
        final double ds = 0.5 - strength;
        swatch[(strength * 1000).round()] = Color.fromRGBO(
          r + ((ds < 0 ? r : (255 - r)) * ds).round(),
          g + ((ds < 0 ? g : (255 - g)) * ds).round(),
          b + ((ds < 0 ? b : (255 - b)) * ds).round(),
          1,
        );
      });
      return MaterialColor(color.value, swatch);
    }

    final colorScheme = ColorScheme.fromSwatch(
        primarySwatch: createMaterialColor(primaryColor.value),
        accentColor: createMaterialColor(accentColor.value)
    );

    return ThemeData(
      colorScheme: colorScheme,
      fontFamily: "Poppins",
      textTheme: const TextTheme(
        headline1: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, height: 1.1, color: primaryTextColor),
        headline2: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal, height: 1.3, color: secondaryTextColor),
        bodyText1: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, height: 1.2, color: textColor),
        bodyText2: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, height: 1.2, color: textColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData (
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          padding: const EdgeInsets.all(0.0),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(12.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          primary: Colors.white,
          backgroundColor: Colors.transparent,
          textStyle: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, height: 1.5, color: primaryTextColor),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        fillColor: Color(0xFFE5E5E5),
        filled: true,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 2.0
          )
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor,
            width: 2.0
          )
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: accentColor,
            width: 2.0
          )
        )
        // TODO Error looks funky
      ),
      textSelectionTheme: ThemeData.light().textSelectionTheme
    );
  }

  @override
  Widget build(BuildContext context) {

    final Future<UserStatus> hasUserData = _firebaseInit.then((value) async {
      // Authentication user exists separately from user data, so we have to check for the case where
      // the user signed up but uninstalled/reset the app before finishing onboarding
      final authUser = Authentication().currentUser();
      if (authUser == null) {
        return UserStatus.signedOut;
      }
      else {
        return (await UserRepo().get(authUser.uid) == null)
            ? UserStatus.registered
            : UserStatus.onboarded;
      }
    });

    return FutureBuilder(
      future: hasUserData,
      builder: (context, AsyncSnapshot<UserStatus> snapshot) {
        return MaterialApp(
          title: 'Happily Ever After',
          theme: _getThemeData(),
          // TODO design a loading page and a 'error' page
          // Match Firebase initialization result
          home: SafeArea (
            child: LayoutBuilder (
              builder: (context, constraints) {
                return Scaffold (
                  body: SingleChildScrollView (
                    physics: const ClampingScrollPhysics(),
                    child: SizedBox(
                      height: constraints.biggest.height,
                      child: Padding (
                        padding: const EdgeInsets.symmetric(horizontal: 37.0, vertical: 37.0),
                        child: mainScreen(snapshot),
                      )
                    )
                  )
                );
              },
            ),
            // child: mainScreen(snapshot)
          ),
        );
      },
    );
  }

  Widget mainScreen(AsyncSnapshot<UserStatus> snapshot) {
    if (snapshot.hasError) {
      print("Encountered error: ${snapshot.error}");
      return const ErrorScreen();
    }

    if (snapshot.connectionState != ConnectionState.done) {
      return const Text("Loading...");
    }

    if (snapshot.hasData) {
      switch (snapshot.requireData) {

        case UserStatus.signedOut:
          return LoginScreen();

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
