import 'package:flutter/material.dart';
import 'responsive_breakpoints.dart';
import '../../theme/design_tokens.dart';

/// Responsive Form Container enforcing maximum content width (640px),
/// keyboard-aware scrolling, and adaptive action button placement.
class ResponsiveForm extends StatelessWidget {
  final Widget child;
  final GlobalKey<FormState>? formKey;
  final List<Widget>? actions;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  const ResponsiveForm({
    super.key,
    required this.child,
    this.formKey,
    this.actions,
    this.maxWidth = ResponsiveBreakpoints.maxFormWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ?? context.responsivePadding;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            padding: effectivePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                child,
                if (actions != null && actions!.isNotEmpty) ...[
                  SizedBox(height: context.responsiveGap),
                  context.isCompact
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: actions!.map((act) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: DesignTokens.space8),
                              child: act,
                            );
                          }).toList(),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: actions!.map((act) {
                            return Padding(
                              padding: const EdgeInsets.only(left: DesignTokens.space12),
                              child: act,
                            );
                          }).toList(),
                        ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
