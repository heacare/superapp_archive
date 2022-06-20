import 'dart:async' show unawaited;

import 'package:flutter/material.dart';

import '../../widgets/qr_code.dart' show QrCodeDialog;
import 'wallet.dart' show Wallet;
import 'wallet_walletconnect.dart' show WalletConnectWallet;

class WalletConnect extends StatelessWidget {
  const WalletConnect({super.key, required this.wallet});

  final WalletConnectWallet wallet;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: wallet,
        builder: (context, child) {
          if (wallet.connected) {
            Navigator.of(context).pop(wallet);
          }
          if (!wallet.connectReady) {
            return const QrCodeDialog(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return QrCodeDialog(
            data: wallet.walletConnectUri,
            child: TextFormField(
              initialValue: wallet.walletConnectUri,
              readOnly: true,
            ),
          );
        },
      );
}

Future<Wallet?> showWalletConnectDialog(BuildContext context) async {
  var wallet = WalletConnectWallet.createSession();
  unawaited(
    () async {
      await Future.delayed(const Duration(milliseconds: 200));
      await wallet.start();
      await wallet.connect();
    }(),
  );
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('WalletConnect'),
      content: WalletConnect(wallet: wallet),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            wallet.dispose();
          },
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}
