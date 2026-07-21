import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dilang_application/application.dart';
import 'package:dilang_conversation/conversation.dart';
import '../providers/di_providers.dart';

class DiLangAppEntry extends ConsumerWidget {
  const DiLangAppEntry({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runtimeState = ref.watch(dilangRuntimeKernelProvider);

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
      home: !runtimeState.isBootstrapped
          ? const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color(0xFF3B82F6)),
                    SizedBox(height: 16),
                    Text('Initializing DiLang Authoritative Runtime Kernel...', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            )
          : runtimeState.isOnboardingRequired
              ? const FtueWizardScreen()
              : const TodayDashboardMainShell(),
    );
  }
}

class FtueWizardScreen extends ConsumerStatefulWidget {
  const FtueWizardScreen({super.key});

  @override
  ConsumerState<FtueWizardScreen> createState() => _FtueWizardScreenState();
}

class _FtueWizardScreenState extends ConsumerState<FtueWizardScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Learner');
  String _mediumLanguage = 'English';
  String _targetLanguage = 'German';
  String _brainModel = 'Conversation First';
  String _learningGoal = 'Daily Conversation';
  String _aiCoachPersona = 'Friendly';

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
            width: 540,
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
                const Row(
                  children: [
                    Icon(Icons.psychology, color: Color(0xFF3B82F6), size: 32),
                    SizedBox(width: 12),
                    Text(
                      'DiLang Companion Setup',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Configure your learner identity, brain model, and target language.',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                ),
                const SizedBox(height: 20),

                // 1. Learner Name Input
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Learner Name',
                    hintText: 'Enter your name or nickname',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // 2. Medium & Target Language Selection
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Medium (Interface) Language', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: _mediumLanguage,
                            items: const [
                              DropdownMenuItem(value: 'English', child: Text('English', overflow: TextOverflow.ellipsis)),
                              DropdownMenuItem(value: 'Spanish', child: Text('Spanish', overflow: TextOverflow.ellipsis)),
                              DropdownMenuItem(value: 'French', child: Text('French', overflow: TextOverflow.ellipsis)),
                              DropdownMenuItem(value: 'Hindi', child: Text('Hindi', overflow: TextOverflow.ellipsis)),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _mediumLanguage = val);
                            },
                            decoration: const InputDecoration(border: OutlineInputBorder()),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Target Language', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: _targetLanguage,
                            items: const [
                              DropdownMenuItem(value: 'German', child: Text('German (DE)', overflow: TextOverflow.ellipsis)),
                              DropdownMenuItem(value: 'French', child: Text('French (FR)', overflow: TextOverflow.ellipsis)),
                              DropdownMenuItem(value: 'Spanish', child: Text('Spanish (ES)', overflow: TextOverflow.ellipsis)),
                              DropdownMenuItem(value: 'Japanese', child: Text('Japanese (JP)', overflow: TextOverflow.ellipsis)),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _targetLanguage = val);
                            },
                            decoration: const InputDecoration(border: OutlineInputBorder()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 3. Brain Model (Cognitive Strategy)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Brain Model (Cognitive Strategy)', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: _brainModel,
                      items: const [
                        DropdownMenuItem(value: 'Conversation First', child: Text('Conversation First', overflow: TextOverflow.ellipsis)),
                        DropdownMenuItem(value: 'Grammar First', child: Text('Grammar First', overflow: TextOverflow.ellipsis)),
                        DropdownMenuItem(value: 'Vocabulary First', child: Text('Vocabulary First', overflow: TextOverflow.ellipsis)),
                        DropdownMenuItem(value: 'Visual', child: Text('Visual & Interactive Graph', overflow: TextOverflow.ellipsis)),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _brainModel = val);
                      },
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 4. Learning Goal & AI Coach Persona
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Learning Goal', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: _learningGoal,
                            items: const [
                              DropdownMenuItem(value: 'Daily Conversation', child: Text('Daily Conversation', overflow: TextOverflow.ellipsis)),
                              DropdownMenuItem(value: 'Travel', child: Text('Travel & Food', overflow: TextOverflow.ellipsis)),
                              DropdownMenuItem(value: 'Business', child: Text('Business', overflow: TextOverflow.ellipsis)),
                              DropdownMenuItem(value: 'Exam', child: Text('CEFR Certification', overflow: TextOverflow.ellipsis)),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _learningGoal = val);
                            },
                            decoration: const InputDecoration(border: OutlineInputBorder()),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('AI Coach Persona', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: _aiCoachPersona,
                            items: const [
                              DropdownMenuItem(value: 'Friendly', child: Text('Friendly', overflow: TextOverflow.ellipsis)),
                              DropdownMenuItem(value: 'Strict', child: Text('Strict Precision', overflow: TextOverflow.ellipsis)),
                              DropdownMenuItem(value: 'Socratic', child: Text('Socratic', overflow: TextOverflow.ellipsis)),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _aiCoachPersona = val);
                            },
                            decoration: const InputDecoration(border: OutlineInputBorder()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 5. Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () async {
                      final name = _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : 'Learner';
                      await ref.read(dilangRuntimeKernelProvider.notifier).createProfile(
                            name: name,
                            mediumLanguage: _mediumLanguage,
                            targetLanguage: _targetLanguage,
                            brainModel: _brainModel,
                            learningGoal: _learningGoal,
                            aiCoachPersona: _aiCoachPersona,
                          );
                    },
                    child: const Text('Initialize DiLang Engine & Start Mission #1 →', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
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

class TodayDashboardMainShell extends ConsumerWidget {
  const TodayDashboardMainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(activeTabProvider);
    final runtimeState = ref.watch(dilangRuntimeKernelProvider);

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
                    'v2.0-beta • Single Authoritative Kernel',
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

          // Workspace Content Switcher Reading 100% from Authoritative Kernel State
          Expanded(
            child: _buildWorkspaceRoute(activeTab, runtimeState, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkspaceRoute(
    int activeTab,
    DiLangRuntimeState runtimeState,
    WidgetRef ref,
  ) {
    switch (activeTab) {
      case 1:
        return const VocabularyGraphSection();
      case 2:
        return const VoiceDialogueSection();
      case 3:
        return const LanguageHealthSection();
      case 4:
        return const SettingsSection();
      case 0:
      default:
        final name = runtimeState.learner?.profile.displayName ?? 'Learner';
        final targetLang = runtimeState.learner?.primaryLanguageProfile?.targetLanguage ?? 'German';
        final streak = runtimeState.currentStreak;
        final overallScore = (runtimeState.cognitiveModel.calculateOverallHealth() * 100).round();
        final vocabScore = (runtimeState.cognitiveModel.vocabularyMastery * 100).round();
        final grammarScore = (runtimeState.cognitiveModel.grammarMastery * 100).round();
        final recallScore = (runtimeState.cognitiveModel.recallStability * 100).round();

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
                        'Willkommen, $name',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$targetLang (A1) • Streak: $streak Days 🔥 • Completed Sessions: ${runtimeState.completedSessionsCount}',
                        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      ref.read(dilangRuntimeKernelProvider.notifier).startSession(BuiltInScenarios.ScenarioCafeVienna);
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
                            "Today's Mission: ${runtimeState.activeScenario.title}",
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
                "AUTHORITATIVE RUNTIME SCORECARD",
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
                      value: '$overallScore%',
                      subtitle: overallScore > 0 ? 'Optimal' : 'Clean Initial State',
                      color: const Color(0xFF22C55E),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ScoreTile(
                      label: 'Vocabulary',
                      value: '$vocabScore%',
                      subtitle: 'FSRS Stability',
                      color: const Color(0xFF3B82F6),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ScoreTile(
                      label: 'Grammar',
                      value: '$grammarScore%',
                      subtitle: 'Syntax Accuracy',
                      color: const Color(0xFF22D3EE),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ScoreTile(
                      label: 'Recall Stability',
                      value: '$recallScore%',
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
                        runtimeState.completedSessionsCount == 0
                            ? 'Welcome! Complete your first session ("Ordering at a Viennese Café") to seed your FSRS memory and cognitive intelligence engine.'
                            : 'Great progress! Your completed session replay has been persisted to SQLite, updating your cognitive model.',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
    }
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

class VocabularyGraphSection extends ConsumerWidget {
  const VocabularyGraphSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runtimeState = ref.watch(dilangRuntimeKernelProvider);
    final graph = runtimeState.knowledgeGraph;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Universal Knowledge Graph', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 4),
          Text('Live Runtime Graph for ${runtimeState.learner?.primaryLanguageProfile?.targetLanguage ?? "German"}', style: const TextStyle(color: Color(0xFF94A3B8))),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: graph.allNodes.length,
              itemBuilder: (context, idx) {
                final node = graph.allNodes[idx];
                return Card(
                  color: const Color(0xFF172033),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(node.label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text('Type: ${node.type.name} • CEFR Level: ${node.cefrLevel}', style: const TextStyle(color: Colors.white70)),
                    trailing: Text('ID: ${node.id}', style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.w600)),
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

  Future<void> _handleTurnSubmit() async {
    final text = _inputController.text.trim();
    if (text.isNotEmpty) {
      _inputController.clear();
      await ref.read(dilangRuntimeKernelProvider.notifier).submitTurn(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final runtimeState = ref.watch(dilangRuntimeKernelProvider);
    final scenario = runtimeState.activeScenario;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Scenario Switcher Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Voice AI Dialogue: ${scenario.title}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white), overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text('Persona: ${scenario.personaName} (${scenario.personaRole}) • CEFR ${scenario.cefrLevel}', style: const TextStyle(color: Color(0xFF94A3B8)), overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Row(
                children: [
                  DropdownButton<String>(
                    value: scenario.id,
                    dropdownColor: const Color(0xFF172033),
                    items: [
                      DropdownMenuItem(
                        value: BuiltInScenarios.ScenarioCafeVienna.id,
                        child: Text(BuiltInScenarios.ScenarioCafeVienna.title, style: const TextStyle(color: Colors.white)),
                      ),
                      DropdownMenuItem(
                        value: BuiltInScenarios.ScenarioDoctorAppointment.id,
                        child: Text(BuiltInScenarios.ScenarioDoctorAppointment.title, style: const TextStyle(color: Colors.white)),
                      ),
                    ],
                    onChanged: (id) {
                      if (id == BuiltInScenarios.ScenarioDoctorAppointment.id) {
                        ref.read(dilangRuntimeKernelProvider.notifier).startSession(BuiltInScenarios.ScenarioDoctorAppointment);
                      } else {
                        ref.read(dilangRuntimeKernelProvider.notifier).startSession(BuiltInScenarios.ScenarioCafeVienna);
                      }
                    },
                  ),
                  const SizedBox(width: 16),
                  if (runtimeState.isSessionActive)
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF22C55E)),
                      onPressed: () async {
                        await ref.read(dilangRuntimeKernelProvider.notifier).completeSession();
                      },
                      icon: const Icon(Icons.check_circle, color: Colors.white),
                      label: const Text('Finish Session & Save Replay →', style: TextStyle(color: Colors.white)),
                    ),
                ],
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
                    'Pre-Session Coach: ${runtimeState.activeBriefing.preSessionCoaching} Cultural Tip: ${runtimeState.activeBriefing.culturalTip}',
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Debriefing Evidence Card if completed
          if (runtimeState.isSessionCompleted && runtimeState.activeDebriefing != null) ...[
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
                  Text(runtimeState.activeDebriefing!.evidenceSummary, style: const TextStyle(color: Color(0xFFA7F3D0), fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(runtimeState.activeDebriefing!.postSessionCoaching, style: const TextStyle(color: Colors.white70, fontSize: 13)),
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
              child: runtimeState.activeTurns.isEmpty
                  ? const Center(
                      child: Text(
                        'Type your response below (e.g. "Ich möchte einen Kaffee, bitte.") to begin turn execution!',
                        style: TextStyle(color: Colors.white54),
                      ),
                    )
                  : ListView.builder(
                      itemCount: runtimeState.activeTurns.length,
                      itemBuilder: (context, index) {
                        final turn = runtimeState.activeTurns[index];
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
                              Text('${scenario.personaName}: ${turn.tutorPrompt}', style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.w600)),
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

class LanguageHealthSection extends ConsumerWidget {
  const LanguageHealthSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runtimeState = ref.watch(dilangRuntimeKernelProvider);
    final model = runtimeState.cognitiveModel;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Language Health & Cognitive Diagnostics', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 4),
          Text('Live Runtime Diagnostics for ${runtimeState.learner?.profile.displayName ?? "Learner"}', style: const TextStyle(color: Color(0xFF94A3B8))),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _HealthMetricCard(title: 'Vocabulary Mastery', value: '${(model.vocabularyMastery * 100).round()}%', color: const Color(0xFF3B82F6))),
              const SizedBox(width: 16),
              Expanded(child: _HealthMetricCard(title: 'Grammar Accuracy', value: '${(model.grammarMastery * 100).round()}%', color: const Color(0xFF22D3EE))),
              const SizedBox(width: 16),
              Expanded(child: _HealthMetricCard(title: 'Recall Stability', value: '${(model.recallStability * 100).round()}%', color: const Color(0xFF8B5CF6))),
              const SizedBox(width: 16),
              Expanded(child: _HealthMetricCard(title: 'CEFR Readiness', value: '${(model.estimatedCefrReadiness * 100).round()}% A1', color: const Color(0xFF22C55E))),
            ],
          ),
        ],
      ),
    );
  }
}

class _HealthMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _HealthMetricCard({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF172033),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

class SettingsSection extends ConsumerStatefulWidget {
  const SettingsSection({super.key});

  @override
  ConsumerState<SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends ConsumerState<SettingsSection> {
  late TextEditingController _nameController;
  late String _mediumLanguage;
  late String _targetLanguage;
  late String _brainModel;
  late String _aiCoachPersona;

  @override
  void initState() {
    super.initState();
    final user = ref.read(dilangRuntimeKernelProvider).learner;
    _nameController = TextEditingController(text: user?.profile.displayName ?? 'Learner');
    _mediumLanguage = user?.profile.nativeLanguage ?? 'English';
    _targetLanguage = user?.primaryLanguageProfile?.targetLanguage ?? 'German';
    _brainModel = user?.primaryLanguageProfile?.brainModel ?? 'Conversation First';
    _aiCoachPersona = user?.primaryLanguageProfile?.aiCoachPersona ?? 'Friendly';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final runtimeState = ref.watch(dilangRuntimeKernelProvider);
    final user = runtimeState.learner;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('System & Learner Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          const Text('Edit learner profile identity, swap target language, or manage system state.', style: TextStyle(color: Color(0xFF94A3B8))),
          const SizedBox(height: 24),

          // 1. Learner Profile Configuration Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF172033),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('LEARNER IDENTITY & COGNITIVE MODEL', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8), letterSpacing: 1.1)),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Display Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Medium (Interface) Language', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: _mediumLanguage,
                            items: const [
                              DropdownMenuItem(value: 'English', child: Text('English')),
                              DropdownMenuItem(value: 'Spanish', child: Text('Spanish')),
                              DropdownMenuItem(value: 'French', child: Text('French')),
                              DropdownMenuItem(value: 'Hindi', child: Text('Hindi')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _mediumLanguage = val);
                            },
                            decoration: const InputDecoration(border: OutlineInputBorder()),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Target Language (Swaps Graph & Scenarios)', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: _targetLanguage,
                            items: const [
                              DropdownMenuItem(value: 'German', child: Text('German (DE)')),
                              DropdownMenuItem(value: 'French', child: Text('French (FR)')),
                              DropdownMenuItem(value: 'Spanish', child: Text('Spanish (ES)')),
                              DropdownMenuItem(value: 'Japanese', child: Text('Japanese (JP)')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _targetLanguage = val);
                            },
                            decoration: const InputDecoration(border: OutlineInputBorder()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Brain Model (Cognitive Focus)', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: _brainModel,
                            items: const [
                              DropdownMenuItem(value: 'Conversation First', child: Text('Conversation First')),
                              DropdownMenuItem(value: 'Grammar First', child: Text('Grammar First')),
                              DropdownMenuItem(value: 'Vocabulary First', child: Text('Vocabulary First')),
                              DropdownMenuItem(value: 'Visual', child: Text('Visual & Interactive Graph')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _brainModel = val);
                            },
                            decoration: const InputDecoration(border: OutlineInputBorder()),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('AI Coach Persona', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: _aiCoachPersona,
                            items: const [
                              DropdownMenuItem(value: 'Friendly', child: Text('Friendly')),
                              DropdownMenuItem(value: 'Strict', child: Text('Strict Precision')),
                              DropdownMenuItem(value: 'Socratic', child: Text('Socratic')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _aiCoachPersona = val);
                            },
                            decoration: const InputDecoration(border: OutlineInputBorder()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3B82F6), minimumSize: const Size(200, 48)),
                  onPressed: () async {
                    await ref.read(dilangRuntimeKernelProvider.notifier).updateSettings(
                          displayName: _nameController.text.trim(),
                          nativeLanguage: _mediumLanguage,
                          targetLanguage: _targetLanguage,
                          brainModel: _brainModel,
                          aiCoachPersona: _aiCoachPersona,
                        );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile identity and target language updated instantly across all views!')),
                      );
                    }
                  },
                  icon: const Icon(Icons.sync, color: Colors.white),
                  label: const Text('Save & Synchronize Runtime →', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 2. System Operations & Maintenance Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF172033),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('SYSTEM OPERATIONS & AUTHENTICATION', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFF59E0B), letterSpacing: 1.1)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF475569), minimumSize: const Size(180, 48)),
                      onPressed: () async {
                        await ref.read(dilangRuntimeKernelProvider.notifier).softLogout();
                      },
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text('Soft Logout (Switch Profile)', style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626), minimumSize: const Size(180, 48)),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: const Color(0xFF172033),
                            title: const Text('Confirm Factory Reset', style: TextStyle(color: Colors.white)),
                            content: const Text(
                              'This will permanently delete your SQLite database (~/.local/share/dilang/dilang_storage.db), wipe all learner identity records, session replays, and cognitive models, and restart fresh onboarding.',
                              style: TextStyle(color: Colors.white70),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626)),
                                onPressed: () async {
                                  Navigator.of(ctx).pop();
                                  await ref.read(dilangRuntimeKernelProvider.notifier).factoryReset();
                                },
                                child: const Text('Factory Reset & Delete Data', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete_forever, color: Colors.white),
                      label: const Text('Factory Reset (Wipe Database)', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Active Profile ID: ${user?.id.value ?? "None"}', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                const Text('SQLite Database Location: ~/.local/share/dilang/dilang_storage.db', style: TextStyle(color: Color(0xFF10B981), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
