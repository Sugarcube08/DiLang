import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../native_bridge.dart';
import '../theme/theme_extensions.dart';
import '../theme/design_tokens.dart';
import '../theme/app_colors.dart';
import '../components/glass_components.dart';
import '../components/budgie_mascot.dart';
import '../components/dilang_button.dart';

class TargetLanguageScreen extends StatefulWidget {
  const TargetLanguageScreen({super.key});

  @override
  State<TargetLanguageScreen> createState() => _TargetLanguageScreenState();
}

class _TargetLanguageScreenState extends State<TargetLanguageScreen> {
  String _selectedTarget = 'German';

  final List<Map<String, String>> _targets = [
    {'code': 'de', 'name': 'German', 'flag': '🇩🇪', 'desc': 'A2 Conversational & Grammar'},
    {'code': 'es', 'name': 'Spanish', 'flag': '🇪🇸', 'desc': 'B1 Daily Dialogue'},
    {'code': 'fr', 'name': 'French', 'flag': '🇫🇷', 'desc': 'A1 Essentials'},
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 2 of 3'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.space24),
          child: Column(
            children: [
              const BudgieMascot(
                size: 90,
                mood: BudgieMood.studying,
                speechBubbleText: 'Which language do you want to master?',
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _targets.length,
                  itemBuilder: (context, index) {
                    final target = _targets[index];
                    final isSelected = target['name'] == _selectedTarget;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GlassCard(
                        accentColor: isSelected ? AppColors.turquoise500 : null,
                        onTap: () {
                          setState(() => _selectedTarget = target['name']!);
                        },
                        child: Row(
                          children: [
                            Text(target['flag']!, style: const TextStyle(fontSize: 28)),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  target['name']!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  target['desc']!,
                                  style: TextStyle(fontSize: 12, color: colors.textSecondary),
                                ),
                              ],
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
              ),
              SizedBox(
                width: double.infinity,
                child: DiLangButton(
                  label: 'Continue to Setup',
                  icon: Icons.arrow_forward,
                  onPressed: () async {
                    await DiLangNativeBridge.updateTargetLanguage(_selectedTarget);
                    if (context.mounted) {
                      context.go('/onboarding/permissions');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
