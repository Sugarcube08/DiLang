import 'dart:math' as math;
import 'package:equatable/equatable.dart';

enum Rating {
  again(1),
  hard(2),
  good(3),
  easy(4);

  final int value;
  const Rating(this.value);
}

class FsrsItemState extends Equatable {
  final double stability;  // S (in days)
  final double difficulty; // D (1.0 to 10.0)
  final int reps;
  final int lapses;
  final DateTime lastReviewed;
  final DateTime due;

  const FsrsItemState({
    required this.stability,
    required this.difficulty,
    required this.reps,
    required this.lapses,
    required this.lastReviewed,
    required this.due,
  });

  factory FsrsItemState.initial(DateTime now) {
    return FsrsItemState(
      stability: 0.0,
      difficulty: 5.0,
      reps: 0,
      lapses: 0,
      lastReviewed: now,
      due: now,
    );
  }

  @override
  List<Object?> get props => [stability, difficulty, reps, lapses, lastReviewed, due];
}

class FsrsParameters extends Equatable {
  final double w0;
  final double w1;
  final double w2;
  final double w3;
  final double w4;
  final double w5;
  final double w6;
  final double w7;
  final double w8;
  final double w9;

  const FsrsParameters({
    this.w0 = 0.4,
    this.w1 = 1.2,
    this.w2 = 3.1,
    this.w3 = 15.6,
    this.w4 = 7.2,
    this.w5 = 0.53,
    this.w6 = 0.94,
    this.w7 = 0.86,
    this.w8 = 0.01,
    this.w9 = 1.49,
  });

  @override
  List<Object?> get props => [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9];
}

class Fsrs45Engine {
  final FsrsParameters params;

  const Fsrs45Engine({this.params = const FsrsParameters()});

  /// Retrievability R(t, S) = (1 + 0.2345679 * (t / S))^-1
  double calculateRetrievability(double daysElapsed, double stability) {
    if (stability <= 0.0) return 0.0;
    const factor = 19.0 / 81.0; // ~0.2345679
    return math.pow(1.0 + factor * (daysElapsed / stability), -1.0).toDouble();
  }

  FsrsItemState evaluateReview({
    required FsrsItemState currentState,
    required Rating rating,
    required DateTime reviewTimestamp,
  }) {
    final daysElapsed = math.max(0.0, reviewTimestamp.difference(currentState.lastReviewed).inHours / 24.0);

    if (currentState.reps == 0) {
      // First review attempt
      final initialStability = _getInitialStability(rating);
      final initialDifficulty = _getInitialDifficulty(rating);
      final nextIntervalDays = math.max(1, initialStability.round());

      return FsrsItemState(
        stability: initialStability,
        difficulty: initialDifficulty,
        reps: 1,
        lapses: rating == Rating.again ? 1 : 0,
        lastReviewed: reviewTimestamp,
        due: reviewTimestamp.add(Duration(days: nextIntervalDays)),
      );
    } else {
      // Subsequent review
      final retrievability = calculateRetrievability(daysElapsed, currentState.stability);
      final nextDifficulty = _updateDifficulty(currentState.difficulty, rating);
      double nextStability;
      int lapses = currentState.lapses;

      if (rating == Rating.again) {
        lapses += 1;
        nextStability = math.max(0.1, currentState.stability * 0.2);
      } else {
        // Successful recall
        final hardFactor = rating == Rating.hard ? 0.85 : (rating == Rating.easy ? 1.3 : 1.0);
        final growth = math.exp(params.w8) * (11.0 - nextDifficulty) * math.pow(currentState.stability, -params.w9) * hardFactor;
        nextStability = currentState.stability * (1.0 + growth * (1.0 - retrievability));
      }

      final nextIntervalDays = math.max(1, nextStability.round());

      return FsrsItemState(
        stability: nextStability,
        difficulty: nextDifficulty,
        reps: currentState.reps + 1,
        lapses: lapses,
        lastReviewed: reviewTimestamp,
        due: reviewTimestamp.add(Duration(days: nextIntervalDays)),
      );
    }
  }

  double _getInitialStability(Rating rating) {
    switch (rating) {
      case Rating.again:
        return params.w0;
      case Rating.hard:
        return params.w1;
      case Rating.good:
        return params.w2;
      case Rating.easy:
        return params.w3;
    }
  }

  double _getInitialDifficulty(Rating rating) {
    final d = params.w4 - (rating.value - 3) * params.w5;
    return d.clamp(1.0, 10.0);
  }

  double _updateDifficulty(double currentD, Rating rating) {
    final d = currentD - params.w6 * (rating.value - 3);
    return d.clamp(1.0, 10.0);
  }
}
