import 'package:flutter/material.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text(MaterialLocalizations.of(context).formatCompactDate(DateTime.now())),
    ]);
  }
}
