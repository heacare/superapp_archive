import 'dart:async' show unawaited;
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
		    Text('Connected: ${account.wallet?.connected}'),
		    Text('Account: ${account.wallet?.account}'),
            ElevatedButton(
              child: const Text('WalletConnect'),
              onPressed: () async {
                unawaited(
                  () async {
                    await Future.delayed(const Duration(milliseconds: 100));
                    await account.wallet!.connect();
                  }(),
                );
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
