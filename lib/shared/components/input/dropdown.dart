import 'package:flutter/material.dart';
import '../../theme/dilang_theme.dart';
import '../../theme/radius_tokens.dart';

class AppDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? labelText;

  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    this.onChanged,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    final semantic = DiLangTheme.of(context);

    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: onChanged,
      dropdownColor: semantic.surfaceSecondary,
      style: TextStyle(color: semantic.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: semantic.textSecondary),
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
          borderSide: BorderSide(color: semantic.accentPrimary),
        ),
      ),
    );
  }
}
