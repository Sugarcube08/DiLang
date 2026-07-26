import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'design_tokens.dart';
import 'theme_extensions.dart';

/// Dark Theme Data definition adhering to Apple HI + Linear + Nothing OS simplicity.
ThemeData getDarkThemeData() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.darkSurface,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.darkTextPrimary,
      onError: Colors.white,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.darkDivider,
      thickness: DesignTokens.borderWidthThin,
      space: 1,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.darkTextPrimary,
      ),
      iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
    ),
    textTheme: const TextTheme(
      displayLarge: AppTypography.displayLarge,
      displayMedium: AppTypography.displayMedium,
      titleLarge: AppTypography.titleLarge,
      titleMedium: AppTypography.titleMedium,
      bodyLarge: AppTypography.bodyLarge,
      bodyMedium: AppTypography.bodyMedium,
      labelMedium: AppTypography.labelMedium,
      labelSmall: AppTypography.labelSmall,
    ).apply(
      bodyColor: AppColors.darkTextPrimary,
      displayColor: AppColors.darkTextPrimary,
    ),
    extensions: const [
      DiLangThemeExtension.dark,
    ],
  );
}
