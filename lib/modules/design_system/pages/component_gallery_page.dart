import 'package:flutter/material.dart';
import '../../../shared/theme/dilang_theme.dart';
import '../../../shared/components/button/primary_button.dart';
import '../../../shared/components/button/secondary_button.dart';
import '../../../shared/components/button/ghost_button.dart';
import '../../../shared/components/button/icon_button.dart';
import '../../../shared/components/input/text_field.dart';
import '../../../shared/components/input/search_field.dart';
import '../../../shared/components/input/dropdown.dart';
import '../../../shared/components/display/card.dart';
import '../../../shared/components/display/chip.dart';
import '../../../shared/components/display/empty_state.dart';
import '../../../shared/components/display/error_state.dart';
import '../../../shared/layouts/responsive_layout.dart';

class ComponentGalleryPage extends StatefulWidget {
  const ComponentGalleryPage({super.key});

  @override
  State<ComponentGalleryPage> createState() => _ComponentGalleryPageState();
}

class _ComponentGalleryPageState extends State<ComponentGalleryPage> {
  bool isDarkMode = true;
  String selectedDropdown = 'German';

  @override
  Widget build(BuildContext context) {
    final themeData = isDarkMode ? DiLangTheme.darkTheme : DiLangTheme.lightTheme;

    return Theme(
      data: themeData,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('DiLang UI Component Gallery'),
          actions: [
            IconButton(
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () => setState(() => isDarkMode = !isDarkMode),
              tooltip: 'Toggle Theme',
            ),
          ],
        ),
        body: ResponsiveLayout(
          mobile: _buildGalleryContent(context),
          desktop: Row(
            children: [
              Container(
                width: 260,
                color: Theme.of(context).colorScheme.surface,
                padding: const EdgeInsets.all(24),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gallery Index', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(height: 16),
                    Text('1. Design Tokens'),
                    Text('2. Button Primitives'),
                    Text('3. Input Fields'),
                    Text('4. Display Cards & Chips'),
                    Text('5. State Indicators'),
                  ],
                ),
              ),
              Expanded(child: _buildGalleryContent(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGalleryContent(BuildContext context) {
    final semantic = DiLangTheme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Semantic Tokens & Design System Showcase', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: semantic.textPrimary)),
          const SizedBox(height: 8),
          Text('Pure presentation components decoupled from domain business logic.', style: TextStyle(fontSize: 14, color: semantic.textSecondary)),
          const SizedBox(height: 32),

          // Section 1: Buttons
          _SectionHeader(title: 'Button Primitives', color: semantic.textPrimary),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              PrimaryButton(label: 'Primary Button', icon: Icons.check, onPressed: () {}),
              PrimaryButton(label: 'Loading...', isLoading: true, onPressed: () {}),
              SecondaryButton(label: 'Secondary Button', icon: Icons.info, onPressed: () {}),
              GhostButton(label: 'Ghost Button', icon: Icons.arrow_forward, onPressed: () {}),
              AppIconButton(icon: Icons.favorite, onPressed: () {}),
            ],
          ),
          const SizedBox(height: 32),

          // Section 2: Input Controls
          _SectionHeader(title: 'Input Controls', color: semantic.textPrimary),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                const AppTextField(labelText: 'Learner Username', hintText: 'e.g. sugarcube'),
                const SizedBox(height: 16),
                const AppSearchField(hintText: 'Search vocabulary lemmas...'),
                const SizedBox(height: 16),
                AppDropdown<String>(
                  value: selectedDropdown,
                  labelText: 'Target Language',
                  items: const [
                    DropdownMenuItem(value: 'German', child: Text('German (DE)')),
                    DropdownMenuItem(value: 'Spanish', child: Text('Spanish (ES)')),
                  ],
                  onChanged: (v) => setState(() => selectedDropdown = v!),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Section 3: Cards & Chips
          _SectionHeader(title: 'Cards & Chips', color: semantic.textPrimary),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              const AppChip(label: 'CEFR A1', icon: Icons.school),
              AppChip(label: 'FSRS Review Due', icon: Icons.alarm, color: semantic.accentWarning),
              AppChip(label: 'Mastered', icon: Icons.verified, color: semantic.accentSuccess),
            ],
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Reusable AppCard Component', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: semantic.textPrimary)),
                  const SizedBox(height: 8),
                  Text('Enforces semantic surfaces, border subtle tokens, and border radii.', style: TextStyle(color: semantic.textSecondary, fontSize: 13)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Section 4: Empty & Error States
          _SectionHeader(title: 'State Indicators', color: semantic.textPrimary),
          Row(
            children: [
              Expanded(
                child: AppCard(
                  child: AppEmptyState(
                    title: 'No Active Sessions',
                    description: 'Start your daily conversation scenario to build recall stability.',
                    actionLabel: 'Start Scenario',
                    onAction: () {},
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppCard(
                  child: AppErrorState(
                    title: 'Storage Engine Error',
                    errorMessage: 'Failed to access WAL journal file.',
                    onRetry: () {},
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color color;

  const _SectionHeader({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        const Divider(height: 24),
      ],
    );
  }
}
