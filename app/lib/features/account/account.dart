import 'package:flutter/foundation.dart' show ChangeNotifier;

import 'wallet.dart' show Wallet;
import 'wallet_walletconnect.dart' show WalletConnectWallet;

abstract class Account extends ChangeNotifier {
  String? get name;
  Future<void> setName(String name);

  /// For now, expose the entire wallet object to the client
  Wallet? get wallet;
}

class AppAccount extends Account {
  AppAccount._(this._wallet);

  final Wallet _wallet;

  static Future<Account> load() async {
    AppAccount account = AppAccount._(WalletConnectWallet());
    account._wallet.addListener(() {
      account.notifyListeners();
    });
    return account;
  }

  @override
  String? get name => 'TODO';
  @override
  Future<void> setName(String name) async {}

  @override
  Wallet get wallet => _wallet;
}
