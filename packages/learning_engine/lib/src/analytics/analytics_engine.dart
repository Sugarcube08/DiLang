import 'package:equatable/equatable.dart';

class LearningMetrics extends Equatable {
  final double dailyEfficiencyRatio;
  final int totalReviewsCompleted;
  final double vocabularyGrowthRate;

  const LearningMetrics({
    required this.dailyEfficiencyRatio,
    required this.totalReviewsCompleted,
    required this.vocabularyGrowthRate,
  });

  @override
  List<Object?> get props => [
        dailyEfficiencyRatio,
        totalReviewsCompleted,
        vocabularyGrowthRate,
      ];
}

class AnalyticsEngine {
  LearningMetrics computeMetrics({
    required int successfulReviews,
    required int totalReviews,
    required int newWordsThisWeek,
  }) {
    final efficiency = totalReviews > 0 ? (successfulReviews / totalReviews) : 1.0;
    return LearningMetrics(
      dailyEfficiencyRatio: efficiency,
      totalReviewsCompleted: totalReviews,
      vocabularyGrowthRate: newWordsThisWeek / 7.0,
    );
  }
}
