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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _firebaseInit,
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'Happily Ever After',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
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
