import 'package:flutter/material.dart';
import 'package:dilang_application/application.dart';
import 'package:dilang_design_system/design_system.dart';
import 'package:dilang_product_ui/product_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = await AppLifecycleController.createDefault();
  await controller.bootPlatform();

  runApp(DiLangDesktopApp(controller: controller));
}

class DiLangDesktopApp extends StatelessWidget {
  final AppLifecycleController controller;

  const DiLangDesktopApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    const health = LanguageHealthMetrics();
    final timelineController = LearningTimelineController()
      ..addEntry(
        TimelineEntry(
          id: '1',
          timestamp: DateTime.now(),
          title: 'Reviewed 18 Vocabulary Items',
          description: 'FSRS-4.5 Memory Recall (Stability +2.4d)',
          type: TimelineEntryType.review,
        ),
      )
      ..addEntry(
        TimelineEntry(
          id: '2',
          timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
          title: 'B1 Dialogue: Ordering Food',
          description: 'Local Voice Conversation (Whisper STT + Qwen 1B)',
          type: TimelineEntryType.conversation,
        ),
      );

    return MaterialApp(
      title: 'DiLang — Offline AI Language Acquisition',
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
                        'DiLang',
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
                      'v2.5.0-beta • Offline Local AI',
                      style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const _NavItem(icon: Icons.dashboard, label: 'Dashboard', isSelected: true),
                  const _NavItem(icon: Icons.school, label: 'Learn'),
                  const _NavItem(icon: Icons.record_voice_over, label: 'Conversation'),
                  const _NavItem(icon: Icons.style, label: 'Review Queue'),
                  const _NavItem(icon: Icons.bar_chart, label: 'Progress & Health'),
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

            // Main Content Area
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
                          children: const [
                            Text(
                              'Guten Tag, Learner!',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'German (de-DE) • CEFR Target B1.2',
                              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                                'Start Recommended Session',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Health Metric Cards Row
                    Row(
                      children: [
                        Expanded(
                          child: _MetricCard(
                            title: 'Overall Language Health',
                            value: '${(health.calculateOverallHealth() * 100).toInt()}%',
                            subtitle: '8 Core Modalities',
                            color: const Color(0xFF3B82F6),
                            icon: Icons.health_and_safety,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _MetricCard(
                            title: 'Vocabulary Health',
                            value: '${(health.vocabularyHealth * 100).toInt()}%',
                            subtitle: 'FSRS Retention: High',
                            color: const Color(0xFF22C55E),
                            icon: Icons.translate,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _MetricCard(
                            title: 'Grammar Health',
                            value: '${(health.grammarHealth * 100).toInt()}%',
                            subtitle: 'V2 Syntax Mastered',
                            color: const Color(0xFF22D3EE),
                            icon: Icons.menu_book,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _MetricCard(
                            title: 'Memory Stability',
                            value: '${(health.memoryHealth * 100).toInt()}%',
                            subtitle: 'Predicted Retrievability',
                            color: const Color(0xFF8B5CF6),
                            icon: Icons.psychology,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Recommendation & Timeline Split
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Recommendation Feed
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
                                    Icon(Icons.auto_awesome, color: Color(0xFF3B82F6)),
                                    SizedBox(width: 10),
                                    Text(
                                      'Learning Engine Recommendation',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0B1020),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFF334155)),
                                  ),
                                  child: const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'FSRS Spaced Repetition Review',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF38BDF8),
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        'Reason: Retrievability dropped below 0.90 threshold for 3 vocabulary items.',
                                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),

                        // Learning Timeline
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
                                    Icon(Icons.history, color: Color(0xFF8B5CF6)),
                                    SizedBox(width: 10),
                                    Text(
                                      'Learning Timeline',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                ...timelineController.state.entries.map((entry) => Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0B1020),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            entry.title,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            entry.description,
                                            style: const TextStyle(
                                              color: Color(0xFF94A3B8),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
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

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final IconData icon;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF172033),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
