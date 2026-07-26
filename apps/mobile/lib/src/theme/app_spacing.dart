import 'package:flutter/widgets.dart';
import 'design_tokens.dart';

/// Convenient EdgeInsets and Gap Utilities following the 8-point system.
abstract class AppSpacing {
  // Padding All
  static const EdgeInsets p4 = EdgeInsets.all(DesignTokens.space4);
  static const EdgeInsets p8 = EdgeInsets.all(DesignTokens.space8);
  static const EdgeInsets p12 = EdgeInsets.all(DesignTokens.space12);
  static const EdgeInsets p16 = EdgeInsets.all(DesignTokens.space16);
  static const EdgeInsets p20 = EdgeInsets.all(DesignTokens.space20);
  static const EdgeInsets p24 = EdgeInsets.all(DesignTokens.space24);
  static const EdgeInsets p32 = EdgeInsets.all(DesignTokens.space32);

  // Horizontal Padding
  static const EdgeInsets px16 = EdgeInsets.symmetric(horizontal: DesignTokens.space16);
  static const EdgeInsets px24 = EdgeInsets.symmetric(horizontal: DesignTokens.space24);

  // Vertical Padding
  static const EdgeInsets py12 = EdgeInsets.symmetric(vertical: DesignTokens.space12);
  static const EdgeInsets py16 = EdgeInsets.symmetric(vertical: DesignTokens.space16);

  // Spacers (SizedBox)
  static const SizedBox gap4 = SizedBox(width: DesignTokens.space4, height: DesignTokens.space4);
  static const SizedBox gap8 = SizedBox(width: DesignTokens.space8, height: DesignTokens.space8);
  static const SizedBox gap12 = SizedBox(width: DesignTokens.space12, height: DesignTokens.space12);
  static const SizedBox gap16 = SizedBox(width: DesignTokens.space16, height: DesignTokens.space16);
  static const SizedBox gap24 = SizedBox(width: DesignTokens.space24, height: DesignTokens.space24);
  static const SizedBox gap32 = SizedBox(width: DesignTokens.space32, height: DesignTokens.space32);
}
