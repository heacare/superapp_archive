import 'package:flutter/material.dart';

import 'package:provider/provider.dart' show Provider;

import '../../main.dart';
import '../../old/screens/profile.dart' as old;
import 'account.dart' show Account;
import 'wallet_walletconnect_widget.dart' show showWalletConnectDialog;

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Account account = Provider.of<Account>(context);
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: const Text('WalletConnect'),
              onPressed: () async {
                await account.wallet!.connect();
                await showWalletConnectDialog(context);
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
