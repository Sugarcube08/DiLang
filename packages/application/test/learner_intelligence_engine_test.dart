import 'package:test/test.dart';
import 'package:dilang_storage/storage.dart';
import 'package:dilang_learning_engine/learning_engine.dart';

void main() {
  group('Learner Intelligence Engine & Four Quality Gates Tests', () {
    late SqliteStorageEngine storageEngine;
    late SqliteIntelligenceRepository intelRepo;
    late LearnerIntelligenceEngine intelEngine;

    setUp(() {
      storageEngine = SqliteStorageEngine.inMemory();
      intelRepo = SqliteIntelligenceRepository(engine: storageEngine);
      intelEngine = const LearnerIntelligenceEngine();
    });

    tearDown(() {
      storageEngine.dispose();
    });

    test('1. Intelligence Gate: Infers LearnerCognitiveModel & generates 100% explainable recommendations', () {
      final model = intelEngine.inferCognitiveModel(
        userId: 'usr_intel_01',
        totalSessions: 10,
        averageAccuracy: 0.88,
        dueReviewsCount: 12,
      );

      expect(model.userId, equals('usr_intel_01'));
      expect(model.vocabularyMastery, greaterThan(0.8));
      expect(model.estimatedCefrReadiness, equals(0.5)); // 10 * 0.05

      final errorAnalysis = intelEngine.analyzeError(
        userId: 'usr_intel_01',
        mistakeText: 'heiße',
        occurrences: 8,
        recoveries: 3,
      );

      expect(errorAnalysis.errorCategory, equals('Grammar'));
      expect(errorAnalysis.underlyingCause, contains('Accusative masculine'));

      final rec = intelEngine.generateExplainableRecommendation(
        model: model,
        primaryError: errorAnalysis,
      );

      expect(rec.missionTitle, equals('Ordering at a Viennese Café'));
      expect(rec.explicitReasons.length, equals(4));
      expect(rec.explicitReasons.any((r) => r.contains('Accusative masculine')), isTrue);
      expect(rec.predictedHighDecayItems, contains('Bahnhof'));
    });

    test('2. Engineering Gate: LearnerCognitiveModel & ErrorCauseAnalysis persist to SQLite with 100% fidelity', () async {
      final model = intelEngine.inferCognitiveModel(
        userId: 'usr_intel_02',
        totalSessions: 15,
        averageAccuracy: 0.92,
        dueReviewsCount: 5,
      );

      await intelRepo.saveCognitiveModel(model);

      final retrievedModel = await intelRepo.getCognitiveModel('usr_intel_02');
      expect(retrievedModel, isNotNull);
      expect(retrievedModel!.vocabularyMastery, closeTo(0.874, 0.01));
      expect(retrievedModel.estimatedCefrReadiness, equals(0.75));

      final errorAnalysis = intelEngine.analyzeError(
        userId: 'usr_intel_02',
        mistakeText: 'Bahnhof',
        occurrences: 5,
        recoveries: 2,
      );

      await intelRepo.saveErrorAnalysis(errorAnalysis);

      final retrievedErrors = await intelRepo.getErrorAnalyses('usr_intel_02');
      expect(retrievedErrors.length, equals(1));
      expect(retrievedErrors.first.errorCategory, equals('Vocabulary'));
      expect(retrievedErrors.first.underlyingCause, contains('Noun gender memory decay'));
    });

    test('3. Pedagogy & AI Quality Gates: Root cause analysis recommends targeted contextual intervention', () {
      final errorAnalysis = intelEngine.analyzeError(
        userId: 'usr_intel_03',
        mistakeText: 'heiße',
        occurrences: 10,
        recoveries: 4,
      );

      expect(errorAnalysis.recommendedIntervention, contains('Viennese café dialogue'));
    });
  });
}
