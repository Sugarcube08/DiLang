import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'design_tokens.dart';
import 'theme_extensions.dart';

/// Light Theme Data definition.
ThemeData getLightThemeData() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.lightSurface,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.lightTextPrimary,
      onError: Colors.white,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.lightDivider,
      thickness: DesignTokens.borderWidthThin,
      space: 1,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.lightTextPrimary,
      ),
      iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
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
      bodyColor: AppColors.lightTextPrimary,
      displayColor: AppColors.lightTextPrimary,
    ),
    extensions: const [
      DiLangColors.light,
    ],
  );
}
