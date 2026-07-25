import 'package:flutter/material.dart';
import '../../theme/dilang_theme.dart';
import '../button/primary_button.dart';

class AppErrorState extends StatelessWidget {
  final String title;
  final String errorMessage;
  final VoidCallback? onRetry;

  const AppErrorState({
    super.key,
    this.title = 'Something Went Wrong',
    required this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final semantic = DiLangTheme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: semantic.accentError),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: semantic.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              style: TextStyle(fontSize: 14, color: semantic.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Retry Operation',
                icon: Icons.refresh,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
