import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;

import '../../main.dart' show compat;
import '../../navigator.dart' show ForceRTL;
import '../../old/screens/profile.dart' as old;
import '../../widgets/button.dart' show buttonStylePrimary;
import '../../widgets/screen.dart' show Screen;
import '../../widgets/svg_logo.dart' show SvgLogo;
import 'account.dart' show Account;
import 'edit_screen.dart' show EditPage;
import 'wallet.dart' show Wallet;
import 'wallet_walletconnect_widget.dart' show showWalletConnectDialog;

Route _editRouteBuilder(context, arguments) => MaterialPageRoute(
      builder: (context) => const ForceRTL(EditPage()),
    );

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Account account = Provider.of<Account>(context);
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    return Screen(
      children: [
        Text('Account: ${account.metadata.id}'),
        Text('Name: ${account.metadata.name}'),
        ElevatedButton(
          style: buttonStylePrimary(context),
          child: const Text('Edit profile'),
          onPressed: () async {
            // TODO(serverwentdown): Consider using a dialog on larger screens
            Navigator.of(context).restorablePush(_editRouteBuilder);
          },
        ),
        Text('Wallet: ${account.wallet?.account}'),
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
            child: SvgLogo(
              assetName: 'assets/integrations/walletconnect-banner.svg',
              placeholder: 'WalletConnect',
              height: 20,
              aspectRatio: 1459 / 238,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
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
    );
  }
}
