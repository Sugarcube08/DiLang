import 'package:flutter/material.dart';
import '../../theme/dilang_theme.dart';
import '../../theme/radius_tokens.dart';

class AppSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;

  const AppSearchField({
    super.key,
    this.controller,
    this.hintText = 'Search...',
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final semantic = DiLangTheme.of(context);

    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: TextStyle(color: semantic.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: semantic.textMuted),
        prefixIcon: Icon(Icons.search, color: semantic.textSecondary),
        filled: true,
        fillColor: semantic.surfaceSecondary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          borderSide: BorderSide(color: semantic.accentPrimary),
        ),
      ),
    );
  }
}
