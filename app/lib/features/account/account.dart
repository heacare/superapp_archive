import 'package:flutter/foundation.dart' show ChangeNotifier;

abstract class Account extends ChangeNotifier {
  String? get name;
  Future<void> setName(String name);
}

class AppAccount extends Account {
  @override
  String? get name => 'TODO';
  @override
  Future<void> setName(String name) async {}
}
