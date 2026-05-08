import 'package:flutter/material.dart';

/// =====================================================
/// MenteCart Color System
/// =====================================================
///
/// Rules:
/// - Never hardcode colors inside widgets
/// - Always use semantic naming
/// - Keep scalable for dark/light themes
/// - Centralize all design tokens
///
/// =====================================================

class AppColors {
  AppColors._();

  // =====================================================
  // BRAND COLORS
  // =====================================================

  static const Color primary = Color(0xFF4F46E5); // Indigo
  static const Color secondary = Color(0xFF06B6D4); // Cyan
  static const Color accent = Color(0xFF8B5CF6); // Purple

  // =====================================================
  // DARK THEME
  // =====================================================

  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF111827);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF334155);

  // =====================================================
  // LIGHT THEME
  // =====================================================

  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // =====================================================
  // TEXT COLORS — DARK MODE
  // =====================================================

  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
  static const Color darkTextMuted = Color(0xFF94A3B8);

  // =====================================================
  // TEXT COLORS — LIGHT MODE
  // =====================================================

  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF64748B);

  // =====================================================
  // STATUS COLORS
  // =====================================================

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // =====================================================
  // GRADIENTS
  // =====================================================

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // =====================================================
  // GLASSMORPHISM COLORS
  // =====================================================

  static Color glassWhite = Colors.white.withValues(alpha: 0.08);
  static Color glassBorder = Colors.white.withValues(alpha: 0.12);

  // =====================================================
  // OVERLAY COLORS
  // =====================================================

  static const Color overlayDark = Color(0x66000000);
  static const Color overlayLight = Color(0x33FFFFFF);

  // =====================================================
  // DISABLED COLORS
  // =====================================================

  static const Color disabled = Color(0xFF94A3B8);

  // =====================================================
  // SHIMMER COLORS
  // =====================================================

  static const Color shimmerBase = Color(0xFF1E293B);
  static const Color shimmerHighlight = Color(0xFF334155);
}
