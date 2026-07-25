import 'package:flutter/material.dart';

class SemanticColors extends ThemeExtension<SemanticColors> {
  final Color surfacePrimary;
  final Color surfaceSecondary;
  final Color surfaceTertiary;

  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  final Color accentPrimary;
  final Color accentSecondary;
  final Color accentSuccess;
  final Color accentWarning;
  final Color accentError;

  final Color borderSubtle;
  final Color borderStrong;

  final Color interactiveNormal;
  final Color interactiveHover;
  final Color interactivePressed;
  final Color interactiveDisabled;

  const SemanticColors({
    required this.surfacePrimary,
    required this.surfaceSecondary,
    required this.surfaceTertiary,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.accentPrimary,
    required this.accentSecondary,
    required this.accentSuccess,
    required this.accentWarning,
    required this.accentError,
    required this.borderSubtle,
    required this.borderStrong,
    required this.interactiveNormal,
    required this.interactiveHover,
    required this.interactivePressed,
    required this.interactiveDisabled,
  });

  @override
  SemanticColors copyWith({
    Color? surfacePrimary,
    Color? surfaceSecondary,
    Color? surfaceTertiary,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? accentPrimary,
    Color? accentSecondary,
    Color? accentSuccess,
    Color? accentWarning,
    Color? accentError,
    Color? borderSubtle,
    Color? borderStrong,
    Color? interactiveNormal,
    Color? interactiveHover,
    Color? interactivePressed,
    Color? interactiveDisabled,
  }) {
    return SemanticColors(
      surfacePrimary: surfacePrimary ?? this.surfacePrimary,
      surfaceSecondary: surfaceSecondary ?? this.surfaceSecondary,
      surfaceTertiary: surfaceTertiary ?? this.surfaceTertiary,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      accentPrimary: accentPrimary ?? this.accentPrimary,
      accentSecondary: accentSecondary ?? this.accentSecondary,
      accentSuccess: accentSuccess ?? this.accentSuccess,
      accentWarning: accentWarning ?? this.accentWarning,
      accentError: accentError ?? this.accentError,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      borderStrong: borderStrong ?? this.borderStrong,
      interactiveNormal: interactiveNormal ?? this.interactiveNormal,
      interactiveHover: interactiveHover ?? this.interactiveHover,
      interactivePressed: interactivePressed ?? this.interactivePressed,
      interactiveDisabled: interactiveDisabled ?? this.interactiveDisabled,
    );
  }

  @override
  SemanticColors lerp(ThemeExtension<SemanticColors>? other, double t) {
    if (other is! SemanticColors) return this;
    return SemanticColors(
      surfacePrimary: Color.lerp(surfacePrimary, other.surfacePrimary, t)!,
      surfaceSecondary: Color.lerp(surfaceSecondary, other.surfaceSecondary, t)!,
      surfaceTertiary: Color.lerp(surfaceTertiary, other.surfaceTertiary, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      accentPrimary: Color.lerp(accentPrimary, other.accentPrimary, t)!,
      accentSecondary: Color.lerp(accentSecondary, other.accentSecondary, t)!,
      accentSuccess: Color.lerp(accentSuccess, other.accentSuccess, t)!,
      accentWarning: Color.lerp(accentWarning, other.accentWarning, t)!,
      accentError: Color.lerp(accentError, other.accentError, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      interactiveNormal: Color.lerp(interactiveNormal, other.interactiveNormal, t)!,
      interactiveHover: Color.lerp(interactiveHover, other.interactiveHover, t)!,
      interactivePressed: Color.lerp(interactivePressed, other.interactivePressed, t)!,
      interactiveDisabled: Color.lerp(interactiveDisabled, other.interactiveDisabled, t)!,
    );
  }
}
