import 'package:equatable/equatable.dart';

class WhoopScorecard extends Equatable {
  final String learningLoad; // Optimal, High, Recovery
  final double memoryGainPercent; // +2.8%
  final double pronunciationGainPercent; // +3.0%
  final int vocabularyCountGained; // +18
  final int conversationMinutes; // 12 min

  const WhoopScorecard({
    this.learningLoad = 'Optimal',
    this.memoryGainPercent = 2.8,
    this.pronunciationGainPercent = 3.0,
    this.vocabularyCountGained = 18,
    this.conversationMinutes = 12,
  });

  @override
  List<Object?> get props => [
        learningLoad,
        memoryGainPercent,
        pronunciationGainPercent,
        vocabularyCountGained,
        conversationMinutes,
      ];
}

class ThirtyDayNarrative extends Equatable {
  final int totalWordsLearned;
  final double comprehensionPercentage;
  final String estimatedCefr;
  final String strongestSkill;
  final String weakestSkill;
  final String todaysRecommendedMission;

  const ThirtyDayNarrative({
    this.totalWordsLearned = 1240,
    this.comprehensionPercentage = 0.78,
    this.estimatedCefr = 'B1',
    this.strongestSkill = 'Reading',
    this.weakestSkill = 'Speaking',
    this.todaysRecommendedMission = 'Voice Conversation',
  });

  @override
  List<Object?> get props => [
        totalWordsLearned,
        comprehensionPercentage,
        estimatedCefr,
        strongestSkill,
        weakestSkill,
        todaysRecommendedMission,
      ];
}

class TodayDashboardState extends Equatable {
  final String learnerName;
  final int activeDayStreak;
  final WhoopScorecard scorecard;
  final ThirtyDayNarrative narrative;
  final double overallLanguageHealth;

  const TodayDashboardState({
    this.learnerName = 'Harsh',
    this.activeDayStreak = 32,
    this.scorecard = const WhoopScorecard(),
    this.narrative = const ThirtyDayNarrative(),
    this.overallLanguageHealth = 0.87,
  });

  @override
  List<Object?> get props => [
        learnerName,
        activeDayStreak,
        scorecard,
        narrative,
        overallLanguageHealth,
      ];
}
