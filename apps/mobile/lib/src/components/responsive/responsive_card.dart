import 'package:flutter/material.dart';
import 'responsive_breakpoints.dart';
import '../glass_components.dart';
import '../../theme/design_tokens.dart';

/// Responsive Card widget with minimum touch target constraints (48x48 dp),
/// dynamic breakpoint-aware padding, hover feedback on desktop/web, and RTL support.
class ResponsiveCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? accentColor;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  const ResponsiveCard({
    super.key,
    required this.child,
    this.onTap,
    this.accentColor,
    this.padding,
    this.width,
    this.height,
  });

  @override
  State<ResponsiveCard> createState() => _ResponsiveCardState();
}

class _ResponsiveCardState extends State<ResponsiveCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final effectivePadding = widget.padding ?? context.responsivePadding;

    Widget content = ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: DesignTokens.minTouchTarget,
        minHeight: DesignTokens.minTouchTarget,
      ),
      child: AnimatedContainer(
        duration: DesignTokens.durationFast,
        curve: DesignTokens.defaultCurve,
        transform: _isHovered ? Matrix4.diagonal3Values(1.015, 1.015, 1.0) : Matrix4.identity(),
        child: GlassCard(
          accentColor: widget.accentColor,
          padding: effectivePadding,
          onTap: widget.onTap,
          child: widget.child,
        ),
      ),
    );

    if (widget.onTap != null && (context.isExpanded || context.isLarge)) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: content,
      );
    }

    return content;
  }
}
