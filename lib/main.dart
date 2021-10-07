import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:hea/providers/auth.dart';
import 'package:hea/screens/home.dart';
import 'package:hea/screens/login.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  final Future<FirebaseApp> _firebaseInit = Firebase.initializeApp();

  ThemeData _getThemeData() {

    const primaryColor = Color(0xFFCC3363);
    const accentColor = Color(0xFF62C370);
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
      fontFamily: "BreeSerif",
      textTheme: const TextTheme(
        headline1: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold, height: 1.1, color: primaryColor),
        headline2: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal, height: 1.4, color: textColor),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(12.0),
          primary: Colors.white,
          backgroundColor: primaryColor,
          textStyle: const TextStyle(fontFamily: "BreeSerif", fontSize: 24.0, fontWeight: FontWeight.bold, height: 1)
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2.0
          )
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: accentColor,
            width: 2.0
          )
        )
        // TODO Error looks funky
        // TODO Copy/cut menu looks funky as hell
      ),
      textSelectionTheme: ThemeData.light().textSelectionTheme
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _firebaseInit,
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'Happily Ever After',
          theme: _getThemeData(),
          // TODO design a loading page and a 'error' page
          // Match Firebase initialization result
          home: mainScreen(snapshot)
        );
      },
    );
  }

  Widget mainScreen(AsyncSnapshot<Object?> snapshot) {
    if (snapshot.hasError) {
      return const Text("Firebase initialization failed!");
    }

    if (snapshot.connectionState != ConnectionState.done) {
      return const Text("Loading...");
    }

    if (Authentication().currentUser() == null) {
      // TODO this should be StageA first
      return LoginScreen();
    } else {
      return HomeScreen();
    }
  }
}
