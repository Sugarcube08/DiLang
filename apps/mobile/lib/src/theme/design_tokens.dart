import 'package:flutter/widgets.dart';

/// Centralized Design Tokens for DiLang Design System.
/// Freezes all spacing, icon sizes, touch targets, border widths, and motion curves.
abstract class DesignTokens {
  // --- 8-Point Spacing Tokens ---
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space40 = 40.0;
  static const double space48 = 48.0;
  static const double space64 = 64.0;

  // --- Icon Size Tokens ---
  static const double icon16 = 16.0;
  static const double icon20 = 20.0;
  static const double icon24 = 24.0;
  static const double icon28 = 28.0;
  static const double icon32 = 32.0;

  // --- Touch Target & Layout Limits ---
  static const double minTouchTarget = 48.0;
  static const double maxDesktopContentWidth = 1120.0;

  // --- Corner Radius Tokens ---
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 14.0;
  static const double radiusLarge = 20.0;
  static const double radiusFloating = 28.0;

  // --- Border Width Tokens ---
  static const double borderWidthThin = 1.0;
  static const double borderWidthMedium = 1.5;
  static const double borderWidthThick = 2.0;

  // --- Motion & Animation Tokens ---
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 250);
  static const Duration durationSlow = Duration(milliseconds: 350);
  static const Curve defaultCurve = Curves.easeOutCubic;

  // --- Blur Level Tokens ---
  static const double blurNone = 0.0;
  static const double blurSubtle = 12.0;
  static const double blurStandard = 20.0;
  static const double blurHeavy = 28.0;

  // --- Elevation Levels ---
  static const double elevation0 = 0.0;
  static const double elevation1 = 2.0;
  static const double elevation2 = 6.0;
  static const double elevationFloating = 12.0;
}
