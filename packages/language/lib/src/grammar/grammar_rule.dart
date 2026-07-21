import 'package:equatable/equatable.dart';
import '../proficiency/cefr_level.dart';

enum GrammarCategory { syntax, morphology, agreement, caseSystem, tense, mood }

class GrammarRule extends Equatable {
  final String id;
  final String code; // e.g. "GER_V2_ORDER"
  final String title;
  final String explanation;
  final GrammarCategory category;
  final CefrLevel cefrLevel;
  final List<String> prerequisiteRuleIds;
  final List<String> positiveExamples;
  final List<String> negativeExamples; // Common learner errors

  const GrammarRule({
    required this.id,
    required this.code,
    required this.title,
    required this.explanation,
    required this.category,
    required this.cefrLevel,
    this.prerequisiteRuleIds = const [],
    this.positiveExamples = const [],
    this.negativeExamples = const [],
  });

  @override
  List<Object?> get props => [
        id,
        code,
        title,
        explanation,
        category,
        cefrLevel,
        prerequisiteRuleIds,
        positiveExamples,
        negativeExamples,
      ];
}
