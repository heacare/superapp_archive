import 'dart:async' show unawaited;

import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:uuid/uuid.dart' show Uuid;

import '../../features/database/database.dart' show Database, kvRead, kvWrite;
import '../../system/log.dart';
import 'metadata.dart' show AccountMetadata, AppAccountMetadata;
import 'wallet.dart' show Wallet;
import 'wallet_walletconnect.dart' show WalletConnectWallet;

const uuid = Uuid();

abstract class Account extends ChangeNotifier {
  // TODO(serverwentdown): Should the entire wallet be exposed to consumers?
  Wallet? get wallet;
  Future<void> setWallet(Wallet wallet);

  AccountMetadata get metadata;
}

class AppAccount extends Account {
  AppAccount._(this._database);

  final Database _database;

  static Future<Account> load(Database database) async {
    AppAccount account = AppAccount._(database);

    // Restore metadata
    await account._restoreMetadata();
    // If wallet exists, restore wallet
    unawaited(account._restoreWallet());

    return account;
  }

  late AccountMetadata _metadata;
  Future<void> _restoreMetadata() async {
    Map<String, dynamic>? metadata =
        await kvRead(_database, 'account.metadata');
    if (metadata == null) {
      _metadata = AppAccountMetadata(
        id: uuid.v4(),
      );
      await _saveMetadata();
    }
    _metadata = AppAccountMetadata.fromJson(metadata!)
      ..addListener(notifyListeners)
      ..addListener(_saveMetadata);
  }

  Future<void> _saveMetadata() async {
    logD('Account: Persisting metadata');
    await kvWrite(_database, 'account.metadata', metadata.toJson());
  }

  @override
  AccountMetadata get metadata => _metadata;

  Wallet? _wallet;
  Future<void> _restoreWallet() async {
    Map<String, dynamic>? wallet = await kvRead(_database, 'account.wallet');
    if (wallet == null) {
      return;
    }
    _wallet = WalletConnectWallet.fromJson(wallet);
    // TODO(serverwentdown): Make it clear when to call start()
    await _wallet!.start();
    _wallet!.addListener(notifyListeners);
    _wallet!.addListener(_saveWallet);
  }

  Future<void> _saveWallet() async {
    logD('Account: Persisting wallet');
    await kvWrite(_database, 'account.wallet', _wallet);
  }

  @override
  Wallet? get wallet => _wallet;
  @override
  Future<void> setWallet(Wallet wallet) async {
    if (_wallet != null) {
      _wallet!.dispose();
    }
    _wallet = wallet;
    await _saveWallet();
    _wallet!.addListener(notifyListeners);
    _wallet!.addListener(_saveWallet);
    notifyListeners();
  }
}
