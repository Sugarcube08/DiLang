import 'package:equatable/equatable.dart';

enum MasteryLevel { new_item, learning, reviewing, mastered, lapsed }

class LearnerNodeState extends Equatable {
  final String itemKey; // e.g. "voc_haus" or "g_v2"
  final MasteryLevel level;
  final double masteryScore; // 0.0 to 1.0
  final DateTime lastInteracted;
  final int totalInteractions;
  final int totalSuccesses;

  const LearnerNodeState({
    required this.itemKey,
    required this.level,
    required this.masteryScore,
    required this.lastInteracted,
    this.totalInteractions = 0,
    this.totalSuccesses = 0,
  });

  LearnerNodeState copyWith({
    MasteryLevel? level,
    double? masteryScore,
    DateTime? lastInteracted,
    int? totalInteractions,
    int? totalSuccesses,
  }) {
    return LearnerNodeState(
      itemKey: itemKey,
      level: level ?? this.level,
      masteryScore: masteryScore ?? this.masteryScore,
      lastInteracted: lastInteracted ?? this.lastInteracted,
      totalInteractions: totalInteractions ?? this.totalInteractions,
      totalSuccesses: totalSuccesses ?? this.totalSuccesses,
    );
  }

  @override
  List<Object?> get props => [
        itemKey,
        level,
        masteryScore,
        lastInteracted,
        totalInteractions,
        totalSuccesses,
      ];
}

class LearnerKnowledgeGraph extends Equatable {
  final String learnerId;
  final String targetLanguage;
  final Map<String, LearnerNodeState> nodeStates;

  const LearnerKnowledgeGraph({
    required this.learnerId,
    required this.targetLanguage,
    this.nodeStates = const {},
  });

  int get totalTrackedItems => nodeStates.length;

  int get totalMasteredItems =>
      nodeStates.values.where((n) => n.level == MasteryLevel.mastered).length;

  double get overallMasteryRatio {
    if (nodeStates.isEmpty) return 0.0;
    final total = nodeStates.values.fold<double>(0.0, (acc, n) => acc + n.masteryScore);
    return total / nodeStates.length;
  }

  @override
  List<Object?> get props => [learnerId, targetLanguage, nodeStates];
}
