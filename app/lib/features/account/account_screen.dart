import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;

import '../../main.dart' show compat;
import '../../old/screens/profile.dart' as old;
import '../../widgets/button.dart' show buttonStylePrimary;
import 'account.dart' show Account;
import 'wallet.dart' show Wallet;
import 'wallet_walletconnect_widget.dart' show showWalletConnectDialog;

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Account account = Provider.of<Account>(context);
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Text('Account: ${account.wallet?.account}'),
            Text('Connected: ${account.wallet?.connected}'),
            if (account.wallet?.connected ?? false)
              ElevatedButton(
                style: buttonStylePrimary(context),
                child: const Text('Disconnect'),
                onPressed: () async {
                  await account.wallet?.disconnect();
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      content: Text('Disconnected'),
                    ),
                  );
                },
              ),
            if (!(account.wallet?.connected ?? false))
              ElevatedButton(
                style: buttonStylePrimary(context),
                child: const Text('WalletConnect'),
                onPressed: () async {
                  Wallet? wallet = await showWalletConnectDialog(context);
                  if (wallet != null) {
                    await account.setWallet(wallet);
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Text('Connected'),
                      ),
                    );
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
