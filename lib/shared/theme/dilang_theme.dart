import 'package:flutter/material.dart';
import 'color_tokens.dart';
import 'semantic_colors.dart';

class DiLangTheme {
  static SemanticColors darkSemanticColors = const SemanticColors(
    surfacePrimary: ColorTokens.slate950,
    surfaceSecondary: ColorTokens.slate800,
    surfaceTertiary: ColorTokens.slate700,
    textPrimary: ColorTokens.white,
    textSecondary: ColorTokens.slate400,
    textMuted: ColorTokens.slate500,
    accentPrimary: ColorTokens.azure500,
    accentSecondary: ColorTokens.cyan400,
    accentSuccess: ColorTokens.emerald500,
    accentWarning: ColorTokens.amber500,
    accentError: ColorTokens.coralRed500,
    borderSubtle: ColorTokens.slate700,
    borderStrong: ColorTokens.slate600,
    interactiveNormal: ColorTokens.azure500,
    interactiveHover: ColorTokens.azure400,
    interactivePressed: ColorTokens.azure600,
    interactiveDisabled: ColorTokens.slate600,
  );

  static SemanticColors lightSemanticColors = const SemanticColors(
    surfacePrimary: ColorTokens.white,
    surfaceSecondary: ColorTokens.gray100,
    surfaceTertiary: ColorTokens.gray200,
    textPrimary: ColorTokens.gray900,
    textSecondary: ColorTokens.gray700,
    textMuted: ColorTokens.slate500,
    accentPrimary: ColorTokens.azure600,
    accentSecondary: ColorTokens.cyan500,
    accentSuccess: ColorTokens.emerald500,
    accentWarning: ColorTokens.amber500,
    accentError: ColorTokens.coralRed500,
    borderSubtle: ColorTokens.gray300,
    borderStrong: ColorTokens.gray700,
    interactiveNormal: ColorTokens.azure600,
    interactiveHover: ColorTokens.azure500,
    interactivePressed: ColorTokens.azure600,
    interactiveDisabled: ColorTokens.gray300,
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: ColorTokens.slate950,
    primaryColor: ColorTokens.azure500,
    extensions: [darkSemanticColors],
  );

  static ThemeData lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: ColorTokens.white,
    primaryColor: ColorTokens.azure600,
    extensions: [lightSemanticColors],
  );

  static SemanticColors of(BuildContext context) {
    return Theme.of(context).extension<SemanticColors>() ?? darkSemanticColors;
  }

  const DiLangTheme._();
}
