import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';
import '../theme/app_radius.dart';
import '../theme/theme_extensions.dart';

class DiLangInput extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;

  const DiLangInput({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: TextStyle(
        color: colors.textPrimary,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        hintStyle: TextStyle(
          color: colors.textSecondary,
          fontSize: 14,
        ),
        filled: true,
        fillColor: colors.glassFill,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: colors.textSecondary, size: 20)
            : null,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: AppRadius.borderSmall,
          borderSide: BorderSide(
            color: colors.glassBorder,
            width: DesignTokens.borderWidthThin,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderSmall,
          borderSide: BorderSide(
            color: colors.primary,
            width: DesignTokens.borderWidthMedium,
          ),
        ),
      ),
    );
  }
}
