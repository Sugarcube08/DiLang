import 'package:equatable/equatable.dart';

class HealthScorecardViewModel extends Equatable {
  final int overallScore; // 0 to 100
  final int vocabularyScore;
  final int grammarScore;
  final int fluencyScore;
  final double retentionRate; // e.g. 0.94
  final String statusText; // "Optimal Recovery", "Review Needed"

  const HealthScorecardViewModel({
    required this.overallScore,
    required this.vocabularyScore,
    required this.grammarScore,
    required this.fluencyScore,
    required this.retentionRate,
    required this.statusText,
  });

  @override
  List<Object?> get props => [
        overallScore,
        vocabularyScore,
        grammarScore,
        fluencyScore,
        retentionRate,
        statusText,
      ];
}

class TodayMissionViewModel extends Equatable {
  final String title;
  final String subTitle;
  final int estimatedMinutes;
  final String targetLanguage;
  final String cefrLevel;
  final int dueReviewsCount;

  const TodayMissionViewModel({
    required this.title,
    required this.subTitle,
    required this.estimatedMinutes,
    required this.targetLanguage,
    required this.cefrLevel,
    required this.dueReviewsCount,
  });

  @override
  List<Object?> get props => [
        title,
        subTitle,
        estimatedMinutes,
        targetLanguage,
        cefrLevel,
        dueReviewsCount,
      ];
}

class TimelineItemViewModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final String type;

  const TimelineItemViewModel({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
  });

  @override
  List<Object?> get props => [id, title, description, timestamp, type];
}

class TodayDashboardViewModel extends Equatable {
  final String greeting;
  final String username;
  final int currentStreak;
  final TodayMissionViewModel mission;
  final HealthScorecardViewModel health;
  final List<TimelineItemViewModel> timeline;
  final String singleInsight;
  final bool isLoading;
  final String? errorMessage;

  const TodayDashboardViewModel({
    required this.greeting,
    required this.username,
    required this.currentStreak,
    required this.mission,
    required this.health,
    required this.timeline,
    required this.singleInsight,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        greeting,
        username,
        currentStreak,
        mission,
        health,
        timeline,
        singleInsight,
        isLoading,
        errorMessage,
      ];
}
