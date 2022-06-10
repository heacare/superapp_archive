import 'package:flutter/material.dart';

import 'package:provider/provider.dart' show Provider;

import '../../widgets/qr_code.dart' show QrCodeDialog;
import 'account.dart' show Account;

class WalletConnect extends StatelessWidget {
  const WalletConnect({super.key});

  @override
  Widget build(BuildContext context) {
    Account account = Provider.of<Account>(context);
    return QrCodeDialog(
      data: account.wallet?.walletConnectUri,
      child: TextFormField(
        key: Key(account.wallet?.walletConnectUri ?? ''),
        initialValue: account.wallet?.walletConnectUri ?? '',
        readOnly: true,
      ),
    );
  }
}

Future<void> showWalletConnectDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('WalletConnect'),
      content: const WalletConnect(),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}
