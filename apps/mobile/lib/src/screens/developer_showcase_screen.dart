import 'package:flutter/material.dart';
import '../theme/theme_extensions.dart';
import '../theme/di_icons.dart';
import '../components/dilang_button.dart';
import '../components/dilang_input.dart';
import '../components/responsive/responsive.dart';

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
      appBar: const ResponsiveAppBar(
        title: Text('Design System Showcase'),
      ),
      body: SingleChildScrollView(
        padding: context.responsivePadding,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: ResponsiveBreakpoints.maxContentWidth),
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
                  'Developer & Regression Test Gallery for UI Tokens and Responsive Components.',
                  style: TextStyle(color: colors.textSecondary),
                ),
                const SizedBox(height: 24),

                // Card Gallery Grid
                Text('Glass & Responsive Cards', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                ResponsiveGrid(
                  minItemWidth: 280,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    ResponsiveCard(
                      child: ListTile(
                        leading: Icon(DiIcons.spark, size: 28),
                        title: Text('Glassmorphic Card 1'),
                        subtitle: Text('Touch-target safe & responsive'),
                      ),
                    ),
                    ResponsiveCard(
                      child: ListTile(
                        leading: Icon(DiIcons.brain, size: 28),
                        title: Text('Glassmorphic Card 2'),
                        subtitle: Text('Adaptive padding & hover scale'),
                      ),
                    ),
                  ],
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
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
