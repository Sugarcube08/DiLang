import 'package:flutter/material.dart';
import '../../theme/design_tokens.dart';

/// Centralized Window Size Class & Breakpoint Registry for DiLang.
/// Follows Material 3 & Responsive-First Design System Standards.
enum WindowSizeClass {
  compact,  // < 600 px (Phones portrait/landscape)
  medium,   // 600 - 840 px (Foldables, small tablets)
  expanded, // 840 - 1200 px (Large tablets, laptops)
  large,    // > 1200 px (Desktop monitors, ultra-wide)
}

abstract class ResponsiveBreakpoints {
  static const double compactMaxWidth = 600.0;
  static const double mediumMaxWidth = 840.0;
  static const double expandedMaxWidth = 1200.0;

  // Maximum content width limits to prevent stretched UI on wide screens
  static const double maxFormWidth = 640.0;
  static const double maxDialogWidth = 560.0;
  static const double maxContentWidth = 1120.0;

  /// Determine WindowSizeClass from width
  static WindowSizeClass fromWidth(double width) {
    if (width < compactMaxWidth) {
      return WindowSizeClass.compact;
    } else if (width < mediumMaxWidth) {
      return WindowSizeClass.medium;
    } else if (width < expandedMaxWidth) {
      return WindowSizeClass.expanded;
    } else {
      return WindowSizeClass.large;
    }
  }
}

/// Extension methods on BuildContext for effortless responsive querying across screens.
extension ResponsiveContext on BuildContext {
  /// Get current screen width
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Get current screen height
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Get current WindowSizeClass
  WindowSizeClass get windowSizeClass => ResponsiveBreakpoints.fromWidth(screenWidth);

  /// Breakpoint status helpers
  bool get isCompact => windowSizeClass == WindowSizeClass.compact;
  bool get isMedium => windowSizeClass == WindowSizeClass.medium;
  bool get isExpanded => windowSizeClass == WindowSizeClass.expanded;
  bool get isLarge => windowSizeClass == WindowSizeClass.large;

  /// Device form-factor groupings
  bool get isMobile => isCompact;
  bool get isTablet => isMedium || isExpanded;
  bool get isDesktop => isLarge;

  /// Directionality & RTL Detection
  bool get isRtl => Directionality.of(this) == TextDirection.rtl;

  /// Accessibility Text Scale Factor (Clamped to 200% for usability)
  double get textScaleFactor => MediaQuery.textScalerOf(this).clamp(minScaleFactor: 0.8, maxScaleFactor: 2.0).scale(1.0);

  /// Select value dynamically based on current breakpoint
  T responsive<T>({
    required T compact,
    T? medium,
    T? expanded,
    T? large,
  }) {
    switch (windowSizeClass) {
      case WindowSizeClass.compact:
        return compact;
      case WindowSizeClass.medium:
        return medium ?? compact;
      case WindowSizeClass.expanded:
        return expanded ?? medium ?? compact;
      case WindowSizeClass.large:
        return large ?? expanded ?? medium ?? compact;
    }
  }

  /// Get adaptive padding based on screen size class
  EdgeInsets get responsivePadding {
    return responsive<EdgeInsets>(
      compact: const EdgeInsets.all(DesignTokens.space16),
      medium: const EdgeInsets.all(DesignTokens.space24),
      expanded: const EdgeInsets.all(DesignTokens.space32),
      large: const EdgeInsets.all(DesignTokens.space40),
    );
  }

  /// Get adaptive spacing gap
  double get responsiveGap {
    return responsive<double>(
      compact: DesignTokens.space12,
      medium: DesignTokens.space16,
      expanded: DesignTokens.space24,
      large: DesignTokens.space32,
    );
  }
}
