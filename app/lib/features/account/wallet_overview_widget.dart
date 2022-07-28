import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;

import '../../widgets/button.dart' show buttonStylePrimary;
import '../../widgets/svg_logo.dart' show SvgLogo;
import 'account.dart' show Account;
import 'wallet.dart' show Wallet;
import 'wallet_walletconnect_widget.dart' show showWalletConnectDialog;

class WalletOverview extends StatelessWidget {
  const WalletOverview({super.key});

  @override
  Widget build(final BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final Account account = Provider.of<Account>(context);
    final ScaffoldMessengerState scaffoldMessenger =
        ScaffoldMessenger.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Experimental',
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          if (account.wallet?.connected ?? false)
            Text('Wallet address: ${account.wallet?.account}'),
          if (!(account.wallet?.connected ?? false))
            const Text('Wallet not connected'),
          const SizedBox(height: 8),
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
                color: colorScheme.onPrimary,
              ),
              onPressed: () async {
                final Wallet? wallet = await showWalletConnectDialog(context);
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
        ],
      ),
    );
  }
}
