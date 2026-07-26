import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../theme/theme_extensions.dart';
import '../theme/design_tokens.dart';
import '../theme/di_icons.dart';
import '../components/dilang_button.dart';
import '../components/dilang_card.dart';

class PermissionManagerScreen extends StatefulWidget {
  final VoidCallback onNext;

  const PermissionManagerScreen({super.key, required this.onNext});

  @override
  State<PermissionManagerScreen> createState() => _PermissionManagerScreenState();
}

class _PermissionManagerScreenState extends State<PermissionManagerScreen> {
  bool _micGranted = false;

  Future<void> _requestMicPermission() async {
    final status = await Permission.microphone.request();
    setState(() {
      _micGranted = status.isGranted;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: const Text('Permissions Manager')),
      body: Padding(
        padding: const EdgeInsets.all(DesignTokens.space24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Required Permissions',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Grant microphone access for voice practice and STT audio processing.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),

            DiLangCard(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(DiIcons.mic, color: colors.primary),
                ),
                title: const Text('Microphone Access'),
                subtitle: const Text('Required for speech recognition & oral dialogue practice'),
                trailing: _micGranted
                    ? Icon(DiIcons.check, color: colors.success)
                    : OutlinedButton(
                        onPressed: _requestMicPermission,
                        child: const Text('Grant'),
                      ),
              ),
            ),
            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: DiLangButton(
                label: 'Continue to Hardware Check',
                icon: DiIcons.play,
                onPressed: widget.onNext,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
