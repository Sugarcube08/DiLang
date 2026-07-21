import 'package:equatable/equatable.dart';
import '../objectives/learning_objective.dart';

class CurriculumGraph extends Equatable {
  final String languageCode;
  final Map<String, LearningObjective> objectives;

  const CurriculumGraph({
    required this.languageCode,
    this.objectives = const {},
  });

  bool isUnlocked(String objectiveId, Set<String> completedObjectiveIds) {
    final obj = objectives[objectiveId];
    if (obj == null) return false;
    return obj.prerequisiteObjectiveIds.every(completedObjectiveIds.contains);
  }

  List<LearningObjective> getUnlockedObjectives(Set<String> completedObjectiveIds) {
    return objectives.values
        .where((o) => !completedObjectiveIds.contains(o.id) && isUnlocked(o.id, completedObjectiveIds))
        .toList();
  }

  @override
  List<Object?> get props => [languageCode, objectives];
}
