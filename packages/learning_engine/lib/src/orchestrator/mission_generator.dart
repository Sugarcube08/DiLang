import 'package:equatable/equatable.dart';

enum AvailableTimeSlot {
  quick5Min,
  standard15Min,
  deep30Min,
}

class CoachingRecommendation extends Equatable {
  final String id;
  final String title;
  final String explanation;
  final String weakConcept;
  final String suggestedAction;
  final DateTime generatedAt;

  const CoachingRecommendation({
    required this.id,
    required this.title,
    required this.explanation,
    required this.weakConcept,
    required this.suggestedAction,
    required this.generatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        explanation,
        weakConcept,
        suggestedAction,
        generatedAt,
      ];
}

class GeneratedMission extends Equatable {
  final String missionId;
  final String title;
  final String description;
  final int totalDurationMinutes;
  final String targetLanguage;
  final String cefrLevel;
  final int dueVocabularyCount;
  final String primaryActivityType;
  final CoachingRecommendation coaching;

  const GeneratedMission({
    required this.missionId,
    required this.title,
    required this.description,
    required this.totalDurationMinutes,
    required this.targetLanguage,
    required this.cefrLevel,
    required this.dueVocabularyCount,
    required this.primaryActivityType,
    required this.coaching,
  });

  @override
  List<Object?> get props => [
        missionId,
        title,
        description,
        totalDurationMinutes,
        targetLanguage,
        cefrLevel,
        dueVocabularyCount,
        primaryActivityType,
        coaching,
      ];
}

class MissionGenerator {
  const MissionGenerator();

  GeneratedMission generateMission({
    required String targetLanguage,
    required String cefrLevel,
    required int dueReviewsCount,
    AvailableTimeSlot timeSlot = AvailableTimeSlot.standard15Min,
  }) {
    final now = DateTime.now();

    switch (timeSlot) {
      case AvailableTimeSlot.quick5Min:
        return GeneratedMission(
          missionId: 'msn_quick_${now.millisecondsSinceEpoch}',
          title: 'Quick Memory Retention Drill',
          description: 'Flashcard review of 8 high-decay vocabulary items',
          totalDurationMinutes: 5,
          targetLanguage: targetLanguage,
          cefrLevel: cefrLevel,
          dueVocabularyCount: dueReviewsCount,
          primaryActivityType: 'review',
          coaching: CoachingRecommendation(
            id: 'coach_q5',
            title: 'Memory Curve Decay Alert',
            explanation: 'You have 8 vocabulary items approaching their stability limit.',
            weakConcept: 'High-decay German nouns (Der/Die/Das)',
            suggestedAction: 'Complete a quick 5-minute flashcard sweep.',
            generatedAt: now,
          ),
        );

      case AvailableTimeSlot.standard15Min:
        return GeneratedMission(
          missionId: 'msn_std_${now.millisecondsSinceEpoch}',
          title: 'Conversation Practice',
          description: 'Ordering at a Viennese Café + 14 vocabulary reviews',
          totalDurationMinutes: 15,
          targetLanguage: targetLanguage,
          cefrLevel: cefrLevel,
          dueVocabularyCount: dueReviewsCount,
          primaryActivityType: 'conversation',
          coaching: CoachingRecommendation(
            id: 'coach_std15',
            title: 'Case Confusion Coaching',
            explanation: 'You consistently confuse "der" and "den" accusative articles.',
            weakConcept: 'Accusative masculine article inflection (der -> den)',
            suggestedAction: 'Today\'s café dialogue will reinforce accusative food ordering naturally.',
            generatedAt: now,
          ),
        );

      case AvailableTimeSlot.deep30Min:
        return GeneratedMission(
          missionId: 'msn_deep_${now.millisecondsSinceEpoch}',
          title: 'Full Fluency Session',
          description: 'Conversation + Grammar Matrix + 25 FSRS Reviews',
          totalDurationMinutes: 30,
          targetLanguage: targetLanguage,
          cefrLevel: cefrLevel,
          dueVocabularyCount: dueReviewsCount,
          primaryActivityType: 'conversation',
          coaching: CoachingRecommendation(
            id: 'coach_d30',
            title: 'CEFR Progression Boost',
            explanation: 'You are 82% of the way to unlocking B1 reading passages.',
            weakConcept: 'Subordinate clause word order (Weil / Dass)',
            suggestedAction: 'Deep session combines audio conversation with structural grammar drills.',
            generatedAt: now,
          ),
        );
    }
  }
}
