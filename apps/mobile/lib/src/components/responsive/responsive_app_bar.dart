import 'package:flutter/material.dart';
import 'responsive_breakpoints.dart';
import '../../theme/app_colors.dart';

/// Responsive AppBar component that handles RTL directionality back buttons,
/// text scale limits, and adaptive desktop/tablet title layouts.
class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;

  const ResponsiveAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.bottom,
  });

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget? effectiveLeading = leading;
    if (effectiveLeading == null && automaticallyImplyLeading && Navigator.of(context).canPop()) {
      effectiveLeading = IconButton(
        icon: Icon(
          context.isRtl ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
          size: 20,
        ),
        onPressed: () => Navigator.of(context).pop(),
      );
    }

    return AppBar(
      title: DefaultTextStyle(
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ) ??
            const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        child: title,
      ),
      centerTitle: context.isCompact,
      leading: effectiveLeading,
      actions: actions,
      bottom: bottom,
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }
}
