import 'package:flutter/material.dart';

import '../../main.dart';
import '../../old/screens/profile.dart' as old;

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (compat != 'disabled') {
      return const old.ProfileScreen(disableAppBar: true);
    }
    return const Center(
      child: Text('Compat mode disabled and accounts not implemented'),
    );
  }
}
