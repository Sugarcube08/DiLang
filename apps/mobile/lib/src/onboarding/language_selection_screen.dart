import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/theme_extensions.dart';
import '../theme/design_tokens.dart';
import '../theme/di_icons.dart';
import '../components/dilang_button.dart';
import '../components/dilang_card.dart';
import '../providers/user_profile_provider.dart';

class LanguageSelectionScreen extends ConsumerStatefulWidget {
  final VoidCallback onNext;

  const LanguageSelectionScreen({super.key, required this.onNext});

  @override
  ConsumerState<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends ConsumerState<LanguageSelectionScreen> {
  String _nativeLang = 'English';
  String _targetLang = 'German';

  static const List<String> _supportedLanguages = [
    'English',
    'German',
    'French',
    'Spanish',
    'Italian',
    'Portuguese',
    'Dutch',
    'Swedish',
    'Norwegian',
    'Danish',
    'Finnish',
    'Polish',
    'Czech',
    'Slovak',
    'Hungarian',
    'Romanian',
    'Turkish',
    'Japanese',
    'Korean',
    'Chinese',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: const Text('Language Selection')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.space24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Languages',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose your native language and the language you want to master.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),

            DiLangCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(DiIcons.learning, size: 20),
                      const SizedBox(width: 8),
                      Text('I Speak (Native Language)', style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _nativeLang,
                    items: _supportedLanguages.map((lang) {
                      return DropdownMenuItem(value: lang, child: Text(lang));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _nativeLang = val);
                    },
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      const Icon(DiIcons.brain, size: 20),
                      const SizedBox(width: 8),
                      Text('I Want to Learn (Target Language)', style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _targetLang,
                    items: _supportedLanguages.map((lang) {
                      return DropdownMenuItem(value: lang, child: Text(lang));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _targetLang = val);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: DiLangButton(
                label: 'Save & Continue',
                icon: DiIcons.play,
                onPressed: () async {
                  final activeUser = ref.read(userProfileProvider).activeUser;
                  final username = activeUser?['username']?.toString() ?? 'Learner';
                  await ref.read(userProfileProvider.notifier).createUserProfile(
                    username: username,
                    nativeLang: _nativeLang,
                    targetLang: _targetLang,
                  );
                  widget.onNext();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
