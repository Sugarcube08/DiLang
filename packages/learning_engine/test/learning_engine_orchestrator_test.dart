import 'package:test/test.dart';
import 'package:dilang_learning_engine/learning_engine.dart';

void main() {
  group('Learning Engine, Mission Generator & Session Engine Tests', () {
    test('1. MissionGenerator creates adaptive missions for 5m, 15m, and 30m slots', () {
      const generator = MissionGenerator();

      final m5 = generator.generateMission(
        targetLanguage: 'DE',
        cefrLevel: 'A1',
        dueReviewsCount: 14,
        timeSlot: AvailableTimeSlot.quick5Min,
      );
      expect(m5.totalDurationMinutes, equals(5));
      expect(m5.coaching.title, contains('Memory Curve Decay Alert'));

      final m15 = generator.generateMission(
        targetLanguage: 'DE',
        cefrLevel: 'A1',
        dueReviewsCount: 14,
        timeSlot: AvailableTimeSlot.standard15Min,
      );
      expect(m15.totalDurationMinutes, equals(15));
      expect(m15.coaching.title, contains('Case Confusion Coaching'));

      final m30 = generator.generateMission(
        targetLanguage: 'DE',
        cefrLevel: 'A1',
        dueReviewsCount: 14,
        timeSlot: AvailableTimeSlot.deep30Min,
      );
      expect(m30.totalDurationMinutes, equals(30));
      expect(m30.coaching.title, contains('CEFR Progression Boost'));
    });

    test('2. LearningSession executes complete state lifecycle', () {
      final session = LearningSession(
        sessionId: 'sess_101',
        sessionType: 'conversation',
        targetLanguage: 'de',
      );

      expect(session.state, equals(SessionLifecycleState.idle));

      session.start();
      expect(session.state, equals(SessionLifecycleState.started));

      session.pause();
      expect(session.state, equals(SessionLifecycleState.paused));

      session.resume();
      expect(session.state, equals(SessionLifecycleState.resumed));

      session.complete(const SessionResultMetrics(
        totalItemsAttempted: 10,
        totalSuccesses: 9,
        durationSeconds: 720,
        accuracyRatio: 0.9,
        retentionGain: 0.05,
      ));
      expect(session.state, equals(SessionLifecycleState.completed));
      expect(session.metrics?.accuracyRatio, equals(0.9));

      session.evaluate();
      expect(session.state, equals(SessionLifecycleState.evaluated));

      session.persist();
      expect(session.state, equals(SessionLifecycleState.persisted));
    });
  });
}
