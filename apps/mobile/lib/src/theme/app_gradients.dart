import 'package:flutter/material.dart';
import 'app_colors.dart';

/// DiLang Design System 2.0 Gradients
abstract class AppGradients {
  static const LinearGradient primary = LinearGradient(
    colors: [AppColors.turquoise400, AppColors.turquoise600],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient aquaMint = LinearGradient(
    colors: [AppColors.turquoise300, AppColors.mint400],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient toucanCrown = LinearGradient(
    colors: [AppColors.amber400, AppColors.amber500],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient coralSunset = LinearGradient(
    colors: [AppColors.coral400, AppColors.amber500],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient lavenderAura = LinearGradient(
    colors: [AppColors.lavender400, AppColors.turquoise500],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassLight = LinearGradient(
    colors: [
      Color.fromRGBO(255, 255, 255, 0.85),
      Color.fromRGBO(255, 255, 255, 0.55),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassDark = LinearGradient(
    colors: [
      Color.fromRGBO(30, 41, 59, 0.75),
      Color.fromRGBO(15, 23, 42, 0.55),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
