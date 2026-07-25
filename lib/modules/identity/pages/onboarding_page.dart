import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/dilang_theme.dart';
import '../../../shared/theme/semantic_colors.dart';
import '../../../shared/components/button/primary_button.dart';
import '../../../shared/components/button/secondary_button.dart';
import '../../../shared/components/input/text_field.dart';
import '../../../shared/components/input/dropdown.dart';
import '../../../shared/components/display/card.dart';
import '../../../shared/layouts/responsive_layout.dart';
import '../../../app/dependency_injection/providers.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  int currentStep = 0;

  final TextEditingController _nameController = TextEditingController(text: 'Learner');
  String _nativeLanguage = 'English';
  String _targetLanguage = 'German';
  String _currentCefr = 'A1';
  String _targetCefr = 'B2';
  final String _motivation = 'Daily Conversation';
  int _dailyMinutes = 15;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final semantic = DiLangTheme.of(context);

    return Scaffold(
      body: ResponsiveLayout(
        mobile: _buildStepContent(semantic),
        desktop: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: SizedBox(
              width: 560,
              child: _buildStepContent(semantic),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent(SemanticColors semantic) {
    return AppCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'DiLang Setup — Step ${currentStep + 1} of 4',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: semantic.accentSecondary),
              ),
              Text('${((currentStep + 1) / 4 * 100).toInt()}%', style: TextStyle(fontSize: 12, color: semantic.textMuted)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: (currentStep + 1) / 4, backgroundColor: semantic.surfaceTertiary, color: semantic.accentPrimary),
          const SizedBox(height: 24),
          if (currentStep == 0) _buildStep1Identity(semantic),
          if (currentStep == 1) _buildStep2Languages(semantic),
          if (currentStep == 2) _buildStep3Goals(semantic),
          if (currentStep == 3) _buildStep4Summary(semantic),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (currentStep > 0)
                SecondaryButton(
                  label: 'Back',
                  onPressed: () => setState(() => currentStep--),
                )
              else
                const SizedBox.shrink(),
              PrimaryButton(
                label: currentStep == 3 ? 'Finish & Initialize OS →' : 'Continue',
                onPressed: () async {
                  if (currentStep < 3) {
                    setState(() => currentStep++);
                  } else {
                    await ref.read(runtimeProvider.notifier).createProfile(
                          name: _nameController.text.trim(),
                          nativeLanguage: _nativeLanguage,
                          targetLanguage: _targetLanguage,
                          brainModel: _motivation,
                          aiCoachPersona: 'Friendly',
                        );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep1Identity(SemanticColors semantic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What should we call you?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: semantic.textPrimary)),
        const SizedBox(height: 8),
        Text('Your digital identity and learning profile will be linked to this name locally.', style: TextStyle(color: semantic.textSecondary)),
        const SizedBox(height: 20),
        AppTextField(
          controller: _nameController,
          labelText: 'Learner Name',
          hintText: 'e.g. Alex',
        ),
      ],
    );
  }

  Widget _buildStep2Languages(SemanticColors semantic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Languages & Proficiency', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: semantic.textPrimary)),
        const SizedBox(height: 8),
        Text('Select your native language and the language you want to master.', style: TextStyle(color: semantic.textSecondary)),
        const SizedBox(height: 20),
        AppDropdown<String>(
          value: _nativeLanguage,
          labelText: 'Native Language',
          items: const [
            DropdownMenuItem(value: 'English', child: Text('English')),
            DropdownMenuItem(value: 'Spanish', child: Text('Spanish')),
          ],
          onChanged: (v) => setState(() => _nativeLanguage = v!),
        ),
        const SizedBox(height: 16),
        AppDropdown<String>(
          value: _targetLanguage,
          labelText: 'Target Language',
          items: const [
            DropdownMenuItem(value: 'German', child: Text('German (DE)')),
            DropdownMenuItem(value: 'French', child: Text('French (FR)')),
          ],
          onChanged: (v) => setState(() => _targetLanguage = v!),
        ),
      ],
    );
  }

  Widget _buildStep3Goals(SemanticColors semantic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('CEFR Trajectory & Daily Commitment', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: semantic.textPrimary)),
        const SizedBox(height: 8),
        Text('Set your current starting level and daily learning target.', style: TextStyle(color: semantic.textSecondary)),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: AppDropdown<String>(
                value: _currentCefr,
                labelText: 'Starting CEFR',
                items: const [
                  DropdownMenuItem(value: 'A1', child: Text('A1 (Beginner)')),
                  DropdownMenuItem(value: 'A2', child: Text('A2 (Elementary)')),
                  DropdownMenuItem(value: 'B1', child: Text('B1 (Intermediate)')),
                ],
                onChanged: (v) => setState(() => _currentCefr = v!),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppDropdown<String>(
                value: _targetCefr,
                labelText: 'Target CEFR',
                items: const [
                  DropdownMenuItem(value: 'B2', child: Text('B2 (Vantage)')),
                  DropdownMenuItem(value: 'C1', child: Text('C1 (Effective Operational)')),
                  DropdownMenuItem(value: 'C2', child: Text('C2 (Mastery)')),
                ],
                onChanged: (v) => setState(() => _targetCefr = v!),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AppDropdown<int>(
          value: _dailyMinutes,
          labelText: 'Daily Goal Commitment',
          items: const [
            DropdownMenuItem(value: 10, child: Text('10 minutes / day')),
            DropdownMenuItem(value: 15, child: Text('15 minutes / day')),
            DropdownMenuItem(value: 30, child: Text('30 minutes / day')),
          ],
          onChanged: (v) => setState(() => _dailyMinutes = v!),
        ),
      ],
    );
  }

  Widget _buildStep4Summary(SemanticColors semantic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ready to Initialize DiLang OS', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: semantic.textPrimary)),
        const SizedBox(height: 8),
        Text('Review your digital learner identity before launching.', style: TextStyle(color: semantic.textSecondary)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: semantic.surfaceTertiary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _SummaryRow(label: 'Learner Name', value: _nameController.text.trim()),
              _SummaryRow(label: 'Native Language', value: _nativeLanguage),
              _SummaryRow(label: 'Target Language', value: _targetLanguage),
              _SummaryRow(label: 'CEFR Path', value: '$_currentCefr → $_targetCefr'),
              _SummaryRow(label: 'Daily Commitment', value: '$_dailyMinutes mins/day'),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final semantic = DiLangTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: semantic.textSecondary, fontSize: 13)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: semantic.textPrimary, fontSize: 13)),
        ],
      ),
    );
  }
}
