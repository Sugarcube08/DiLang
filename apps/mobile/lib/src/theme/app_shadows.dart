import 'package:flutter/widgets.dart';

/// Soft, Non-Harsh Shadow Definitions for Light & Dark Themes.
abstract class AppShadows {
  // --- Light Theme Shadows ---
  static const List<BoxShadow> lightLevel1 = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.04),
      blurRadius: 10,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> lightLevel2 = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.06),
      blurRadius: 20,
      offset: Offset(0, 6),
    ),
  ];

  static const List<BoxShadow> lightFloating = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.08),
      blurRadius: 30,
      offset: Offset(0, 12),
    ),
  ];

  // --- Dark Theme Shadows ---
  static const List<BoxShadow> darkLevel1 = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.25),
      blurRadius: 12,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> darkLevel2 = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.35),
      blurRadius: 24,
      offset: Offset(0, 6),
    ),
  ];

  static const List<BoxShadow> darkFloating = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.50),
      blurRadius: 36,
      offset: Offset(0, 14),
    ),
  ];
}
