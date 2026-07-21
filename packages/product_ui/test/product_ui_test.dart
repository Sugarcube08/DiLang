import 'package:test/test.dart';
import 'package:dilang_product_ui/product_ui.dart';

void main() {
  group('Product UI State, Journeys, Beta & Content Validation Tests', () {
    test('1. DashboardUiState initializes with default values', () {
      const state = DashboardUiState();
      expect(state.recommendations, isEmpty);
      expect(state.isLoading, isFalse);
    });

    test('2. FirstLaunchJourneyController tracks onboarding workflow', () {
      final controller = FirstLaunchJourneyController();
      expect(controller.state.step, equals(OnboardingStep.welcome));

      controller.selectLanguage('de-DE');
      expect(controller.state.step, equals(OnboardingStep.modelDownload));

      controller.updateDownloadProgress(1.0);
      expect(controller.state.step, equals(OnboardingStep.ready));
      expect(controller.state.isComplete, isTrue);
    });

    test('3. DailySessionJourneyController tracks session workflow state', () {
      final controller = DailySessionJourneyController();
      expect(controller.state.stage, equals(DailySessionStage.recommendation));

      controller.startSession([]);
      expect(controller.state.stage, equals(DailySessionStage.fsrsReview));

      controller.completeFsrsReviewStep();
      expect(controller.state.stage, equals(DailySessionStage.conversationDialogue));
    });

    test('4. UxPerformanceKpiReport evaluates performance metrics against targets', () {
      const report = UxPerformanceKpiReport(
        coldBootLatencyMs: 350.0,
        screenTransitionMs: 120.0,
        aiResponseLatencyMs: 1200.0,
        sessionCompletionRate: 0.85,
      );

      expect(report.passesKpiThresholds(), isTrue);
    });

    test('5. LearningTimelineController tracks chronological entries', () {
      final controller = LearningTimelineController();
      final entry = TimelineEntry(
        id: 't_1',
        timestamp: DateTime.now(),
        title: 'Reviewed 18 Words',
        description: 'FSRS Spaced Repetition',
        type: TimelineEntryType.review,
      );

      controller.addEntry(entry);
      expect(controller.state.entries.length, equals(1));
      expect(controller.state.entries.first.title, equals('Reviewed 18 Words'));

      controller.updateWeeklyGoalProgress(0.67);
      expect(controller.state.weeklyGoalProgress, closeTo(0.67, 0.01));
    });

    test('6. LanguageHealthMetrics computes aggregate overall health score', () {
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

    test('7. ClosedBetaReport validates beta release readiness gates', () {
      const report = ClosedBetaReport(
        crashFreeRate: 0.998,
        isOfflineVerified: true,
        buildVersion: '2.5.0-beta.1',
      );

      expect(report.passesBetaGates(), isTrue);
    });

    test('8. LanguagePackValidator validates language content pack manifest', () {
      final validator = LanguagePackValidator();
      const manifest = LanguagePackManifest(
        packId: 'de_a1_pack',
        targetLanguage: 'de-DE',
        version: '1.0.0',
        totalVocabularyEntries: 500,
        totalGrammarRules: 45,
      );

      expect(validator.validateManifest(manifest), isTrue);
    });

    test('9. BetaFeedbackController collects in-app bug and feedback reports', () {
      final controller = BetaFeedbackController();
      final report = controller.submitFeedback(
        feedbackText: 'Great onboarding flow!',
        hasScreenshot: true,
        logs: 'LogLevel.info',
      );

      expect(controller.submittedReports.length, equals(1));
      expect(report.feedbackText, equals('Great onboarding flow!'));
      expect(report.hasScreenshotAttached, isTrue);
    });
  });
}
