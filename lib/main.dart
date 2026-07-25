import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/dependency_injection/providers.dart';
import 'app/bootstrap/bootstrap_pipeline.dart';
import 'app/bootstrap/runtime_health_screen.dart';
import 'shared/theme/dilang_theme.dart';
import 'shared/theme/color_tokens.dart';
import 'shared/theme/typography.dart';
import 'modules/design_system/pages/component_gallery_page.dart';
import 'modules/identity/pages/onboarding_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BootstrapPipeline.initialize();

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
    final runtimeState = ref.watch(runtimeProvider);

    return MaterialApp(
      title: 'DiLang — Personal Language OS',
      debugShowCheckedModeBanner: false,
      theme: DiLangTheme.darkTheme,
      home: !runtimeState.isBootstrapped
          ? const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: ColorTokens.azure500),
                    SizedBox(height: 16),
                    Text('Bootstrapping DiLang Runtime Kernel & SQLite Database...', style: TextStyle(color: ColorTokens.slate400)),
                  ],
                ),
              ),
            )
          : runtimeState.isOnboardingRequired
              ? const OnboardingPage()
              : const AppShellScreen(),
    );
  }
}

class AppShellScreen extends ConsumerWidget {
  const AppShellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(activeTabProvider);
    final runtimeState = ref.watch(runtimeProvider);

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
                    Icon(Icons.psychology, color: ColorTokens.azure500, size: 28),
                    SizedBox(width: 8),
                    Text('DiLang OS', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 24),
                _NavTile(icon: Icons.today, label: 'TODAY', index: 0, activeIndex: activeTab),
                _NavTile(icon: Icons.monitor_heart, label: 'Runtime Health', index: 1, activeIndex: activeTab),
                _NavTile(icon: Icons.palette, label: 'UI Gallery', index: 2, activeIndex: activeTab),
                _NavTile(icon: Icons.settings, label: 'Settings', index: 3, activeIndex: activeTab),
              ],
            ),
          ),
          Expanded(
            child: activeTab == 1
                ? const RuntimeHealthScreen()
                : activeTab == 2
                    ? const ComponentGalleryPage()
                    : Padding(
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
                                color: ColorTokens.slate800,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: ColorTokens.slate700),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('SINGLE RUNTIME & SQLITE ENGINE ONLINE', style: TypographyTokens.labelSmall),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Database Path: ~/.local/share/dilang/dilang_storage.db',
                                    style: TextStyle(color: ColorTokens.emerald500, fontSize: 13),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(backgroundColor: ColorTokens.coralRed500),
                                    onPressed: () async {
                                      await ref.read(runtimeProvider.notifier).factoryReset();
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
          color: isSelected ? ColorTokens.azure500.withAlpha(38) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? ColorTokens.cyan400 : ColorTokens.slate400, size: 20),
            const SizedBox(width: 12),
            Text(label, style: TextStyle(color: isSelected ? Colors.white : ColorTokens.slate400, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}
