import 'package:flutter/widgets.dart';
import 'design_tokens.dart';

/// Pre-configured BorderRadius helper objects for standard component corners.
abstract class AppRadius {
  static const Radius rSmall = Radius.circular(DesignTokens.radiusSmall);
  static const Radius rMedium = Radius.circular(DesignTokens.radiusMedium);
  static const Radius rLarge = Radius.circular(DesignTokens.radiusLarge);
  static const Radius rFloating = Radius.circular(DesignTokens.radiusFloating);

  static const BorderRadius borderSmall = BorderRadius.all(rSmall);
  static const BorderRadius borderMedium = BorderRadius.all(rMedium);
  static const BorderRadius borderLarge = BorderRadius.all(rLarge);
  static const BorderRadius borderFloating = BorderRadius.all(rFloating);
}
