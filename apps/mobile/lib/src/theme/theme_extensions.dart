import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_shadows.dart';

/// Semantic Colors ThemeExtension allowing full rebranding without touching UI screens.
@immutable
class DiLangColors extends ThemeExtension<DiLangColors> {
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color surface;
  final Color background;
  final Color container;
  final Color outline;
  final Color success;
  final Color warning;
  final Color error;
  final Color info;
  final Color textPrimary;
  final Color textSecondary;
  final Color glassFill;
  final Color glassBorder;

  // Domain Specific Semantic Colors
  final Color conversationUser;
  final Color conversationAI;
  final Color vocabularyKnown;
  final Color vocabularyWeak;
  final Color grammarWeak;
  final Color grammarStrong;

  final List<BoxShadow> softShadows;

  const DiLangColors({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.surface,
    required this.background,
    required this.container,
    required this.outline,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.textPrimary,
    required this.textSecondary,
    required this.glassFill,
    required this.glassBorder,
    required this.conversationUser,
    required this.conversationAI,
    required this.vocabularyKnown,
    required this.vocabularyWeak,
    required this.grammarWeak,
    required this.grammarStrong,
    required this.softShadows,
  });

  static const light = DiLangColors(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    accent: AppColors.accent,
    surface: AppColors.lightSurface,
    background: AppColors.lightBackground,
    container: AppColors.lightContainer,
    outline: AppColors.lightDivider,
    success: AppColors.accent,
    warning: AppColors.warning,
    error: AppColors.error,
    info: AppColors.info,
    textPrimary: AppColors.lightTextPrimary,
    textSecondary: AppColors.lightTextSecondary,
    glassFill: AppColors.lightGlassFill,
    glassBorder: AppColors.lightBorder,
    conversationUser: AppColors.userBubbleLight,
    conversationAI: AppColors.aiBubbleLight,
    vocabularyKnown: AppColors.vocabKnown,
    vocabularyWeak: AppColors.vocabWeak,
    grammarWeak: AppColors.grammarWeak,
    grammarStrong: AppColors.grammarStrong,
    softShadows: AppShadows.lightLevel1,
  );

  static const dark = DiLangColors(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    accent: AppColors.accent,
    surface: AppColors.darkSurface,
    background: AppColors.darkBackground,
    container: AppColors.darkContainer,
    outline: AppColors.darkDivider,
    success: AppColors.accent,
    warning: AppColors.warning,
    error: AppColors.error,
    info: AppColors.info,
    textPrimary: AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
    glassFill: AppColors.darkGlassFill,
    glassBorder: AppColors.darkBorder,
    conversationUser: AppColors.userBubbleDark,
    conversationAI: AppColors.aiBubbleDark,
    vocabularyKnown: AppColors.vocabKnown,
    vocabularyWeak: AppColors.vocabWeak,
    grammarWeak: AppColors.grammarWeak,
    grammarStrong: AppColors.grammarStrong,
    softShadows: AppShadows.darkLevel1,
  );

  @override
  DiLangColors copyWith({
    Color? primary,
    Color? secondary,
    Color? accent,
    Color? surface,
    Color? background,
    Color? container,
    Color? outline,
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
    Color? textPrimary,
    Color? textSecondary,
    Color? glassFill,
    Color? glassBorder,
    Color? conversationUser,
    Color? conversationAI,
    Color? vocabularyKnown,
    Color? vocabularyWeak,
    Color? grammarWeak,
    Color? grammarStrong,
    List<BoxShadow>? softShadows,
  }) {
    return DiLangColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
      surface: surface ?? this.surface,
      background: background ?? this.background,
      container: container ?? this.container,
      outline: outline ?? this.outline,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      glassFill: glassFill ?? this.glassFill,
      glassBorder: glassBorder ?? this.glassBorder,
      conversationUser: conversationUser ?? this.conversationUser,
      conversationAI: conversationAI ?? this.conversationAI,
      vocabularyKnown: vocabularyKnown ?? this.vocabularyKnown,
      vocabularyWeak: vocabularyWeak ?? this.vocabularyWeak,
      grammarWeak: grammarWeak ?? this.grammarWeak,
      grammarStrong: grammarStrong ?? this.grammarStrong,
      softShadows: softShadows ?? this.softShadows,
    );
  }

  @override
  DiLangColors lerp(ThemeExtension<DiLangColors>? other, double t) {
    if (other is! DiLangColors) return this;
    return DiLangColors(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      background: Color.lerp(background, other.background, t)!,
      container: Color.lerp(container, other.container, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      info: Color.lerp(info, other.info, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      glassFill: Color.lerp(glassFill, other.glassFill, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      conversationUser: Color.lerp(conversationUser, other.conversationUser, t)!,
      conversationAI: Color.lerp(conversationAI, other.conversationAI, t)!,
      vocabularyKnown: Color.lerp(vocabularyKnown, other.vocabularyKnown, t)!,
      vocabularyWeak: Color.lerp(vocabularyWeak, other.vocabularyWeak, t)!,
      grammarWeak: Color.lerp(grammarWeak, other.grammarWeak, t)!,
      grammarStrong: Color.lerp(grammarStrong, other.grammarStrong, t)!,
      softShadows: BoxShadow.lerpList(softShadows, other.softShadows, t)!,
    );
  }
}

/// Convenient BuildContext extension for typed semantic color retrieval.
extension ThemeContextExtension on BuildContext {
  DiLangColors get colors => Theme.of(this).extension<DiLangColors>() ?? DiLangColors.dark;
}
