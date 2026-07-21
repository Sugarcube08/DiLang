import 'package:test/test.dart';
import 'package:dilang_language/language.dart';
import 'package:dilang_conversation/conversation.dart';
import 'package:dilang_learning_engine/learning_engine.dart';

void main() {
  group('Knowledge Platform & Five Quality Gates Integration Tests', () {
    test('1. Pedagogy Gate: UniversalKnowledgeGraph evaluates DAG prerequisites correctly', () {
      final graph = UniversalKnowledgeGraph.createGermanA1Graph();
      expect(graph.allNodes.length, equals(4));

      final pre = graph.findPrerequisitesFor('node_acc_masc');
      expect(pre.length, equals(1));
      expect(pre.first.id, equals('node_art_der'));
    });

    test('2. AI Quality Gate: DeclarativeScenarioManifest parses YAML/JSON manifests into Runnable Scenarios', () {
      final manifestJson = {
        'scenarioId': 'scn_cafe_decl',
        'title': 'Viennese Café Declarative',
        'description': 'Parsed from YAML/JSON content manifest',
        'cefrLevel': 'A1',
        'estimatedDurationMinutes': 15,
        'personaName': 'Greta',
        'personaRole': 'Waitress',
        'personaPersonality': 'Polite',
        'requiredNodeIds': ['node_art_der', 'node_acc_masc'],
        'targetVocabulary': ['Kaffee', 'Wasser'],
        'targetGrammarRuleIds': ['accusative_masculine_article'],
        'culturalNote': 'Order Einen Verlängerten',
      };

      final manifest = DeclarativeScenarioManifest.fromJson(manifestJson);
      final scenario = manifest.toConversationScenario();

      expect(scenario.id, equals('scn_cafe_decl'));
      expect(scenario.cefrLevel, equals('A1'));
      expect(scenario.personaName, equals('Greta'));
      expect(scenario.targetGrammarRules, contains('accusative_masculine_article'));
    });

    test('3. Evaluation Gate: AutomatedEvaluationFramework runs educational regression suite cleanly', () {
      const evalFramework = AutomatedEvaluationFramework();
      final results = evalFramework.runEducationalRegressionSuite();

      expect(results.length, equals(3));
      for (final res in results) {
        expect(res.passed, isTrue, reason: 'Failed evaluation test ${res.testId}: ${res.testName}');
      }
    });
  });
}
