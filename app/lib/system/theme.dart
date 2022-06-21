import 'package:flutter/material.dart'
    show
        ThemeData,
        ColorScheme,
        Color,
        Colors,
        Brightness,
        ThemeMode,
        SnackBarBehavior;
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter/widgets.dart' show WidgetsBinding;

class Theme {
  static final ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFFFF9900),
    primary: const Color(0xFFFF9900),
    onPrimary: const Color(0xFFFFFFFF),
    inversePrimary: const Color(0xFF7F4C00),
    secondary: const Color(0xFFFF00FF),
    onSecondary: const Color(0xFFFFFFFF),
    background: const Color(0xFFFFFFFF),
    onBackground: const Color(0xFF434343),
    surface: const Color(0xFFFFFFFF),
    onSurface: const Color(0xFF434343),
  );
  static final ColorScheme darkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color(0xFFFF9900),
    primary: const Color(0xFFFF9900),
    onPrimary: const Color(0xFFFFFFFF),
    inversePrimary: const Color(0xFF7F4C00),
    secondary: const Color(0xFFFF00FF),
    onSecondary: const Color(0xFFFFFFFF),
    background: const Color(0xFF060606),
    onBackground: const Color(0xFFEEEEEE),
    surface: const Color(0xFF060606),
    onSurface: const Color(0xFFEEEEEE),
  );

  static final ThemeData lightThemeData = _themeData(lightColorScheme);
  static final ThemeData darkThemeData = _themeData(darkColorScheme);

  static final SystemUiOverlayStyle lightSystemUiOverlayStyle =
      SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarContrastEnforced: false,
  );
  static final SystemUiOverlayStyle darkSystemUiOverlayStyle =
      SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarContrastEnforced: false,
  );

  static const ShapeBorder bottomSheetShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  );

  static ThemeData _themeData(ColorScheme colorScheme) {
    ThemeData themeData = ThemeData.from(
      colorScheme: colorScheme,
      useMaterial3: true,
    );
    return themeData.copyWith(
      toggleableActiveColor: colorScheme.primary,
      snackBarTheme: themeData.snackBarTheme.copyWith(
        actionTextColor: colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
      bottomSheetTheme: themeData.bottomSheetTheme.copyWith(
        shape: bottomSheetShape,
      ),
    );
  }

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
