import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import '../theme/design_tokens.dart';
import 'dilang_button.dart';
import 'dilang_card.dart';
import 'dilang_input.dart';
import 'dilang_progress.dart';

class DesignSystemShowcaseScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const DesignSystemShowcaseScreen({
    super.key,
    required this.onToggleTheme,
  });

  @override
  State<DesignSystemShowcaseScreen> createState() => _DesignSystemShowcaseScreenState();
}

class _DesignSystemShowcaseScreenState extends State<DesignSystemShowcaseScreen> {
  final double _progressValue = 0.65;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('DiLang Design System'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
            onPressed: widget.onToggleTheme,
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.space24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Section 1: Brand & Palette ---
            _buildSectionHeader('1. Brand & Palette Colors'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildColorChip('Primary', AppColors.primary),
                _buildColorChip('Secondary', AppColors.secondary),
                _buildColorChip('Accent', AppColors.accent),
                _buildColorChip('Warning', AppColors.warning),
                _buildColorChip('Error', AppColors.error),
                _buildColorChip('Info', AppColors.info),
              ],
            ),
            const SizedBox(height: 32),

            // --- Section 2: Glassmorphic Cards ---
            _buildSectionHeader('2. Glassmorphism & Depth'),
            const SizedBox(height: 12),
            DiLangCard(
              isGlass: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: AppGradients.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI Roleplay Engine',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Gemma 3 1B On-Device Model',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Conversational practice with 24px backdrop blur, 55% opacity fill, and 1px border stroke.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- Section 3: Buttons ---
            _buildSectionHeader('3. Button System'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                DiLangButton(
                  label: 'Filled Primary',
                  icon: Icons.play_arrow_rounded,
                  variant: DiLangButtonVariant.filled,
                  onPressed: () {},
                ),
                DiLangButton(
                  label: 'Glass Panel',
                  icon: Icons.auto_awesome_rounded,
                  variant: DiLangButtonVariant.glass,
                  onPressed: () {},
                ),
                DiLangButton(
                  label: 'Outlined',
                  icon: Icons.tune_rounded,
                  variant: DiLangButtonVariant.outlined,
                  onPressed: () {},
                ),
                DiLangButton(
                  label: 'Text Action',
                  variant: DiLangButtonVariant.text,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 32),

            // --- Section 4: Input & Progress ---
            _buildSectionHeader('4. Input Fields & Progress'),
            const SizedBox(height: 12),
            const DiLangInput(
              hintText: 'Type your response in target language...',
              prefixIcon: Icons.mic_rounded,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('FSRS Memory Retention', style: Theme.of(context).textTheme.titleMedium),
                Text('${(_progressValue * 100).toInt()}%', style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
            const SizedBox(height: 8),
            DiLangGradientProgress(
              progress: _progressValue,
              gradient: AppGradients.success,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.3,
      ),
    );
  }

  Widget _buildColorChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
