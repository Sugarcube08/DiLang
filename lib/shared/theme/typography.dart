import 'package:flutter/material.dart';
import 'color_tokens.dart';

class TypographyTokens {
  static const TextStyle headingLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: ColorTokens.textPrimary,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: ColorTokens.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 15,
    color: ColorTokens.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 13,
    color: ColorTokens.textSecondary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.1,
    color: ColorTokens.textMuted,
  );

  const TypographyTokens._();
}
