import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/theme_extensions.dart';
import '../theme/app_gradients.dart';
import '../theme/design_tokens.dart';
import '../theme/di_icons.dart';
import 'toucan_circular_logo.dart';
import 'dilang_button.dart';
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
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('DiLang Design System'),
        actions: [
          IconButton(
            icon: Icon(isDark ? DiIcons.lightMode : DiIcons.darkMode),
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
            _buildSectionHeader('1. DiLang Official Logos'),
            const SizedBox(height: 12),
            Center(
              child: Column(
                children: [
                  const ToucanCircularLogo(size: 80, showGlow: true),
                  const SizedBox(height: 16),
                  SvgPicture.asset(
                    'assets/logos/full/logo_full.svg',
                    height: 60,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            _buildSectionHeader('2. Semantic Palette Colors'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildColorChip('Primary', colors.primary),
                _buildColorChip('Secondary', colors.secondary),
                _buildColorChip('Accent', colors.accent),
                _buildColorChip('Warning', colors.warning),
                _buildColorChip('Error', colors.error),
                _buildColorChip('Info', colors.info),
              ],
            ),
            const SizedBox(height: 32),

            _buildSectionHeader('3. Button System & Controls'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                DiLangButton(
                  label: 'Filled Primary',
                  icon: DiIcons.play,
                  variant: DiLangButtonVariant.filled,
                  onPressed: () {},
                ),
                DiLangButton(
                  label: 'Glass Panel',
                  icon: DiIcons.spark,
                  variant: DiLangButtonVariant.glass,
                  onPressed: () {},
                ),
                DiLangButton(
                  label: 'Outlined',
                  icon: DiIcons.tune,
                  variant: DiLangButtonVariant.outlined,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 32),

            _buildSectionHeader('4. Input Fields & Progress'),
            const SizedBox(height: 12),
            const DiLangInput(
              hintText: 'Type your response in target language...',
              prefixIcon: DiIcons.mic,
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
              gradient: AppGradients.aquaMint,
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
