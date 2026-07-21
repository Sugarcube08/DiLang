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
                    'v1.2.0-alpha • Personal Language OS',
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
                            onTap: () {
                              ref
                                  .read(interactiveDialogueNotifierProvider.notifier)
                                  .startSession(BuiltInScenarios.ScenarioCafeVienna);
                              ref.read(activeTabProvider.notifier).state = 2;
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

class VoiceDialogueSection extends ConsumerStatefulWidget {
  const VoiceDialogueSection({super.key});

  @override
  ConsumerState<VoiceDialogueSection> createState() => _VoiceDialogueSectionState();
}

class _VoiceDialogueSectionState extends ConsumerState<VoiceDialogueSection> {
  final TextEditingController _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _handleTurnSubmit() {
    final text = _inputController.text.trim();
    if (text.isNotEmpty) {
      ref.read(interactiveDialogueNotifierProvider.notifier).submitTurn(learnerInput: text);
      _inputController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dialogueState = ref.watch(interactiveDialogueNotifierProvider);
    final scenario = dialogueState.scenario;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Voice AI Dialogue: ${scenario.title}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('Persona: ${scenario.personaName} (${scenario.personaRole}) • CEFR ${scenario.cefrLevel}', style: const TextStyle(color: Color(0xFF94A3B8))),
                ],
              ),
              if (dialogueState.isSessionActive)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF22C55E)),
                  onPressed: () async {
                    await ref.read(interactiveDialogueNotifierProvider.notifier).completeSession();
                  },
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  label: const Text('Finish Session & Save Replay →', style: TextStyle(color: Colors.white)),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Pre-Session Briefing Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF172033),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb, color: Color(0xFFF59E0B)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Pre-Session Coach: ${dialogueState.briefing.preSessionCoaching} Cultural Tip: ${dialogueState.briefing.culturalTip}',
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Debriefing Evidence Card if completed
          if (dialogueState.isCompleted && dialogueState.debriefing != null) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF064E3B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF10B981)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Session Completed & Replay Persisted to SQLite!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(dialogueState.debriefing!.evidenceSummary, style: const TextStyle(color: Color(0xFFA7F3D0), fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(dialogueState.debriefing!.postSessionCoaching, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Turn-by-Turn Live Chat Area
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0B1020),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: dialogueState.turns.isEmpty
                  ? const Center(
                      child: Text(
                        'Type your response below (e.g. "Ich möchte einen Kaffee, bitte.") to begin turn execution!',
                        style: TextStyle(color: Colors.white54),
                      ),
                    )
                  : ListView.builder(
                      itemCount: dialogueState.turns.length,
                      itemBuilder: (context, index) {
                        final turn = dialogueState.turns[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF172033),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFF334155)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Greta (Tutor): ${turn.tutorPrompt}', style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text('You: ${turn.learnerResponse}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('Grammar Analysis: ${turn.grammarNote}', style: const TextStyle(color: Color(0xFFF59E0B), fontSize: 12)),
                              Text('Phonetic Accuracy: ${turn.phoneticScore.round()}%', style: const TextStyle(color: Color(0xFF22C55E), fontSize: 12)),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
          const SizedBox(height: 16),

          // Interactive Input Bar
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _inputController,
                  decoration: const InputDecoration(
                    hintText: 'Type German response (e.g., "Ich möchte einen Kaffee, bitte")...',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _handleTurnSubmit(),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  minimumSize: const Size(140, 56),
                ),
                onPressed: _handleTurnSubmit,
                icon: const Icon(Icons.send, color: Colors.white),
                label: const Text('Evaluate Turn', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
