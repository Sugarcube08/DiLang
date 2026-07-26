import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/user_profile_provider.dart';
import '../native_bridge.dart';
import '../theme/theme_extensions.dart';
import '../theme/design_tokens.dart';
import '../theme/di_icons.dart';
import '../components/dilang_button.dart';
import '../components/dilang_card.dart';
import 'native_language_screen.dart';

class TargetLanguageScreen extends ConsumerStatefulWidget {
  const TargetLanguageScreen({super.key});

  @override
  ConsumerState<TargetLanguageScreen> createState() => _TargetLanguageScreenState();
}

class _TargetLanguageScreenState extends ConsumerState<TargetLanguageScreen> {
  String _selectedTarget = 'German';
  bool _isSaving = false;

  Future<void> _handleContinue() async {
    final activeUser = ref.read(userProfileProvider).activeUser;
    final username = activeUser?['username']?.toString() ?? 'Learner';
    final nativeLang = activeUser?['native_language']?.toString() ?? 'English';

    setState(() => _isSaving = true);
    final success = await ref.read(userProfileProvider.notifier).createUserProfile(
          username: username,
          nativeLang: nativeLang,
          targetLang: _selectedTarget,
        );

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        await DiLangNativeBridge.setOnboardingStep('Permissions');
        if (mounted) context.go('/onboarding/permissions');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: const Text('Target Language')),
      body: Padding(
        padding: const EdgeInsets.all(DesignTokens.space24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Target Language',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select the language you want to learn.',
              style: TextStyle(color: colors.textSecondary),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: ListView.builder(
                itemCount: kSupportedLanguages.length,
                itemBuilder: (context, index) {
                  final lang = kSupportedLanguages[index];
                  final isSelected = lang == _selectedTarget;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: DiLangCard(
                      onTap: () => setState(() => _selectedTarget = lang),
                      child: ListTile(
                        title: Text(
                          lang,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? colors.primary : colors.textPrimary,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(DiIcons.check, color: colors.primary)
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: DiLangButton(
                label: _isSaving ? 'Persisting...' : 'Continue',
                icon: DiIcons.play,
                onPressed: _isSaving ? null : _handleContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
