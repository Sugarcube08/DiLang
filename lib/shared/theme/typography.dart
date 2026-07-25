import 'package:flutter/material.dart';
import 'color_tokens.dart';

class TypographyTokens {
  static const TextStyle headingLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: ColorTokens.white,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: ColorTokens.white,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 15,
    color: ColorTokens.white,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 13,
    color: ColorTokens.slate400,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.1,
    color: ColorTokens.slate500,
  );

  const TypographyTokens._();
}
