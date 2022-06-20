import 'dart:async' show unawaited;

import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../../features/database/database.dart' show Database, kvRead, kvWrite;
import 'wallet.dart' show Wallet;
import 'wallet_walletconnect.dart' show WalletConnectWallet;

abstract class Account extends ChangeNotifier {
  String? get name;
  Future<void> setName(String name);

  // TODO(serverwentdown): Should the entire wallet be exposed to consumers?
  Wallet? get wallet;
  Future<void> setWallet(Wallet wallet);
}

class AppAccount extends Account {
  AppAccount._(this._database);

  final Database _database;
  Wallet? _wallet;

  static Future<Account> load(Database database) async {
    AppAccount account = AppAccount._(database);

    // If wallet exists, restore wallet
    unawaited(account._restoreWallet());

    return account;
  }

  Future<void> _restoreWallet() async {
    Map<String, dynamic>? wallet = await kvRead(_database, 'account.wallet');
    if (wallet == null) {
      return;
    }
    _wallet = WalletConnectWallet.fromJson(wallet);
    await _wallet!.start();
    _wallet!.addListener(notifyListeners);
  }

  @override
  Wallet? get wallet => _wallet;
  @override
  Future<void> setWallet(Wallet wallet) async {
    if (_wallet != null) {
      _wallet!.dispose();
    }
    _wallet = wallet;
    await kvWrite(_database, 'account.wallet', _wallet);
    _wallet!.addListener(notifyListeners);
    notifyListeners();
  }

  @override
  String? get name => 'TODO';
  @override
  Future<void> setName(String name) async {
    notifyListeners();
  }
}
