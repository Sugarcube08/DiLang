import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';

enum ToucanMood {
  happy,
  thinking,
  speaking,
  listening,
  surprised,
  celebrating,
  reading,
  sleeping,
  confused,
  encouraging,
  excited,
  focused,
  studying,
}

/// Official DiLang Logo & Mascot Presentation Wrapper
/// Uses clean basic brand SVG assets.
class ToucanMascot extends StatelessWidget {
  final double size;
  final ToucanMood mood;
  final String? speechText;
  final String? speechBubbleText;
  final bool showGlow;

  const ToucanMascot({
    super.key,
    this.size = 120,
    this.mood = ToucanMood.happy,
    this.speechText,
    this.speechBubbleText,
    this.showGlow = false,
  });

  String? get _effectiveText => speechText ?? speechBubbleText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_effectiveText != null && _effectiveText!.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            constraints: const BoxConstraints(maxWidth: 280),
            decoration: BoxDecoration(
              color: AppColors.lightSurface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.turquoise500.withValues(alpha: 0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.turquoise500.withValues(alpha: 0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              _effectiveText!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.lightTextPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: (showGlow || mood == ToucanMood.celebrating)
                ? [
                    BoxShadow(
                      color: AppColors.turquoise500.withValues(alpha: 0.35),
                      blurRadius: size * 0.25,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: SvgPicture.asset(
            'assets/logos/icon/logo.svg',
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
