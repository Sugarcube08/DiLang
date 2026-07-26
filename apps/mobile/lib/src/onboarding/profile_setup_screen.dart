import 'package:flutter/material.dart';
import '../theme/theme_extensions.dart';
import '../theme/design_tokens.dart';
import '../theme/di_icons.dart';
import '../components/dilang_button.dart';
import '../components/dilang_card.dart';
import '../components/dilang_input.dart';

class ProfileSetupScreen extends StatefulWidget {
  final Function(String name, String goal) onNext;

  const ProfileSetupScreen({super.key, required this.onNext});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameController = TextEditingController(text: 'Learner');
  String _selectedGoal = '15 min/day';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.space24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to DiLang',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Set up your local learning profile. Your data never leaves this device.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),

            DiLangCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your Name / Username', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  DiLangInput(
                    controller: _nameController,
                    hintText: 'Enter your name',
                    prefixIcon: DiIcons.spark,
                  ),
                  const SizedBox(height: 24),

                  Text('Daily Learning Goal', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    children: ['10 min/day', '15 min/day', '30 min/day'].map((goal) {
                      final isSelected = _selectedGoal == goal;
                      return ChoiceChip(
                        label: Text(goal),
                        selected: isSelected,
                        onSelected: (val) {
                          if (val) setState(() => _selectedGoal = goal);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: DiLangButton(
                label: 'Continue to Languages',
                icon: DiIcons.play,
                onPressed: () {
                  widget.onNext(_nameController.text.trim(), _selectedGoal);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
