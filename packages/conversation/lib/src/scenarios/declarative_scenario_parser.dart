import 'package:equatable/equatable.dart';
import 'conversation_scenario.dart';

class DeclarativeScenarioManifest extends Equatable {
  final String scenarioId;
  final String title;
  final String description;
  final String cefrLevel;
  final int estimatedDurationMinutes;
  final String personaName;
  final String personaRole;
  final String personaPersonality;
  final List<String> requiredNodeIds;
  final List<String> targetVocabulary;
  final List<String> targetGrammarRuleIds;
  final String culturalNote;

  const DeclarativeScenarioManifest({
    required this.scenarioId,
    required this.title,
    required this.description,
    required this.cefrLevel,
    required this.estimatedDurationMinutes,
    required this.personaName,
    required this.personaRole,
    required this.personaPersonality,
    required this.requiredNodeIds,
    required this.targetVocabulary,
    required this.targetGrammarRuleIds,
    required this.culturalNote,
  });

  ConversationScenario toConversationScenario() {
    return ConversationScenario(
      id: scenarioId,
      title: title,
      description: description,
      cefrLevel: cefrLevel,
      estimatedDurationMinutes: estimatedDurationMinutes,
      personaName: personaName,
      personaRole: personaRole,
      personaPersonality: personaPersonality,
      targetVocabulary: targetVocabulary,
      targetGrammarRules: targetGrammarRuleIds,
      culturalNote: culturalNote,
    );
  }

  factory DeclarativeScenarioManifest.fromJson(Map<String, dynamic> json) {
    return DeclarativeScenarioManifest(
      scenarioId: json['scenarioId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      cefrLevel: json['cefrLevel'] as String,
      estimatedDurationMinutes: json['estimatedDurationMinutes'] as int,
      personaName: json['personaName'] as String,
      personaRole: json['personaRole'] as String,
      personaPersonality: json['personaPersonality'] as String,
      requiredNodeIds: List<String>.from(json['requiredNodeIds'] as Iterable),
      targetVocabulary: List<String>.from(json['targetVocabulary'] as Iterable),
      targetGrammarRuleIds: List<String>.from(json['targetGrammarRuleIds'] as Iterable),
      culturalNote: json['culturalNote'] as String,
    );
  }

  @override
  List<Object?> get props => [
        scenarioId,
        title,
        description,
        cefrLevel,
        estimatedDurationMinutes,
        personaName,
        personaRole,
        personaPersonality,
        requiredNodeIds,
        targetVocabulary,
        targetGrammarRuleIds,
        culturalNote,
      ];
}
