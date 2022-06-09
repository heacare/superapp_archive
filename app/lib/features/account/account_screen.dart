import 'package:flutter/material.dart';

import 'package:provider/provider.dart' show Provider;

import '../../main.dart';
import '../../old/screens/profile.dart' as old;
import '../../system/log.dart';
import 'wallet.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Wallet wallet = Provider.of<Wallet>(context);
    logD('rebuild');
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            TextFormField(
              initialValue: wallet.walletConnectUri ?? 'No URI',
              readOnly: true,
            ),
            ElevatedButton(
              child: const Text('Connect'),
              onPressed: () async {
                await wallet.connect();
              },
            ),
            if (compat != 'disabled') const SizedBox(height: 64),
            if (compat != 'disabled')
              const old.ProfileScreen(disableScaffold: true),
          ],
        ),
      ),
    );
  }
}
