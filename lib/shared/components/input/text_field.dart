import 'package:flutter/material.dart';
import '../../theme/dilang_theme.dart';
import '../../theme/radius_tokens.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const AppTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final semantic = DiLangTheme.of(context);

    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: TextStyle(color: semantic.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        errorText: errorText,
        labelStyle: TextStyle(color: semantic.textSecondary),
        hintStyle: TextStyle(color: semantic.textMuted),
        filled: true,
        fillColor: semantic.surfaceSecondary,
        border: OutlineInputBorder(
          borderRadius: RadiusTokens.borderLg,
          borderSide: BorderSide(color: semantic.borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: RadiusTokens.borderLg,
          borderSide: BorderSide(color: semantic.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: RadiusTokens.borderLg,
          borderSide: BorderSide(color: semantic.accentPrimary, width: 2),
        ),
      ),
    );
  }
}
