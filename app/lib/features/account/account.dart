import 'package:flutter/foundation.dart' show ChangeNotifier;

abstract class Account extends ChangeNotifier {
  String? get name;
  Future<void> setName(String name);
}
