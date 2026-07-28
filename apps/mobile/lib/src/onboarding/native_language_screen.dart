import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../native_bridge.dart';
import '../theme/app_colors.dart';
import '../components/toucan_mascot.dart';
import '../components/dilang_button.dart';
import '../components/responsive/responsive.dart';

class NativeLanguageScreen extends StatefulWidget {
  const NativeLanguageScreen({super.key});

  @override
  State<NativeLanguageScreen> createState() => _NativeLanguageScreenState();
}

class _NativeLanguageScreenState extends State<NativeLanguageScreen> {
  String _selectedLanguage = 'English';

  final List<Map<String, String>> _languages = const [
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'de', 'name': 'German', 'flag': '🇩🇪'},
    {'code': 'es', 'name': 'Spanish', 'flag': '🇪🇸'},
    {'code': 'fr', 'name': 'French', 'flag': '🇫🇷'},
    {'code': 'hi', 'name': 'Hindi', 'flag': '🇮🇳'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ResponsiveAppBar(
        title: Text('Step 1 of 3'),
      ),
      body: SafeArea(
        child: ResponsiveForm(
          actions: [
            DiLangButton(
              label: 'Next Step',
              icon: context.isRtl ? Icons.arrow_back : Icons.arrow_forward,
              onPressed: () async {
                await DiLangNativeBridge.updateNativeLanguage(_selectedLanguage);
                if (context.mounted) {
                  context.go('/onboarding/target-language');
                }
              },
            ),
          ],
          child: Column(
            children: [
              const ToucanMascot(
                size: 90,
                mood: ToucanMood.happy,
                speechBubbleText: 'What is your native language?',
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _languages.length,
                itemBuilder: (context, index) {
                  final lang = _languages[index];
                  final isSelected = lang['name'] == _selectedLanguage;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ResponsiveCard(
                      accentColor: isSelected ? AppColors.turquoise500 : null,
                      onTap: () {
                        setState(() => _selectedLanguage = lang['name']!);
                      },
                      child: Row(
                        children: [
                          Text(lang['flag']!, style: const TextStyle(fontSize: 24)),
                          const SizedBox(width: 14),
                          Text(
                            lang['name']!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          if (isSelected)
                            const Icon(Icons.check_circle, color: AppColors.turquoise500),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
