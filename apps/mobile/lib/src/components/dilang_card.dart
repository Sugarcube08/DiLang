import 'package:flutter/material.dart';
import 'glass_components.dart';

class DiLangCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? accentColor;

  const DiLangCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: padding,
      margin: margin,
      onTap: onTap,
      accentColor: accentColor,
      child: child,
    );
  }
}
