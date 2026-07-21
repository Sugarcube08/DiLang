import 'package:test/test.dart';
import 'package:dilang_memory/memory.dart';

void main() {
  group('Human Memory Engine (FSRS-4.5) Tests', () {
    final now = DateTime(2026, 7, 22, 12, 0);
    const engine = MemoryEngine();

    test('1. Initial review on new item sets stability & scheduled due date', () {
      final state = FsrsItemState.initial(now);

      final nextState = engine.processReview(
        currentState: state,
        rating: Rating.good,
        reviewTimestamp: now,
      );

      expect(nextState.reps, equals(1));
      expect(nextState.stability, equals(3.1)); // w2
      expect(nextState.due, equals(now.add(const Duration(days: 3))));
    });

    test('2. Successful recall increases stability and calculates retrievability decay', () {
      final initial = FsrsItemState.initial(now);
      final firstRev = engine.processReview(
        currentState: initial,
        rating: Rating.good,
        reviewTimestamp: now,
      );

      // Review 3 days later (when due)
      final reviewDate = now.add(const Duration(days: 3));
      final retrievabilityBeforeReview = engine.predictRetrievability(
        state: firstRev,
        currentTimestamp: reviewDate,
      );

      // At t=S, R(S, S) = (1 + 19/81)^-1 = 0.81
      expect(retrievabilityBeforeReview, closeTo(0.81, 0.02));

      final secondRev = engine.processReview(
        currentState: firstRev,
        rating: Rating.good,
        reviewTimestamp: reviewDate,
      );

      expect(secondRev.reps, equals(2));
      expect(secondRev.stability, greaterThan(firstRev.stability));
    });

    test('3. Rating.again increases lapses and resets stability factor', () {
      final initial = FsrsItemState.initial(now);
      final firstRev = engine.processReview(
        currentState: initial,
        rating: Rating.good,
        reviewTimestamp: now,
      );

      final failRev = engine.processReview(
        currentState: firstRev,
        rating: Rating.again,
        reviewTimestamp: now.add(const Duration(days: 3)),
      );

      expect(failRev.lapses, equals(1));
      expect(failRev.stability, lessThan(firstRev.stability));
    });
  });
}
