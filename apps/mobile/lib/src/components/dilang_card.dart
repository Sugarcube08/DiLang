import 'package:flutter/material.dart';
import '../theme/glass.dart';
import '../theme/design_tokens.dart';
import '../theme/app_colors.dart';

class DiLangCard extends StatelessWidget {
  final Widget child;
  final bool isGlass;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const DiLangCard({
    super.key,
    required this.child,
    this.isGlass = true,
    this.padding = const EdgeInsets.all(DesignTokens.space20),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isGlass) {
      return GlassContainer(
        padding: padding,
        onTap: onTap,
        child: child,
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    Widget cardContent = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
          width: DesignTokens.borderWidthThin,
        ),
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        child: cardContent,
      );
    }

    return cardContent;
  }
}
