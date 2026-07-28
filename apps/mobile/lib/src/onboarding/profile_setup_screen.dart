import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../native_bridge.dart';
import '../theme/theme_extensions.dart';
import '../theme/app_colors.dart';
import '../components/toucan_mascot.dart';
import '../components/dilang_button.dart';
import '../components/responsive/responsive.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Harsh');

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: const ResponsiveAppBar(
        title: Text('Welcome to DiLang'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: ResponsiveForm(
          actions: [
            DiLangButton(
              label: 'Continue',
              icon: context.isRtl ? Icons.arrow_back : Icons.arrow_forward,
              onPressed: () async {
                final name = _nameController.text.trim();
                if (name.isNotEmpty) {
                  await DiLangNativeBridge.createUserProfile(
                    username: name,
                    nativeLang: 'English',
                    targetLang: 'German',
                  );
                  await DiLangNativeBridge.setOnboardingStep('Languages');
                }
                if (context.mounted) {
                  context.go('/onboarding/native-language');
                }
              },
            ),
          ],
          child: Column(
            children: [
              const SizedBox(height: 12),
              const ToucanMascot(
                size: 110,
                mood: ToucanMood.happy,
                speechBubbleText: 'Hallo! What is your name?',
              ),
              const SizedBox(height: 24),
              ResponsiveCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Learner Profile',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your profile is stored 100% locally on this device.',
                      style: TextStyle(color: colors.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Your Name',
                        prefixIcon: const Icon(Icons.person, color: AppColors.turquoise500),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
