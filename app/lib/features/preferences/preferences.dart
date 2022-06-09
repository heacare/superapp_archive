import 'dart:ui' show Locale;

import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:flutter/material.dart' show ThemeMode;
import 'package:intl/locale.dart' as intl show Locale;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

// When we're ready, we can extend Preferences to include cloud syncing of
// these preferences using platform-specific features. See
// https://developer.apple.com/documentation/foundation/nsubiquitouskeyvaluestore
// https://developer.android.com/training/sync-adapters/

abstract class Preferences extends ChangeNotifier {
  ThemeMode get themeMode;
  Future<void> setThemeMode(ThemeMode themeMode);

  bool get forceRTL;
  Future<void> setForceRTL(bool rtl);

  Locale? get locale;
  Future<void> setLocale(Locale? locale);

  bool get consentTelemetryInterim;
  Future<void> setConsentTelemetryInterim(bool consent);
}

class AppPreferences extends Preferences {
  AppPreferences._(this._instance);

  final SharedPreferences _instance;

  static Future<Preferences> load() async {
    AppPreferences preferences =
        AppPreferences._(await SharedPreferences.getInstance());
    // PlatformDispatcher.instance.onLocaleChanged = preferences.onLocaleChanged;
    return preferences;
  }

  @override
  ThemeMode get themeMode {
    String? themeMode = _getString('themeMode');
    return ThemeMode.values
        .firstWhere((m) => m.name == themeMode, orElse: () => ThemeMode.system);
  }

  @override
  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _setString('themeMode', themeMode.name);
  }

  @override
  bool get forceRTL => _getBool('forceRTL') ?? false;

  @override
  Future<void> setForceRTL(bool rtl) async {
    await _setBool('forceRTL', rtl);
  }

  @override
  Locale? get locale {
    String? locale = _getString('locale');
    if (locale == null) {
      return null;
    }
    intl.Locale parsed = intl.Locale.parse(locale);
    return Locale.fromSubtags(
      languageCode: parsed.languageCode,
      scriptCode: parsed.scriptCode,
      countryCode: parsed.countryCode,
    );
  }

  @override
  Future<void> setLocale(Locale? locale) async {
    if (locale == null) {
      await _remove('locale');
      return;
    }
    await _setString('locale', locale.toLanguageTag());
  }

  @override
  bool get consentTelemetryInterim =>
      _getBool('consentTelemetryInterim') ?? false;

  @override
  Future<void> setConsentTelemetryInterim(bool consent) async {
    await _setBool('consentTelemetryInterim', consent);
  }

  Future<void> _remove(String key) async {
    await _instance.remove(key);
    notifyListeners();
  }

  Future<void> _setString(String key, String value) async {
    await _instance.setString(key, value);
    notifyListeners();
  }

  String? _getString(String key) => _instance.getString(key);

  Future<void> _setInt(String key, int value) async {
    await _instance.setInt(key, value);
    notifyListeners();
  }

  int? _getInt(String key) => _instance.getInt(key);

  Future<void> _setBool(String key, bool value) async {
    await _instance.setBool(key, value);
    notifyListeners();
  }

  bool? _getBool(String key) => _instance.getBool(key);
}