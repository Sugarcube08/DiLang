import 'package:flutter/material.dart';
import 'package:dilang_application/application.dart';
import 'package:dilang_product_ui/product_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = await AppLifecycleController.createDefault();
  await controller.bootPlatform();

  runApp(DiLangLanguageOsApp(controller: controller));
}

class DiLangLanguageOsApp extends StatelessWidget {
  final AppLifecycleController controller;

  const DiLangLanguageOsApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    const todayState = TodayDashboardState();
    final foodGraph = VocabularyKnowledgeGraph.sampleFoodGraph();

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
      home: Scaffold(
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
                      'v3.0.0-rc1 • Personal Language OS',
                      style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const _NavItem(icon: Icons.today, label: 'TODAY', isSelected: true),
                  const _NavItem(icon: Icons.hub, label: 'Vocabulary Web'),
                  const _NavItem(icon: Icons.record_voice_over, label: 'Voice AI Dialogue'),
                  const _NavItem(icon: Icons.health_and_safety, label: 'Language Health'),
                  const _NavItem(icon: Icons.auto_awesome, label: 'AI Engine Setup'),
                  const _NavItem(icon: Icons.settings, label: 'Settings'),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF172033),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 6,
                          backgroundColor: Color(0xFF22C55E),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Kernel: ${controller.kernel.state.name}',
                            style: const TextStyle(fontSize: 12, color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // TODAY Workspace Area
            Expanded(
              child: SingleChildScrollView(
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
                            Text(
                              'Good Morning, ${todayState.learnerName}',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'German (de-DE) • Streak: 32 Days 🔥',
                              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.play_arrow, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                "Today's Mission: Conversation",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // WHOOP-Style Daily Scorecard Section
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
                          child: _ScorecardTile(
                            label: 'Learning Load',
                            value: todayState.scorecard.learningLoad,
                            subtitle: 'Target Balance',
                            color: const Color(0xFF22C55E),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _ScorecardTile(
                            label: 'Memory Gain',
                            value: '+${todayState.scorecard.memoryGainPercent}%',
                            subtitle: 'FSRS Stability Boost',
                            color: const Color(0xFF3B82F6),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _ScorecardTile(
                            label: 'Pronunciation',
                            value: '+${todayState.scorecard.pronunciationGainPercent}%',
                            subtitle: 'Phonetic Accuracy',
                            color: const Color(0xFF22D3EE),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _ScorecardTile(
                            label: 'Vocabulary',
                            value: '+${todayState.scorecard.vocabularyCountGained}',
                            subtitle: 'New Mastered Nodes',
                            color: const Color(0xFF8B5CF6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // 30-Day Progress Story & Vocabulary Web Split
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 30-Day Narrative Story
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: const Color(0xFF172033),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFF1E293B)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.auto_stories, color: Color(0xFF38BDF8)),
                                    SizedBox(width: 10),
                                    Text(
                                      '30-Day Language Evolution Story',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'You have learned ${todayState.narrative.totalWordsLearned} words.',
                                  style: const TextStyle(fontSize: 16, color: Colors.white),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'You can now understand ${(todayState.narrative.comprehensionPercentage * 100).toInt()}% of everyday German.',
                                  style: const TextStyle(fontSize: 15, color: Color(0xFF38BDF8), fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    _TagChip(label: 'Estimated CEFR: ${todayState.narrative.estimatedCefr}', color: const Color(0xFF8B5CF6)),
                                    const SizedBox(width: 8),
                                    _TagChip(label: 'Strongest: ${todayState.narrative.strongestSkill}', color: const Color(0xFF22C55E)),
                                    const SizedBox(width: 8),
                                    _TagChip(label: 'Weakest: ${todayState.narrative.weakestSkill}', color: const Color(0xFFEF4444)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),

                        // Personal Language Knowledge Graph (Vocabulary Web)
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: const Color(0xFF172033),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFF1E293B)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.hub, color: Color(0xFF8B5CF6)),
                                    SizedBox(width: 10),
                                    Text(
                                      'Personal Vocabulary Web',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Column(
                                  children: foodGraph.nodes
                                      .map((node) => Container(
                                            margin: const EdgeInsets.only(bottom: 8),
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF0B1020),
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: const Color(0xFF334155)),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      node.word,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${node.translation} • ${node.ipaPronunciation}',
                                                      style: const TextStyle(
                                                        color: Color(0xFF94A3B8),
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  'FSRS: ${node.fsrsStabilityDays}d',
                                                  style: const TextStyle(
                                                    color: Color(0xFF22C55E),
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _ScorecardTile extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final Color color;

  const _ScorecardTile({
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

class _TagChip extends StatelessWidget {
  final String label;
  final Color color;

  const _TagChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
