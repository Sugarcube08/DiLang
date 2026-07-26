import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'design_tokens.dart';
import 'app_shadows.dart';

/// DiLang Glassmorphic Container Component
/// Enforces 20-24px Backdrop Filter Blur, 55% Fill Opacity, 1px Border & Soft Shadow.
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry borderRadius;
  final double blur;
  final Color? fillColor;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = const BorderRadius.all(Radius.circular(DesignTokens.radiusMedium)),
    this.blur = DesignTokens.blurStandard, // 20.0px
    this.fillColor,
    this.borderColor,
    this.boxShadow,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveFill = fillColor ?? (isDark ? AppColors.darkGlassFill : AppColors.lightGlassFill);
    final effectiveBorder = borderColor ?? (isDark ? AppColors.darkBorder : AppColors.lightBorder);
    final effectiveShadow = boxShadow ?? (isDark ? AppShadows.darkLevel1 : AppShadows.lightLevel1);

    Widget content = Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: effectiveFill,
        borderRadius: borderRadius,
        border: Border.all(
          color: effectiveBorder,
          width: DesignTokens.borderWidthThin,
        ),
        boxShadow: effectiveShadow,
      ),
      child: child,
    );

    // Apply BackdropFilter blur
    Widget glassWidget = ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: content,
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: glassWidget,
      );
    }

    return glassWidget;
  }
}
