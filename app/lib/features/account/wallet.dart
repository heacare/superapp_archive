import 'package:flutter/foundation.dart' show ChangeNotifier;

// TODO(serverwentdown): Figure out how to replace the wallet implementation on-the-fly
abstract class Wallet extends ChangeNotifier {
  Future<void> connect();
  bool get connected => account != null;
  String? get account;

  String? get walletConnectUri => null;
}
