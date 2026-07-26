import 'package:flutter/material.dart';

/// DiLang Color Palette Specifications
abstract class AppColors {
  // --- Brand Colors ---
  static const Color primary = Color(0xFF5E5CE6); // Indigo
  static const Color secondary = Color(0xFF3B82F6); // Blue
  static const Color accent = Color(0xFF10B981); // Emerald (Success/Mastery)
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color error = Color(0xFFEF4444); // Red
  static const Color info = Color(0xFF06B6D4); // Cyan

  // --- Light Theme Colors ---
  static const Color lightBackground = Color(0xFFF7F8FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightGlassFill = Color.fromRGBO(255, 255, 255, 0.55);
  static const Color lightTextPrimary = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightDivider = Color(0xFFE5E7EB);
  static const Color lightBorder = Color.fromRGBO(0, 0, 0, 0.08);

  // --- Dark Theme Colors ---
  static const Color darkBackground = Color(0xFF0E1014);
  static const Color darkSurface = Color(0xFF171A21);
  static const Color darkGlassFill = Color.fromRGBO(24, 28, 35, 0.55);
  static const Color darkTextPrimary = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFFA1A1AA);
  static const Color darkDivider = Color(0xFF2A2F3A);
  static const Color darkBorder = Color.fromRGBO(255, 255, 255, 0.12);
}
