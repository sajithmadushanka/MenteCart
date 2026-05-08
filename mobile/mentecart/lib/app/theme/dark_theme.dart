import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// =====================================================
/// MenteCart Dark Theme
/// =====================================================
///
/// Rules:
/// - Premium dark surfaces
/// - Strong readability
/// - Soft contrast
/// - Minimal harsh colors
/// - Modern AI/SaaS feel
///
/// =====================================================

class DarkTheme {
  DarkTheme._();

  static ThemeData theme = ThemeData(
    useMaterial3: true,
    fontFamily: AppTypography.fontFamily,
    brightness: Brightness.dark,

    // =====================================================
    // COLOR SCHEME
    // =====================================================
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.darkSurface,
      error: AppColors.error,
    ),

    // =====================================================
    // SCAFFOLD
    // =====================================================
    scaffoldBackgroundColor: AppColors.darkBackground,

    // =====================================================
    // APP BAR
    // =====================================================
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 0,
      foregroundColor: AppColors.darkTextPrimary,
      titleTextStyle: TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.darkTextPrimary,
      ),
    ),

    // =====================================================
    // CARD
    // =====================================================
    cardTheme: CardThemeData(
      color: AppColors.darkCard,
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
      fillColor: AppColors.darkSurface,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),

      hintStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.darkTextMuted,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: const BorderSide(color: AppColors.darkBorder),
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
        foregroundColor: AppColors.darkTextPrimary,

        minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),

        side: const BorderSide(color: AppColors.darkBorder),

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
        foregroundColor: AppColors.secondary,
        textStyle: AppTypography.titleMedium,
      ),
    ),

    // =====================================================
    // DIVIDER
    // =====================================================
    dividerTheme: const DividerThemeData(
      color: AppColors.darkBorder,
      thickness: 1,
      space: 1,
    ),

    // =====================================================
    // BOTTOM NAVIGATION
    // =====================================================
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      selectedItemColor: AppColors.secondary,
      unselectedItemColor: AppColors.darkTextMuted,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),

    // =====================================================
    // CHIP
    // =====================================================
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.darkSurface,
      selectedColor: AppColors.primary,
      disabledColor: AppColors.disabled,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      labelStyle: AppTypography.labelMedium.copyWith(
        color: AppColors.darkTextPrimary,
      ),
    ),

    // =====================================================
    // TEXT THEME
    // =====================================================
    textTheme: TextTheme(
      displayLarge: AppTypography.displayLarge.copyWith(
        color: AppColors.darkTextPrimary,
      ),

      displayMedium: AppTypography.displayMedium.copyWith(
        color: AppColors.darkTextPrimary,
      ),

      headlineLarge: AppTypography.headlineLarge.copyWith(
        color: AppColors.darkTextPrimary,
      ),

      headlineMedium: AppTypography.headlineMedium.copyWith(
        color: AppColors.darkTextPrimary,
      ),

      headlineSmall: AppTypography.headlineSmall.copyWith(
        color: AppColors.darkTextPrimary,
      ),

      bodyLarge: AppTypography.bodyLarge.copyWith(
        color: AppColors.darkTextSecondary,
      ),

      bodyMedium: AppTypography.bodyMedium.copyWith(
        color: AppColors.darkTextSecondary,
      ),

      bodySmall: AppTypography.bodySmall.copyWith(
        color: AppColors.darkTextMuted,
      ),
    ),
  );
}
