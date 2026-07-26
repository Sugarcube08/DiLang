import 'package:flutter/material.dart';

/// DiLang Raw Color Palette Definitions.
/// Note: UI screens must NOT reference raw hex/AppColors directly.
/// Use `context.colors` semantic extension instead.
abstract class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF5E5CE6); // Indigo
  static const Color secondary = Color(0xFF3B82F6); // Blue
  static const Color accent = Color(0xFF10B981); // Emerald (Success/Mastery)
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color error = Color(0xFFEF4444); // Red
  static const Color info = Color(0xFF06B6D4); // Cyan

  // Light Theme Raw Palette
  static const Color lightBackground = Color(0xFFF7F8FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightGlassFill = Color.fromRGBO(255, 255, 255, 0.55);
  static const Color lightContainer = Color(0xFFEDF0F5);
  static const Color lightTextPrimary = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightDivider = Color(0xFFE5E7EB);
  static const Color lightBorder = Color.fromRGBO(0, 0, 0, 0.08);

  // Dark Theme Raw Palette
  static const Color darkBackground = Color(0xFF0E1014);
  static const Color darkSurface = Color(0xFF171A21);
  static const Color darkGlassFill = Color.fromRGBO(24, 28, 35, 0.55);
  static const Color darkContainer = Color(0xFF222631);
  static const Color darkTextPrimary = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFFA1A1AA);
  static const Color darkDivider = Color(0xFF2A2F3A);
  static const Color darkBorder = Color.fromRGBO(255, 255, 255, 0.12);

  // Domain Specific Semantic Colors (Conversation & Pedagogical Tree)
  static const Color userBubbleDark = Color(0xFF1E2640);
  static const Color userBubbleLight = Color(0xFFE0E7FF);
  static const Color aiBubbleDark = Color(0xFF182333);
  static const Color aiBubbleLight = Color(0xFFECFEFF);

  static const Color vocabKnown = Color(0xFF10B981);
  static const Color vocabWeak = Color(0xFFF59E0B);
  static const Color grammarWeak = Color(0xFFEF4444);
  static const Color grammarStrong = Color(0xFF3B82F6);
}
