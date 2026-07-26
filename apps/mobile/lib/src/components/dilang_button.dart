import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';

enum DiLangButtonVariant { filled, secondary, glass, outlined, text }

class DiLangButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final DiLangButtonVariant variant;
  final bool isLoading;
  final bool isFullWidth;

  const DiLangButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = DiLangButtonVariant.filled,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget content = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          ),
          const SizedBox(width: 10),
        ] else if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );

    Widget buttonWidget;

    switch (variant) {
      case DiLangButtonVariant.filled:
        buttonWidget = Container(
          decoration: const BoxDecoration(
            gradient: AppGradients.primary,
            borderRadius: AppRadius.borderMedium,
            boxShadow: AppShadows.glowPrimary,
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: Colors.white,
              minimumSize: const Size(48, 48),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: const RoundedRectangleBorder(borderRadius: AppRadius.borderMedium),
            ),
            child: content,
          ),
        );
        break;

      case DiLangButtonVariant.secondary:
      case DiLangButtonVariant.glass:
        buttonWidget = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: isDark ? AppColors.darkGlassSurface : AppColors.lightGlassSurface,
            foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            side: BorderSide(
              color: isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder,
              width: 1.2,
            ),
            minimumSize: const Size(48, 48),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.borderMedium),
          ),
          child: content,
        );
        break;

      case DiLangButtonVariant.outlined:
        buttonWidget = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.turquoise500,
            side: const BorderSide(
              color: AppColors.turquoise500,
              width: 1.5,
            ),
            minimumSize: const Size(48, 48),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.borderMedium),
          ),
          child: content,
        );
        break;

      case DiLangButtonVariant.text:
        buttonWidget = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.turquoise500,
            minimumSize: const Size(48, 48),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: content,
        );
        break;
    }

    return isFullWidth ? SizedBox(width: double.infinity, child: buttonWidget) : buttonWidget;
  }
}
