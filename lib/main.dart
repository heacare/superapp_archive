import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:hea/screens/home.dart';

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
          home:
            snapshot.hasError ? const Text("Firebase initialization failed!") :
                snapshot.connectionState != ConnectionState.done ? const Text("Loading...") :
                  const HomeScreen(),
        );
      },
    );
  }
}
