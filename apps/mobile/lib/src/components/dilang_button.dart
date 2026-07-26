import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';
import '../theme/app_gradients.dart';
import '../theme/app_radius.dart';

enum DiLangButtonVariant { filled, glass, outlined, text }

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
      main: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          ),
          const SizedBox(width: 10),
        ] else if (icon != null) ...[
          Icon(icon, size: DesignTokens.icon20),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );

    Widget buttonWidget;

    switch (variant) {
      case DiLangButtonVariant.filled:
        buttonWidget = Container(
          decoration: BoxDecoration(
            gradient: AppGradients.primary,
            borderRadius: AppRadius.borderMedium,
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: Colors.white,
              minimumSize: const Size(DesignTokens.minTouchTarget, DesignTokens.minTouchTarget),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMedium),
            ),
            child: content,
          ),
        );
        break;

      case DiLangButtonVariant.glass:
        buttonWidget = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: isDark ? const Color.fromRGBO(255, 255, 255, 0.05) : const Color.fromRGBO(0, 0, 0, 0.03),
            foregroundColor: isDark ? Colors.white : Colors.black87,
            side: BorderSide(
              color: isDark ? const Color.fromRGBO(255, 255, 255, 0.12) : const Color.fromRGBO(0, 0, 0, 0.12),
              width: DesignTokens.borderWidthThin,
            ),
            minimumSize: const Size(DesignTokens.minTouchTarget, DesignTokens.minTouchTarget),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMedium),
          ),
          child: content,
        );
        break;

      case DiLangButtonVariant.outlined:
        buttonWidget = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.primary,
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: DesignTokens.borderWidthMedium,
            ),
            minimumSize: const Size(DesignTokens.minTouchTarget, DesignTokens.minTouchTarget),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMedium),
          ),
          child: content,
        );
        break;

      case DiLangButtonVariant.text:
        buttonWidget = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.primary,
            minimumSize: const Size(DesignTokens.minTouchTarget, DesignTokens.minTouchTarget),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: content,
        );
        break;
    }

    return isFullWidth ? SizedBox(width: double.infinity, child: buttonWidget) : buttonWidget;
  }
}
