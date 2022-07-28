import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../account/account.dart' show Account;
import '../preferences/preferences.dart' show Preferences;

abstract class Onboarding extends ChangeNotifier {
  /// Determines if the onboarding screen should be shown
  bool get showOnboarding;
}

class AppOnboarding extends Onboarding {
  AppOnboarding._(this._preferences, this._account);

  final Preferences _preferences;
  final Account _account;

  static Future<Onboarding> load(
    final Preferences preferences,
    final Account account,
  ) async =>
      AppOnboarding._(preferences, account);

  @override
  bool get showOnboarding => false;
}

enum OnboardingState {
  complete,
}
