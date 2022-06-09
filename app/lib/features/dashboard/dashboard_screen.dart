import 'package:flutter/material.dart';

import '../../main.dart';
import '../../old/screens/dashboard.dart' as old;

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (compat != 'disabled') {
      return const old.DashboardScreen();
    }
    return const Center(
      child: Text('Compat mode disabled and dashboard not implemented'),
    );
  }
}
