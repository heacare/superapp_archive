import 'package:flutter/widgets.dart' show WidgetsBinding;
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter/services.dart' show SystemUiOverlayStyle, Brightness;
import 'package:flutter/foundation.dart' show ChangeNotifier;

import 'theme.dart' show HEAThemeData;

class DisplayOptions extends ChangeNotifier {
  DisplayOptions({
    ThemeMode themeMode = ThemeMode.system,
  }) : _themeMode = themeMode;

  ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  Future<void> load() async {}

  SystemUiOverlayStyle resolveOverlayStyle() {
    Brightness brightness;
    switch (themeMode) {
      case ThemeMode.light:
        brightness = Brightness.light;
        break;
      case ThemeMode.dark:
        brightness = Brightness.dark;
        break;
      default:
        brightness = WidgetsBinding.instance.window.platformBrightness;
    }

    return brightness == Brightness.light
        ? HEAThemeData.lightSystemUiOverlayStyle
        : HEAThemeData.darkSystemUiOverlayStyle;
  }
}
