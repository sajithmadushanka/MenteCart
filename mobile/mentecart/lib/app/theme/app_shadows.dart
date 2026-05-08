import 'package:flutter/material.dart';

/// =====================================================
/// MenteCart Shadow System
/// =====================================================
///
/// Rules:
/// - Use soft ambient shadows
/// - Avoid harsh black shadows
/// - Keep depth subtle and premium
/// - Consistent elevation system
///
/// =====================================================

class AppShadows {
  AppShadows._();

  // =====================================================
  // LIGHT THEME SHADOWS
  // =====================================================

  static final List<BoxShadow> soft = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static final List<BoxShadow> medium = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 18,
      offset: const Offset(0, 8),
    ),
  ];

  static final List<BoxShadow> large = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 28,
      offset: const Offset(0, 12),
    ),
  ];

  // =====================================================
  // DARK THEME SHADOWS
  // =====================================================

  static final List<BoxShadow> darkSoft = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.25),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static final List<BoxShadow> darkMedium = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.35),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];

  static final List<BoxShadow> darkLarge = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.45),
      blurRadius: 32,
      offset: const Offset(0, 16),
    ),
  ];

  // =====================================================
  // GLOW EFFECTS
  // =====================================================

  static final List<BoxShadow> primaryGlow = [
    BoxShadow(
      color: const Color(0xFF4F46E5).withValues(alpha: 0.35),
      blurRadius: 24,
      spreadRadius: 1,
      offset: const Offset(0, 0),
    ),
  ];

  static final List<BoxShadow> cyanGlow = [
    BoxShadow(
      color: const Color(0xFF06B6D4).withValues(alpha: 0.30),
      blurRadius: 24,
      spreadRadius: 1,
      offset: const Offset(0, 0),
    ),
  ];

  // =====================================================
  // GLASSMORPHISM SHADOW
  // =====================================================

  static final List<BoxShadow> glass = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.10),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  // =====================================================
  // NEUMORPHISM STYLE
  // =====================================================

  static final List<BoxShadow> neuLight = [
    BoxShadow(
      color: Colors.white.withValues(alpha: 0.7),
      offset: const Offset(-4, -4),
      blurRadius: 10,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      offset: const Offset(4, 4),
      blurRadius: 10,
    ),
  ];

  static final List<BoxShadow> neuDark = [
    BoxShadow(
      color: Colors.white.withValues(alpha: 0.04),
      offset: const Offset(-3, -3),
      blurRadius: 8,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.40),
      offset: const Offset(4, 4),
      blurRadius: 12,
    ),
  ];
}
