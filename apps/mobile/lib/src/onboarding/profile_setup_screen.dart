import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/user_profile_provider.dart';
import '../native_bridge.dart';
import '../theme/theme_extensions.dart';
import '../theme/design_tokens.dart';
import '../theme/di_icons.dart';
import '../components/dilang_button.dart';
import '../components/dilang_input.dart';
import '../components/dilang_card.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;

  Future<void> _handleContinue() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your name.';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final success = await ref.read(userProfileProvider.notifier).createUserProfile(
          username: name,
          nativeLang: '',
          targetLang: '',
        );

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });
      if (success) {
        await DiLangNativeBridge.setOnboardingStep('NativeLanguage');
        if (mounted) context.go('/onboarding/native-language');
      } else {
        setState(() {
          _errorMessage = 'Failed to create user profile in SQLite.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Creation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(DesignTokens.space24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Profile',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your name to create your local account in SQLite.',
              style: TextStyle(color: colors.textSecondary),
            ),
            const SizedBox(height: 32),

            DiLangCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your Name', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  DiLangInput(
                    controller: _nameController,
                    hintText: 'e.g. Harsh',
                    prefixIcon: DiIcons.check,
                  ),
                ],
              ),
            ),
            const Spacer(),

            if (_errorMessage != null) ...[
              Text(_errorMessage!, style: TextStyle(color: colors.error)),
              const SizedBox(height: 16),
            ],

            SizedBox(
              width: double.infinity,
              child: DiLangButton(
                label: _isSubmitting ? 'Saving...' : 'Continue',
                icon: DiIcons.play,
                onPressed: _isSubmitting ? null : _handleContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
