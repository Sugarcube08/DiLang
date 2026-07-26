import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../native_bridge.dart';
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
  bool _isDesktop = false;

  @override
  void initState() {
    super.initState();
    _isDesktop = Platform.isLinux || Platform.isWindows || Platform.isMacOS;
    if (_isDesktop) {
      _micGranted = true;
    }
  }

  Future<void> _requestMicPermission() async {
    if (_isDesktop) {
      setState(() => _micGranted = true);
      return;
    }
    try {
      final status = await Permission.microphone.request();
      setState(() {
        _micGranted = status.isGranted;
      });
    } catch (_) {
      setState(() {
        _micGranted = true;
      });
    }
  }

  Future<void> _handleContinue() async {
    await DiLangNativeBridge.setOnboardingStep('Models');
    widget.onNext();
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
              _isDesktop
                  ? 'Desktop operating systems use system audio inputs. Microphone access is assumed.'
                  : 'Grant microphone access for voice practice and STT audio processing.',
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
                subtitle: Text(
                  _isDesktop
                      ? 'System default microphone ready'
                      : 'Required for speech recognition & oral dialogue practice',
                ),
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
                label: 'Continue to Model Download',
                icon: DiIcons.play,
                onPressed: _handleContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
