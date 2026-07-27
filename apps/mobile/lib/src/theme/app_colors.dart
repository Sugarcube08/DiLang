import 'package:flutter/material.dart';

/// DiLang Design System 2.0 Color Palette
/// "Liquid Glass" Aesthetic • Playful • Intelligent • Premium
abstract class AppColors {
  // Brand Primary - Turquoise & Aqua
  static const Color turquoise50 = Color(0xFFEDFCF9);
  static const Color turquoise100 = Color(0xFFC5F8F0);
  static const Color turquoise200 = Color(0xFF8EF2E2);
  static const Color turquoise300 = Color(0xFF4DE7D2);
  static const Color turquoise400 = Color(0xFF1DD3BE);
  static const Color turquoise500 = Color(0xFF00C4B4); // Primary Brand
  static const Color turquoise600 = Color(0xFF009C91);
  static const Color turquoise700 = Color(0xFF007A73);
  static const Color turquoise800 = Color(0xFF04605C);
  static const Color turquoise900 = Color(0xFF0A4F4C);

  // Secondary - Mint & Sky
  static const Color mint50 = Color(0xFFECFDF5);
  static const Color mint400 = Color(0xFF34D399);
  static const Color mint500 = Color(0xFF10B981); // Secondary Accent
  static const Color sky400 = Color(0xFF38BDF8);
  static const Color sky500 = Color(0xFF0284C7);

  // Accents - Amber, Coral & Lavender
  static const Color amber400 = Color(0xFFFBBF24);
  static const Color amber500 = Color(0xFFF59E0B); // Streak / XP Accent
  static const Color coral400 = Color(0xFFFB7185);
  static const Color coral500 = Color(0xFFF43F5E); // Alert Accent
  static const Color lavender400 = Color(0xFFC084FC);
  static const Color lavender500 = Color(0xFFA855F7); // AI Tutor Accent

  // Toucan Mascot Palette
  static const Color toucanBody = Color(0xFF00C4B4);
  static const Color toucanWing = Color(0xFF0D9488);
  static const Color toucanBelly = Color(0xFFE0F2FE);
  static const Color toucanBeak = Color(0xFFF59E0B);
  static const Color toucanCheek = Color(0xFFF43F5E);
  static const Color toucanCrown = Color(0xFFFACC15);

  // Light Mode Surfaces & Neutrals
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightGlassSurface = Color.fromRGBO(255, 255, 255, 0.72);
  static const Color lightGlassBorder = Color.fromRGBO(255, 255, 255, 0.85);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Dark Mode Surfaces & Neutrals
  static const Color darkBackground = Color(0xFF070B12);
  static const Color darkSurface = Color(0xFF0F172A);
  static const Color darkGlassSurface = Color.fromRGBO(15, 23, 42, 0.65);
  static const Color darkGlassBorder = Color.fromRGBO(255, 255, 255, 0.12);
  static const Color darkBorder = Color(0xFF1E293B);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  // Compatibility Aliases
  static const Color primary = turquoise500;
  static const Color secondary = mint500;
  static const Color accent = mint500;
  static const Color success = mint500;
  static const Color warning = amber500;
  static const Color error = coral500;
  static const Color info = sky500;

  static const Color lightContainer = lightSurface;
  static const Color lightDivider = lightBorder;
  static const Color lightGlassFill = lightGlassSurface;
  static const Color userBubbleLight = turquoise50;
  static const Color aiBubbleLight = lightSurface;

  static const Color darkContainer = darkSurface;
  static const Color darkDivider = darkBorder;
  static const Color darkGlassFill = darkGlassSurface;
  static const Color userBubbleDark = turquoise900;
  static const Color aiBubbleDark = darkSurface;

  static const Color vocabKnown = mint500;
  static const Color vocabWeak = amber500;
  static const Color grammarWeak = coral500;
  static const Color grammarStrong = turquoise500;
}
