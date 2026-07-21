import 'package:test/test.dart';
import 'package:dilang_product_ui/product_ui.dart';

void main() {
  group('Language OS Product UI State & Journey Tests', () {
    test('1. FirstRunOnboardingController tracks zero-cognitive-jargon onboarding', () {
      final controller = FirstRunOnboardingController();
      expect(controller.state.stage, equals(OnboardingStage.splash));

      controller.proceedFromSplash();
      expect(controller.state.stage, equals(OnboardingStage.welcome));

      controller.createIdentity('harsh_learner', 'harsh@dilang.ai');
      expect(controller.state.username, equals('harsh_learner'));

      controller.selectGoalAndLevel('Conversation', 'B1');
      expect(controller.state.stage, equals(OnboardingStage.aiEngineSetup));

      controller.downloadAiEngine(1.0);
      expect(controller.state.isAiEngineReady, isTrue);
    });

    test('2. TodayDashboardState exposes WHOOP Scorecard & 30-Day Narrative', () {
      const today = TodayDashboardState();
      expect(today.scorecard.learningLoad, equals('Optimal'));
      expect(today.scorecard.memoryGainPercent, equals(2.8));
      expect(today.narrative.comprehensionPercentage, equals(0.78));
      expect(today.narrative.strongestSkill, equals('Reading'));
    });

    test('3. VocabularyKnowledgeGraph constructs connected word graph', () {
      final sampleGraph = VocabularyKnowledgeGraph.sampleFoodGraph();
      expect(sampleGraph.nodes.length, equals(4));
      expect(sampleGraph.edges.length, equals(3));
      expect(sampleGraph.nodes.first.word, equals('Essen'));
    });

    test('4. LanguageHealthMetrics computes aggregate overall health score', () {
      const health = LanguageHealthMetrics(
        vocabularyHealth: 0.84,
        grammarHealth: 0.89,
        speakingHealth: 0.73,
        listeningHealth: 0.81,
        readingHealth: 0.95,
        writingHealth: 0.69,
        conversationHealth: 0.78,
        memoryHealth: 0.93,
      );

      final overall = health.calculateOverallHealth();
      expect(overall, closeTo(0.8275, 0.01));
    });
  });
}
