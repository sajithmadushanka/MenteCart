import 'package:flutter/material.dart';

import 'app_colors.dart';

/// =====================================================
/// MenteCart Gradient System
/// =====================================================
///
/// Rules:
/// - Use gradients sparingly
/// - Keep gradients smooth and premium
/// - Avoid oversaturated combinations
/// - Maintain brand consistency
///
/// =====================================================

class AppGradients {
  AppGradients._();

  // =====================================================
  // PRIMARY BRAND GRADIENT
  // =====================================================

  static const LinearGradient primary = LinearGradient(
    colors: [AppColors.primary, AppColors.secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // =====================================================
  // PREMIUM ACCENT
  // =====================================================

  static const LinearGradient premium = LinearGradient(
    colors: [AppColors.accent, AppColors.secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // =====================================================
  // DARK SURFACE GRADIENT
  // =====================================================

  static const LinearGradient darkSurface = LinearGradient(
    colors: [Color(0xFF111827), Color(0xFF1E293B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // =====================================================
  // GLASS CARD GRADIENT
  // =====================================================

  static LinearGradient glass = LinearGradient(
    colors: [Colors.white.withValues(alpha:  0.10), Colors.white.withValues(alpha:  0.03)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // =====================================================
  // SUCCESS
  // =====================================================

  static const LinearGradient success = LinearGradient(
    colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // =====================================================
  // WARNING
  // =====================================================

  static const LinearGradient warning = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // =====================================================
  // ERROR
  // =====================================================

  static const LinearGradient error = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // =====================================================
  // AI GLOW GRADIENT
  // =====================================================

  static const RadialGradient aiGlow = RadialGradient(
    colors: [Color(0x334F46E5), Color(0x1106B6D4), Colors.transparent],
    radius: 1.2,
  );
}
