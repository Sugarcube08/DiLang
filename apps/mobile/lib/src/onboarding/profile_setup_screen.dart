import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/user_profile_provider.dart';
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
  final TextEditingController _countryController = TextEditingController();
  int _selectedMinutes = 15;
  String? _errorMessage;

  void _handleContinue() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your name.';
      });
      return;
    }

    final success = ref.read(userProfileProvider.notifier).createUserProfile(
          username: name,
          nativeLang: 'English',
          targetLang: 'German',
          avatar: 'avatar_default.png',
          age: 25,
          country: _countryController.text.trim().isEmpty ? 'United States' : _countryController.text.trim(),
          timezone: 'UTC',
          dailyMinutes: _selectedMinutes,
        );

    if (success) {
      context.go('/onboarding/languages');
    } else {
      setState(() {
        _errorMessage = 'Failed to create profile in SQLite database.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Setup'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.space24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to DiLang',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Set up your local profile stored securely on your device.',
              style: TextStyle(color: colors.textSecondary),
            ),
            const SizedBox(height: 32),

            // Profile Input Card
            DiLangCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your Name', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  DiLangInput(
                    controller: _nameController,
                    hintText: 'Enter your name or nickname',
                    prefixIcon: DiIcons.check,
                  ),
                  const SizedBox(height: 16),
                  Text('Country / Region', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  DiLangInput(
                    controller: _countryController,
                    hintText: 'e.g. Germany, Japan, USA',
                    prefixIcon: DiIcons.settings,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Daily Target Minutes
            Text('Daily Target Learning Time', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [10, 15, 30].map((mins) {
                final isSelected = _selectedMinutes == mins;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: DiLangCard(
                      onTap: () => setState(() => _selectedMinutes = mins),
                      child: Center(
                        child: Text(
                          '$mins Mins',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? colors.primary : colors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            if (_errorMessage != null) ...[
              Text(_errorMessage!, style: TextStyle(color: colors.error)),
              const SizedBox(height: 16),
            ],

            SizedBox(
              width: double.infinity,
              child: DiLangButton(
                label: 'Save & Continue',
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
