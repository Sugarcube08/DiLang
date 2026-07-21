import 'fsrs_4_5.dart';

class MemoryEngine {
  final Fsrs45Engine _fsrsEngine;

  const MemoryEngine({Fsrs45Engine fsrsEngine = const Fsrs45Engine()})
      : _fsrsEngine = fsrsEngine;

  FsrsItemState processReview({
    required FsrsItemState currentState,
    required Rating rating,
    required DateTime reviewTimestamp,
  }) {
    return _fsrsEngine.evaluateReview(
      currentState: currentState,
      rating: rating,
      reviewTimestamp: reviewTimestamp,
    );
  }

  double predictRetrievability({
    required FsrsItemState state,
    required DateTime currentTimestamp,
  }) {
    final daysElapsed = currentTimestamp.difference(state.lastReviewed).inHours / 24.0;
    return _fsrsEngine.calculateRetrievability(daysElapsed, state.stability);
  }
}
