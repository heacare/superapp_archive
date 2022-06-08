import 'package:flutter/material.dart'
    show ThemeData, ColorScheme, Color, Brightness, ThemeMode;
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter/widgets.dart' show WidgetsBinding;

class Theme {
  static final ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFFFF9900),
    primary: const Color(0xFFFF9900),
    secondary: const Color(0xFFFF00FF),
  );
  static final ColorScheme darkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color(0xFFFF9900),
    primary: const Color(0xFFFF9900),
    secondary: const Color(0xFFFF00FF),
  );

  static final ThemeData lightThemeData = _themeData(lightColorScheme);
  static final ThemeData darkThemeData = _themeData(darkColorScheme);

  static final SystemUiOverlayStyle lightSystemUiOverlayStyle =
      SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: const Color(0x00FFFFFF),
  );
  static final SystemUiOverlayStyle darkSystemUiOverlayStyle =
      SystemUiOverlayStyle.light.copyWith(
    statusBarColor: const Color(0x00000000),
  );

  static ThemeData _themeData(ColorScheme colorScheme) => ThemeData.from(
        colorScheme: colorScheme,
        useMaterial3: true,
      );

  static SystemUiOverlayStyle resolveOverlayStyle(ThemeMode themeMode) {
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
        ? lightSystemUiOverlayStyle
        : darkSystemUiOverlayStyle;
  }
}
