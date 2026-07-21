import 'package:equatable/equatable.dart';
import 'package:dilang_language/language.dart';

class LearningObjective extends Equatable {
  final String id;
  final String title;
  final String description;
  final CefrLevel cefrLevel;
  final List<String> requiredVocabularyIds;
  final List<String> requiredGrammarRuleIds;
  final List<String> prerequisiteObjectiveIds;

  const LearningObjective({
    required this.id,
    required this.title,
    required this.description,
    required this.cefrLevel,
    this.requiredVocabularyIds = const [],
    this.requiredGrammarRuleIds = const [],
    this.prerequisiteObjectiveIds = const [],
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        cefrLevel,
        requiredVocabularyIds,
        requiredGrammarRuleIds,
        prerequisiteObjectiveIds,
      ];
}
