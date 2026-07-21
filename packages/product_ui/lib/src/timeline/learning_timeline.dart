import 'package:equatable/equatable.dart';

enum TimelineEntryType { review, conversation, grammar, memoryHealth }

class TimelineEntry extends Equatable {
  final String id;
  final DateTime timestamp;
  final String title;
  final String description;
  final TimelineEntryType type;

  const TimelineEntry({
    required this.id,
    required this.timestamp,
    required this.title,
    required this.description,
    required this.type,
  });

  @override
  List<Object?> get props => [id, timestamp, title, description, type];
}

class LearningTimelineState extends Equatable {
  final List<TimelineEntry> entries;
  final double weeklyGoalProgress; // e.g. 0.67 = 67%

  const LearningTimelineState({
    this.entries = const [],
    this.weeklyGoalProgress = 0.0,
  });

  LearningTimelineState copyWith({
    List<TimelineEntry>? entries,
    double? weeklyGoalProgress,
  }) {
    return LearningTimelineState(
      entries: entries ?? this.entries,
      weeklyGoalProgress: weeklyGoalProgress ?? this.weeklyGoalProgress,
    );
  }

  @override
  List<Object?> get props => [entries, weeklyGoalProgress];
}

class LearningTimelineController {
  LearningTimelineState state = const LearningTimelineState();

  void addEntry(TimelineEntry entry) {
    state = state.copyWith(
      entries: [entry, ...state.entries],
    );
  }

  void updateWeeklyGoalProgress(double progress) {
    state = state.copyWith(weeklyGoalProgress: progress.clamp(0.0, 1.0));
  }
}
