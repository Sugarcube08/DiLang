import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/dependency_injection/providers.dart';
import 'shared/theme/color_tokens.dart';
import 'shared/theme/typography.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: DiLangApp(),
    ),
  );
}

class DiLangApp extends ConsumerWidget {
  const DiLangApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runtimeState = ref.watch(dilangRuntimeProvider);

    return MaterialApp(
      title: 'DiLang — Personal Language OS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: ColorTokens.background,
        primaryColor: ColorTokens.primaryAzure,
        colorScheme: const ColorScheme.dark(
          primary: ColorTokens.primaryAzure,
          secondary: ColorTokens.secondaryCyan,
          surface: ColorTokens.surface,
        ),
      ),
      home: !runtimeState.isBootstrapped
          ? const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: ColorTokens.primaryAzure),
                    SizedBox(height: 16),
                    Text('Bootstrapping DiLang Runtime Kernel & SQLite Database...', style: TextStyle(color: ColorTokens.textSecondary)),
                  ],
                ),
              ),
            )
          : runtimeState.isOnboardingRequired
              ? const FtueOnboardingScreen()
              : const AppShellScreen(),
    );
  }
}

class FtueOnboardingScreen extends ConsumerStatefulWidget {
  const FtueOnboardingScreen({super.key});

  @override
  ConsumerState<FtueOnboardingScreen> createState() => _FtueOnboardingScreenState();
}

class _FtueOnboardingScreenState extends ConsumerState<FtueOnboardingScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Learner');
  String _nativeLang = 'English';
  String _targetLang = 'German';
  final String _brainModel = 'Conversation First';
  final String _persona = 'Friendly';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: ColorTokens.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ColorTokens.cardBorder),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.psychology, color: ColorTokens.primaryAzure, size: 32),
                    SizedBox(width: 12),
                    Text('DiLang Setup Wizard', style: TypographyTokens.headingMedium),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Initialize your learner identity and AI brain strategy.', style: TypographyTokens.bodyMedium),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Learner Name', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _nativeLang,
                        items: const [
                          DropdownMenuItem(value: 'English', child: Text('English')),
                          DropdownMenuItem(value: 'Spanish', child: Text('Spanish')),
                        ],
                        onChanged: (v) {
                          if (v != null) setState(() => _nativeLang = v);
                        },
                        decoration: const InputDecoration(labelText: 'Native Language', border: OutlineInputBorder()),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _targetLang,
                        items: const [
                          DropdownMenuItem(value: 'German', child: Text('German (DE)')),
                          DropdownMenuItem(value: 'French', child: Text('French (FR)')),
                        ],
                        onChanged: (v) {
                          if (v != null) setState(() => _targetLang = v);
                        },
                        decoration: const InputDecoration(labelText: 'Target Language', border: OutlineInputBorder()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: ColorTokens.primaryAzure),
                    onPressed: () async {
                      await ref.read(dilangRuntimeProvider.notifier).createProfile(
                            name: _nameController.text.trim(),
                            nativeLanguage: _nativeLang,
                            targetLanguage: _targetLang,
                            brainModel: _brainModel,
                            aiCoachPersona: _persona,
                          );
                    },
                    child: const Text('Initialize DiLang OS →', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppShellScreen extends ConsumerWidget {
  const AppShellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(activeTabProvider);
    final runtimeState = ref.watch(dilangRuntimeProvider);

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 240,
            color: const Color(0xFF111827),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.psychology, color: ColorTokens.primaryAzure, size: 28),
                    SizedBox(width: 8),
                    Text('DiLang OS', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 24),
                _NavTile(icon: Icons.today, label: 'TODAY', index: 0, activeIndex: activeTab),
                _NavTile(icon: Icons.hub, label: 'Knowledge Graph', index: 1, activeIndex: activeTab),
                _NavTile(icon: Icons.record_voice_over, label: 'Dialogue', index: 2, activeIndex: activeTab),
                _NavTile(icon: Icons.bug_report, label: 'Diagnostics', index: 3, activeIndex: activeTab),
                _NavTile(icon: Icons.settings, label: 'Settings', index: 4, activeIndex: activeTab),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Willkommen, ${runtimeState.learner?.displayName ?? "Learner"}',
                    style: TypographyTokens.headingLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Target: ${runtimeState.learner?.targetLanguage ?? "German"} • Brain Strategy: ${runtimeState.learner?.brainModel ?? "Conversation First"}',
                    style: TypographyTokens.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: ColorTokens.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ColorTokens.surfaceBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('SINGLE RUNTIME & SQLITE ENGINE ONLINE', style: TypographyTokens.labelSmall),
                        const SizedBox(height: 12),
                        const Text(
                          'Database Path: ~/.local/share/dilang/dilang_storage.db',
                          style: TextStyle(color: ColorTokens.successEmerald, fontSize: 13),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: ColorTokens.errorCoralRed),
                          onPressed: () async {
                            await ref.read(dilangRuntimeProvider.notifier).factoryReset();
                          },
                          icon: const Icon(Icons.delete_forever, color: Colors.white),
                          label: const Text('Factory Reset SQLite Database', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavTile extends ConsumerWidget {
  final IconData icon;
  final String label;
  final int index;
  final int activeIndex;

  const _NavTile({
    required this.icon,
    required this.label,
    required this.index,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = index == activeIndex;
    return InkWell(
      onTap: () => ref.read(activeTabProvider.notifier).state = index,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? ColorTokens.primaryAzure.withAlpha(38) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? ColorTokens.secondaryCyan : ColorTokens.textSecondary, size: 20),
            const SizedBox(width: 12),
            Text(label, style: TextStyle(color: isSelected ? Colors.white : ColorTokens.textSecondary, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}
