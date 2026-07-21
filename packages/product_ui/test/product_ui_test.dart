import 'package:test/test.dart';
import 'package:dilang_product_ui/product_ui.dart';

void main() {
  group('Product UI State & User Journey Tests', () {
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
  });
}
