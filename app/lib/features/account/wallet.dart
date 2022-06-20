import 'package:flutter/foundation.dart' show ChangeNotifier;

// TODO(serverwentdown): Figure out how to replace the wallet implementation on-the-fly
abstract class Wallet extends ChangeNotifier {
  Future<void> connect();

  /// Wallet is connected when an account is ready to be used
  bool get connected => account != null;

  /// Selected wallet address
  String? get account;

  String? get walletConnectUri => null;
}
