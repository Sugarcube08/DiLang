import 'package:flutter/material.dart';
import 'responsive_breakpoints.dart';
import '../glass_components.dart';
import '../../theme/app_colors.dart';
import '../../theme/design_tokens.dart';

/// Adaptive Modal Dialog & Sheet component that automatically transforms:
/// - Compact (< 600px): Full-screen or bottom sheet modal
/// - Medium/Expanded/Large (> 600px): Centered modal dialog with max width constraints
class ResponsiveDialog extends StatelessWidget {
  final Widget title;
  final Widget content;
  final List<Widget>? actions;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  const ResponsiveDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.maxWidth = ResponsiveBreakpoints.maxDialogWidth,
    this.padding,
  });

  /// Helper to show adaptive dialog/sheet easily
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget title,
    required Widget content,
    List<Widget>? actions,
    double maxWidth = ResponsiveBreakpoints.maxDialogWidth,
  }) {
    if (context.isCompact) {
      return showModalBottomSheet<T>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => ResponsiveSheet(
          title: title,
          content: content,
          actions: actions,
        ),
      );
    }

    return showDialog<T>(
      context: context,
      builder: (ctx) => ResponsiveDialog(
        title: title,
        content: content,
        actions: actions,
        maxWidth: maxWidth,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: context.responsivePadding,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: GlassContainer(
          padding: padding ?? const EdgeInsets.all(DesignTokens.space24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Header
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ) ??
                      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  child: title,
                ),
                const SizedBox(height: DesignTokens.space16),

                // Content Body
                Flexible(
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                    child: content,
                  ),
                ),

                // Actions Button Row
                if (actions != null && actions!.isNotEmpty) ...[
                  const SizedBox(height: DesignTokens.space24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: actions!.map((action) {
                      return Padding(
                        padding: const EdgeInsets.only(left: DesignTokens.space8),
                        child: action,
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

/// Adaptive Bottom Sheet for compact mobile views
class ResponsiveSheet extends StatelessWidget {
  final Widget title;
  final Widget content;
  final List<Widget>? actions;

  const ResponsiveSheet({
    super.key,
    required this.title,
    required this.content,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: GlassContainer(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(DesignTokens.radiusLarge),
        ),
        padding: const EdgeInsets.all(DesignTokens.space24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Indicator Pill
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: DesignTokens.space16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black26,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Title
              DefaultTextStyle(
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ) ??
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                child: title,
              ),
              const SizedBox(height: DesignTokens.space16),

              // Content
              DefaultTextStyle(
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
                child: content,
              ),

              // Actions
              if (actions != null && actions!.isNotEmpty) ...[
                const SizedBox(height: DesignTokens.space24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: actions!.map((act) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: DesignTokens.space8),
                      child: act,
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
