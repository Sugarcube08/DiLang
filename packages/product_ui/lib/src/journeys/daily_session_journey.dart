import 'package:equatable/equatable.dart';
import 'package:dilang_learning_engine/learning_engine.dart';
import 'package:dilang_conversation/conversation.dart';

enum DailySessionStage { recommendation, fsrsReview, conversationDialogue, summary }

class DailySessionJourneyState extends Equatable {
  final DailySessionStage stage;
  final List<LearningRecommendation> recommendations;
  final ConversationSession? activeConversation;
  final int completedReviews;
  final bool isFinished;

  const DailySessionJourneyState({
    this.stage = DailySessionStage.recommendation,
    this.recommendations = const [],
    this.activeConversation,
    this.completedReviews = 0,
    this.isFinished = false,
  });

  DailySessionJourneyState copyWith({
    DailySessionStage? stage,
    List<LearningRecommendation>? recommendations,
    ConversationSession? activeConversation,
    int? completedReviews,
    bool? isFinished,
  }) {
    return DailySessionJourneyState(
      stage: stage ?? this.stage,
      recommendations: recommendations ?? this.recommendations,
      activeConversation: activeConversation ?? this.activeConversation,
      completedReviews: completedReviews ?? this.completedReviews,
      isFinished: isFinished ?? this.isFinished,
    );
  }

  @override
  List<Object?> get props => [
        stage,
        recommendations,
        activeConversation,
        completedReviews,
        isFinished,
      ];
}

class DailySessionJourneyController {
  DailySessionJourneyState state = const DailySessionJourneyState();

  void startSession(List<LearningRecommendation> recommendations) {
    state = state.copyWith(
      stage: DailySessionStage.fsrsReview,
      recommendations: recommendations,
    );
  }

  void completeFsrsReviewStep() {
    state = state.copyWith(
      stage: DailySessionStage.conversationDialogue,
      completedReviews: state.completedReviews + 1,
    );
  }

  void completeConversationStep(ConversationSession session) {
    state = state.copyWith(
      stage: DailySessionStage.summary,
      activeConversation: session,
      isFinished: true,
    );
  }
}
