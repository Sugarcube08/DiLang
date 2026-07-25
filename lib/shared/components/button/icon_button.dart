import 'package:flutter/material.dart';
import '../../theme/dilang_theme.dart';
import '../../theme/radius_tokens.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final double size;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.color,
    this.size = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    final semantic = DiLangTheme.of(context);

    final button = IconButton(
      style: IconButton.styleFrom(
        backgroundColor: semantic.surfaceSecondary,
        shape: const RoundedRectangleBorder(borderRadius: RadiusTokens.borderLg),
        minimumSize: const Size(44, 44),
      ),
      icon: Icon(icon, color: color ?? semantic.accentSecondary, size: size),
      onPressed: onPressed,
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }
    return button;
  }
}
