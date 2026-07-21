import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dilang_application/application.dart';
import 'package:dilang_conversation/conversation.dart';
import 'package:dilang_language/language.dart';
import '../providers/di_providers.dart';

class DiLangAppEntry extends ConsumerWidget {
  const DiLangAppEntry({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootAsync = ref.watch(bootstrapResultProvider);

    return MaterialApp(
      title: 'DiLang — Personal Language OS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B1020),
        primaryColor: const Color(0xFF3B82F6),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF3B82F6),
          secondary: Color(0xFF22D3EE),
          surface: Color(0xFF172033),
        ),
      ),
      home: bootAsync.when(
        data: (result) {
          if (result.status == BootstrapStatus.onboardingRequired) {
            return const FtueWizardScreen();
          }
          return const TodayDashboardMainShell();
        },
        loading: () => const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Color(0xFF3B82F6)),
                SizedBox(height: 16),
                Text(
                  'DiLang OS Bootstrapping Pipeline...',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        error: (err, stack) => Scaffold(
          body: Center(
            child: Text('Bootstrap Failure: $err', style: const TextStyle(color: Colors.red)),
          ),
        ),
      ),
    );
  }
}

class FtueWizardScreen extends ConsumerWidget {
  const FtueWizardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ftueState = ref.watch(ftueNotifierProvider);
    final notifier = ref.read(ftueNotifierProvider.notifier);

    return Scaffold(
      body: Center(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF172033),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'DiLang Onboarding Companion',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text(
                'Learn a language that stays with you forever.',
                style: TextStyle(color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => notifier.updateIdentity(val, 'pass123'),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Native: English', style: TextStyle(color: Colors.white70)),
                  ElevatedButton(
                    onPressed: () => notifier.setLanguages('English', 'German'),
                    child: const Text('Target: German (DE)'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                  ),
                  onPressed: () => notifier.completeOnboarding(),
                  child: const Text('Complete Setup & Start Learning →', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TodayDashboardMainShell extends ConsumerWidget {
  const TodayDashboardMainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(activeTabProvider);
    final vmAsync = ref.watch(todayDashboardNotifierProvider);

    return Scaffold(
      body: Row(
        children: [
          // Sidebar Navigation
          Container(
            width: 240,
            color: const Color(0xFF111827),
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.psychology, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'DiLang OS',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'v1.1.0-alpha • Personal Language OS',
                    style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                  ),
                ),
                const SizedBox(height: 32),
                _SidebarItem(icon: Icons.today, label: 'TODAY', index: 0, activeTab: activeTab),
                _SidebarItem(icon: Icons.hub, label: 'Vocabulary Web', index: 1, activeTab: activeTab),
                _SidebarItem(icon: Icons.record_voice_over, label: 'Voice AI Dialogue', index: 2, activeTab: activeTab),
                _SidebarItem(icon: Icons.health_and_safety, label: 'Language Health', index: 3, activeTab: activeTab),
                _SidebarItem(icon: Icons.settings, label: 'Settings', index: 4, activeTab: activeTab),
              ],
            ),
          ),

          // Workspace Content
          Expanded(
            child: vmAsync.when(
              data: (vm) {
                if (activeTab == 1) {
                  return const VocabularyGraphSection();
                } else if (activeTab == 2) {
                  return const VoiceDialogueSection();
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${vm.greeting}, ${vm.username}',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${vm.mission.targetLanguage} (${vm.mission.cefrLevel}) • Streak: ${vm.currentStreak} Days 🔥',
                                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () async {
                              await ref.read(todayDashboardNotifierProvider.notifier).recordSessionCompleted(
                                    sessionType: 'Conversation',
                                    title: vm.mission.subTitle,
                                    minutesSpent: vm.mission.estimatedMinutes,
                                  );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.play_arrow, color: Colors.white),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Today's Mission: ${vm.mission.title}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Scorecard Tiles
                      const Text(
                        "TODAY'S SCORECARD",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _ScoreTile(
                              label: 'Overall Health',
                              value: '${vm.health.overallScore}%',
                              subtitle: vm.health.statusText,
                              color: const Color(0xFF22C55E),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _ScoreTile(
                              label: 'Vocabulary',
                              value: '${vm.health.vocabularyScore}%',
                              subtitle: 'FSRS Retention',
                              color: const Color(0xFF3B82F6),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _ScoreTile(
                              label: 'Grammar',
                              value: '${vm.health.grammarScore}%',
                              subtitle: 'Accusative Focus',
                              color: const Color(0xFF22D3EE),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _ScoreTile(
                              label: 'Fluency',
                              value: '${vm.health.fluencyScore}%',
                              subtitle: 'Turn Confidence',
                              color: const Color(0xFF8B5CF6),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Single Coaching Insight
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF172033),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.lightbulb, color: Color(0xFFF59E0B)),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                vm.singleInsight,
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error loading dashboard: $err')),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends ConsumerWidget {
  final IconData icon;
  final String label;
  final int index;
  final int activeTab;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.activeTab,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = index == activeTab;

    return InkWell(
      onTap: () => ref.read(activeTabProvider.notifier).state = index,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3B82F6).withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isSelected ? Border.all(color: const Color(0xFF3B82F6)) : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF38BDF8) : const Color(0xFF94A3B8), size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreTile extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final Color color;

  const _ScoreTile({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF172033),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
        ],
      ),
    );
  }
}

class VocabularyGraphSection extends StatelessWidget {
  const VocabularyGraphSection({super.key});

  @override
  Widget build(BuildContext context) {
    final graph = UniversalKnowledgeGraph.createGermanA1Graph();

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Universal Knowledge Graph', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: graph.allNodes.length,
              itemBuilder: (context, idx) {
                final node = graph.allNodes[idx];
                return Card(
                  color: const Color(0xFF172033),
                  child: ListTile(
                    title: Text(node.label, style: const TextStyle(color: Colors.white)),
                    subtitle: Text('Type: ${node.type.name} • Level: ${node.cefrLevel}', style: const TextStyle(color: Colors.white70)),
                    trailing: Text('ID: ${node.id}', style: const TextStyle(color: Color(0xFF38BDF8))),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VoiceDialogueSection extends StatelessWidget {
  const VoiceDialogueSection({super.key});

  @override
  Widget build(BuildContext context) {
    final scenario = BuiltInScenarios.ScenarioCafeVienna;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Voice AI Dialogue: ${scenario.title}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Text('Persona: ${scenario.personaName} (${scenario.personaRole})', style: const TextStyle(color: Color(0xFF94A3B8))),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF172033),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('Cultural Note: ${scenario.culturalNote}', style: const TextStyle(color: Color(0xFFF59E0B))),
          ),
        ],
      ),
    );
  }
}
