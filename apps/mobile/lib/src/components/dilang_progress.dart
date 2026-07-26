import 'package:flutter/material.dart';
import '../theme/app_gradients.dart';
import '../theme/design_tokens.dart';

class DiLangGradientProgress extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double height;
  final LinearGradient gradient;

  const DiLangGradientProgress({
    super.key,
    required this.progress,
    this.height = 8.0,
    this.gradient = AppGradients.primary,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: isDark ? const Color.fromRGBO(255, 255, 255, 0.08) : const Color.fromRGBO(0, 0, 0, 0.08),
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedContainer(
                duration: DesignTokens.durationNormal,
                curve: DesignTokens.defaultCurve,
                width: constraints.maxWidth * clampedProgress,
                height: height,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
