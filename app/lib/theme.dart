import 'package:flutter/material.dart'
    show ThemeData, ColorScheme, Color, Brightness;
import 'package:flutter/services.dart' show SystemUiOverlayStyle;

class HEAThemeData {
  static final ColorScheme lightColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.light,
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

  static ThemeData _themeData(ColorScheme colorScheme) {
    return ThemeData.from(
      colorScheme: colorScheme,
      useMaterial3: true,
    );
  }
}
