import 'package:flutter/animation.dart';

class MotionTokens {
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);

  static const Curve curveStandard = Cubic(0.4, 0.0, 0.2, 1.0);
  static const Curve curveDecelerate = Cubic(0.0, 0.0, 0.2, 1.0);
  static const Curve curveAccelerate = Cubic(0.4, 0.0, 1.0, 1.0);

  const MotionTokens._();
}
