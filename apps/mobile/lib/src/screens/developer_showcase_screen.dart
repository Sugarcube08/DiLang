import 'package:flutter/material.dart';
import '../theme/theme_extensions.dart';
import '../theme/design_tokens.dart';
import '../theme/di_icons.dart';
import '../components/dilang_button.dart';
import '../components/dilang_card.dart';
import '../components/dilang_input.dart';

class DeveloperShowcaseScreen extends StatefulWidget {
  const DeveloperShowcaseScreen({super.key});

  @override
  State<DeveloperShowcaseScreen> createState() => _DeveloperShowcaseScreenState();
}

class _DeveloperShowcaseScreenState extends State<DeveloperShowcaseScreen> {
  final TextEditingController _inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Design System Showcase'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.space24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Design System & Component Showcase',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Developer & Regression Test Gallery for UI Tokens and Components.',
              style: TextStyle(color: colors.textSecondary),
            ),
            const SizedBox(height: 24),

            // Card Gallery
            Text('Glass & Surface Cards', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            const DiLangCard(
              child: ListTile(
                leading: Icon(DiIcons.spark, size: 28),
                title: Text('Glassmorphic Surface Card'),
                subtitle: Text('Subtle backdrop filter & border radius'),
              ),
            ),
            const SizedBox(height: 24),

            // Input Fields
            Text('Input Component', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            DiLangInput(
              controller: _inputController,
              hintText: 'Enter text here...',
              prefixIcon: DiIcons.brain,
            ),
            const SizedBox(height: 24),

            // Buttons
            Text('Action Buttons', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                DiLangButton(
                  label: 'Primary Action',
                  icon: DiIcons.play,
                  onPressed: () {},
                ),
                DiLangButton(
                  label: 'Glass Action',
                  variant: DiLangButtonVariant.glass,
                  onPressed: () {},
                ),
                DiLangButton(
                  label: 'Text Button',
                  variant: DiLangButtonVariant.text,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
