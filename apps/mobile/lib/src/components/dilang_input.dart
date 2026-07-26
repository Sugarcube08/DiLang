import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';
import '../theme/app_radius.dart';
import '../theme/app_colors.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: TextStyle(
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        hintStyle: TextStyle(
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          fontSize: 14,
        ),
        filled: true,
        fillColor: isDark ? AppColors.darkGlassFill : AppColors.lightGlassFill,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary, size: 20)
            : null,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: AppRadius.borderSmall,
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: DesignTokens.borderWidthThin,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderSmall,
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: DesignTokens.borderWidthMedium,
          ),
        ),
      ),
    );
  }
}
