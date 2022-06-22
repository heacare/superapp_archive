import 'dart:async' show unawaited;

import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:uuid/uuid.dart' show Uuid;

import '../../features/database/database.dart' show Database, kvRead, kvWrite;
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
  AppAccount._(this._database, {required this.metadata});

  final Database _database;

  static Future<Account> load(Database database) async {
    AppAccount account = AppAccount._(
      database,
      metadata: await _loadMetadata(database),
    );

    // Listen for events
    account.metadata.addListener(() async {
      await account._saveMetadata();
    });

    // If wallet exists, restore wallet
    unawaited(account._restoreWallet());

    return account;
  }

  @override
  final AccountMetadata metadata;
  static Future<AccountMetadata> _loadMetadata(Database database) async {
    Map<String, dynamic>? metadata = await kvRead(database, 'account.metadata');
    if (metadata == null) {
      AccountMetadata metadata = AppAccountMetadata(
        id: uuid.v4(),
      );
      await kvWrite(database, 'account.metadata', metadata.toJson());
      return metadata;
    }
    return AppAccountMetadata.fromJson(metadata);
  }

  Future<void> _saveMetadata() async {
    await kvWrite(_database, 'account.metadata', metadata.toJson());
  }

  Wallet? _wallet;
  Future<void> _restoreWallet() async {
    Map<String, dynamic>? wallet = await kvRead(_database, 'account.wallet');
    if (wallet == null) {
      return;
    }
    _wallet = WalletConnectWallet.fromJson(wallet);
    await _wallet!.start();
    _wallet!.addListener(notifyListeners);
    _wallet!.addListener(() async {
      await kvWrite(_database, 'account.wallet', _wallet);
    });
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
    _wallet!.addListener(() async {
      await kvWrite(_database, 'account.wallet', _wallet);
    });
    notifyListeners();
  }
}
