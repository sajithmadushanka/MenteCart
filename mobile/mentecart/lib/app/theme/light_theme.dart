import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// =====================================================
/// MenteCart Light Theme
/// =====================================================
///
/// Rules:
/// - Clean SaaS aesthetic
/// - Soft surfaces
/// - Minimal elevation
/// - Strong readability
/// - Consistent component styling
///
/// =====================================================

class LightTheme {
  LightTheme._();

  static ThemeData theme = ThemeData(
    useMaterial3: true,
    fontFamily: AppTypography.fontFamily,
    brightness: Brightness.light,

    // =====================================================
    // COLOR SCHEME
    // =====================================================
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.lightSurface,
      error: AppColors.error,
    ),

    // =====================================================
    // SCAFFOLD
    // =====================================================
    scaffoldBackgroundColor: AppColors.lightBackground,

    // =====================================================
    // APP BAR
    // =====================================================
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 0,
      foregroundColor: AppColors.lightTextPrimary,
      titleTextStyle: TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.lightTextPrimary,
      ),
    ),

    // =====================================================
    // CARD
    // =====================================================
    cardTheme: CardThemeData(
      color: AppColors.lightCard,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
    ),

    // =====================================================
    // INPUT DECORATION
    // =====================================================
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurface,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),

      hintStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.lightTextMuted,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: const BorderSide(color: AppColors.lightBorder),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: const BorderSide(color: AppColors.lightBorder),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    ),

    // =====================================================
    // ELEVATED BUTTON
    // =====================================================
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,

        minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),

        textStyle: AppTypography.titleMedium.copyWith(color: Colors.white),
      ),
    ),

    // =====================================================
    // OUTLINED BUTTON
    // =====================================================
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.lightTextPrimary,

        minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),

        side: const BorderSide(color: AppColors.lightBorder),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),

        textStyle: AppTypography.titleMedium,
      ),
    ),

    // =====================================================
    // TEXT BUTTON
    // =====================================================
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTypography.titleMedium,
      ),
    ),

    // =====================================================
    // DIVIDER
    // =====================================================
    dividerTheme: const DividerThemeData(
      color: AppColors.lightBorder,
      thickness: 1,
      space: 1,
    ),

    // =====================================================
    // BOTTOM NAVIGATION
    // =====================================================
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightSurface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.lightTextMuted,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),

    // =====================================================
    // CHIP
    // =====================================================
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.lightSurface,
      selectedColor: AppColors.primary,
      disabledColor: AppColors.disabled,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      labelStyle: AppTypography.labelMedium,
    ),

    // =====================================================
    // TEXT THEME
    // =====================================================
    textTheme: TextTheme(
      displayLarge: AppTypography.displayLarge.copyWith(
        color: AppColors.lightTextPrimary,
      ),

      displayMedium: AppTypography.displayMedium.copyWith(
        color: AppColors.lightTextPrimary,
      ),

      headlineLarge: AppTypography.headlineLarge.copyWith(
        color: AppColors.lightTextPrimary,
      ),

      headlineMedium: AppTypography.headlineMedium.copyWith(
        color: AppColors.lightTextPrimary,
      ),

      headlineSmall: AppTypography.headlineSmall.copyWith(
        color: AppColors.lightTextPrimary,
      ),

      bodyLarge: AppTypography.bodyLarge.copyWith(
        color: AppColors.lightTextSecondary,
      ),

      bodyMedium: AppTypography.bodyMedium.copyWith(
        color: AppColors.lightTextSecondary,
      ),

      bodySmall: AppTypography.bodySmall.copyWith(
        color: AppColors.lightTextMuted,
      ),
    ),
  );
}
