import 'package:flutter/material.dart';
import 'budgie_circular_logo.dart';
import '../theme/app_colors.dart';

enum BudgieMood { happy, studying, listening, celebrating }

/// Official Budgie Mascot Presentation Wrapper
/// Uses the single circular Budgie identity throughout the product.
class BudgieMascot extends StatelessWidget {
  final double size;
  final BudgieMood mood;
  final String? speechText;
  final String? speechBubbleText;

  const BudgieMascot({
    super.key,
    this.size = 90,
    this.mood = BudgieMood.happy,
    this.speechText,
    this.speechBubbleText,
  });

  String? get _effectiveText => speechText ?? speechBubbleText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_effectiveText != null && _effectiveText!.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.lightSurface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.turquoise500.withValues(alpha: 0.3),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.turquoise500.withValues(alpha: 0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              _effectiveText!,
              style: const TextStyle(
                color: AppColors.lightTextPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
        BudgieCircularLogo(
          size: size,
          showGlow: mood == BudgieMood.celebrating || mood == BudgieMood.studying,
        ),
      ],
    );
  }
}
