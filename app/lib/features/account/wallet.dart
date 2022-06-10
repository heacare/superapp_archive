import 'package:flutter/foundation.dart' show ChangeNotifier;

// TODO(serverwentdown): Figure out how to replace the wallet implementation on-the-fly
abstract class Wallet extends ChangeNotifier {
  Future<void> connect();

  String? get walletConnectUri => null;
}
