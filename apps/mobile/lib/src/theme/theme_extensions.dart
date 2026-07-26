import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_shadows.dart';

/// Custom Theme Extension for DiLang specific design tokens.
@immutable
class DiLangThemeExtension extends ThemeExtension<DiLangThemeExtension> {
  final Color glassFill;
  final Color glassBorder;
  final List<BoxShadow> softShadows;
  final Color textPrimary;
  final Color textSecondary;

  const DiLangThemeExtension({
    required this.glassFill,
    required this.glassBorder,
    required this.softShadows,
    required this.textPrimary,
    required this.textSecondary,
  });

  static const light = DiLangThemeExtension(
    glassFill: AppColors.lightGlassFill,
    glassBorder: AppColors.lightBorder,
    softShadows: AppShadows.lightLevel1,
    textPrimary: AppColors.lightTextPrimary,
    textSecondary: AppColors.lightTextSecondary,
  );

  static const dark = DiLangThemeExtension(
    glassFill: AppColors.darkGlassFill,
    glassBorder: AppColors.darkBorder,
    softShadows: AppShadows.darkLevel1,
    textPrimary: AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
  );

  @override
  DiLangThemeExtension copyWith({
    Color? glassFill,
    Color? glassBorder,
    List<BoxShadow>? softShadows,
    Color? textPrimary,
    Color? textSecondary,
  }) {
    return DiLangThemeExtension(
      glassFill: glassFill ?? this.glassFill,
      glassBorder: glassBorder ?? this.glassBorder,
      softShadows: softShadows ?? this.softShadows,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
    );
  }

  @override
  DiLangThemeExtension lerp(ThemeExtension<DiLangThemeExtension>? other, double t) {
    if (other is! DiLangThemeExtension) return this;
    return DiLangThemeExtension(
      glassFill: Color.lerp(glassFill, other.glassFill, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      softShadows: BoxShadow.lerpList(softShadows, other.softShadows, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
    );
  }
}
