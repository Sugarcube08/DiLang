import 'package:flutter/material.dart';
import '../../theme/dilang_theme.dart';
import '../../theme/radius_tokens.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20.0),
    this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final semantic = DiLangTheme.of(context);

    final cardChild = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? semantic.surfaceSecondary,
        borderRadius: RadiusTokens.borderLg,
        border: Border.all(color: semantic.borderSubtle),
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: RadiusTokens.borderLg,
        child: cardChild,
      );
    }
    return cardChild;
  }
}
