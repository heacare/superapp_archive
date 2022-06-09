import 'package:flutter/foundation.dart' show ChangeNotifier;

import 'package:wallet_connect/wallet_connect.dart'
    show WCSession, WCPeerMeta, WCClient;

import '../../system/log.dart';

// TODO(serverwentdown): Figure out how to replace the wallet implementation on-the-fly
abstract class Wallet extends ChangeNotifier {
  Future<void> connect();

  String? get walletConnectUri => null;
}

class WalletConnectWallet extends Wallet {
  WalletConnectWallet._();

  static final WCPeerMeta _peerMeta = WCPeerMeta(
    name: 'Happily Ever After',
    url: 'https://hea.care',
    description: 'Test integration with WalletConnect',
    icons: ['https://hea.care/images/logo.png'],
  );
  WCSession? _session;
  WCClient? _client;

  static Future<Wallet> load() async => WalletConnectWallet._();

  void _connect() {
    logD('connecting to socket');
    String stringKey =
        '37e67e3b2cf4c6a292d6d6ec7fbeaa7fe4bab940e1960961338257d6fce68aac';
    _session = WCSession(
      topic: 'Cake is a lie',
      version: '1',
      bridge: 'https://bridge.walletconnect.org',
      key: stringKey,
    );
    _client = WCClient(
      onFailure: (error) {
        logW('failed to connect to socket: $error');
      },
      onConnect: () {
        logD('connected to socket');
      },
    )..connectNewSession(session: _session!, peerMeta: _peerMeta);
  }

  @override
  Future<void> connect() async {
    _connect();
    notifyListeners();
  }

  @override
  String? get walletConnectUri => _session?.toUri();
}
