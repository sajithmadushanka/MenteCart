import 'package:flutter/material.dart';

import 'dark_theme.dart';
import 'light_theme.dart';

/// =====================================================
/// MenteCart App Theme
/// =====================================================
///
/// Central theme entry point.
///
/// Usage:
///
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
///   themeMode: ThemeMode.system,
/// )
///
/// =====================================================

class AppTheme {
  AppTheme._();

  static ThemeData get light => LightTheme.theme;

  static ThemeData get dark => DarkTheme.theme;
}
