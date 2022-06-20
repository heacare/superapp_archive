import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;

import '../../main.dart';
import '../../old/screens/profile.dart' as old;
import 'account.dart' show Account;
import 'wallet.dart' show Wallet;
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
            Text('Account: ${account.wallet?.account}'),
            Text('Connected: ${account.wallet?.connected}'),
            ElevatedButton(
              child: const Text('WalletConnect'),
              onPressed: () async {
                Wallet? wallet = await showWalletConnectDialog(context);
                if (wallet != null) {
                  await account.setWallet(wallet);
                }
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
