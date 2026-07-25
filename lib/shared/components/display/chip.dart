import 'package:flutter/material.dart';
import '../../theme/dilang_theme.dart';
import '../../theme/radius_tokens.dart';

class AppChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? color;

  const AppChip({
    super.key,
    required this.label,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final semantic = DiLangTheme.of(context);
    final chipColor = color ?? semantic.accentPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withAlpha(38),
        borderRadius: RadiusTokens.borderSm,
        border: Border.all(color: chipColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: chipColor),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(color: chipColor, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
