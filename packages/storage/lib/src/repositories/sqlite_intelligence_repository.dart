import 'package:dilang_learning_engine/learning_engine.dart';
import '../database/sqlite_storage_engine.dart';

abstract class IntelligenceRepositoryContract {
  Future<void> saveCognitiveModel(LearnerCognitiveModel model);
  Future<LearnerCognitiveModel?> getCognitiveModel(String userId);
  Future<void> saveErrorAnalysis(ErrorCauseAnalysis analysis);
  Future<List<ErrorCauseAnalysis>> getErrorAnalyses(String userId);
}

class SqliteIntelligenceRepository implements IntelligenceRepositoryContract {
  final SqliteStorageEngine engine;

  SqliteIntelligenceRepository({required this.engine});

  @override
  Future<void> saveCognitiveModel(LearnerCognitiveModel model) async {
    final db = engine.db;
    db.execute(
      '''
      INSERT INTO cognitive_models (user_id, vocab_mastery, grammar_mastery, recall_stability, cefr_readiness, updated_at)
      VALUES (?, ?, ?, ?, ?, ?)
      ON CONFLICT(user_id) DO UPDATE SET
        vocab_mastery = excluded.vocab_mastery,
        grammar_mastery = excluded.grammar_mastery,
        recall_stability = excluded.recall_stability,
        cefr_readiness = excluded.cefr_readiness,
        updated_at = excluded.updated_at;
      ''',
      [
        model.userId,
        model.vocabularyMastery,
        model.grammarMastery,
        model.recallStability,
        model.estimatedCefrReadiness,
        DateTime.now().millisecondsSinceEpoch,
      ],
    );
  }

  @override
  Future<LearnerCognitiveModel?> getCognitiveModel(String userId) async {
    final db = engine.db;
    final res = db.select('SELECT user_id, vocab_mastery, grammar_mastery, recall_stability, cefr_readiness FROM cognitive_models WHERE user_id = ?;', [userId]);
    if (res.isEmpty) return null;

    final row = res.first;
    final vm = row['vocab_mastery'] as double;
    final gm = row['grammar_mastery'] as double;
    final rs = row['recall_stability'] as double;
    final cr = row['cefr_readiness'] as double;

    return LearnerCognitiveModel(
      userId: userId,
      vocabularyMastery: vm,
      grammarMastery: gm,
      pronunciationConfidence: vm * 0.92,
      listeningComprehension: vm * 0.88,
      readingFluency: vm * 0.94,
      writingFluency: vm * 0.85,
      recallStability: rs,
      cognitiveLoadIndex: 0.35,
      learningVelocity: 1.2,
      estimatedCefrReadiness: cr,
    );
  }

  @override
  Future<void> saveErrorAnalysis(ErrorCauseAnalysis analysis) async {
    final db = engine.db;
    db.execute(
      '''
      INSERT INTO error_intelligence (
        error_id, user_id, mistake_text, error_category, underlying_cause, occurrences, recoveries, intervention
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      ON CONFLICT(error_id) DO UPDATE SET
        occurrences = excluded.occurrences,
        recoveries = excluded.recoveries,
        intervention = excluded.intervention;
      ''',
      [
        analysis.errorId,
        analysis.userId,
        analysis.mistakeText,
        analysis.errorCategory,
        analysis.underlyingCause,
        analysis.totalOccurrences,
        analysis.totalRecoveries,
        analysis.recommendedIntervention,
      ],
    );
  }

  @override
  Future<List<ErrorCauseAnalysis>> getErrorAnalyses(String userId) async {
    final db = engine.db;
    final res = db.select(
      'SELECT error_id, user_id, mistake_text, error_category, underlying_cause, occurrences, recoveries, intervention FROM error_intelligence WHERE user_id = ?;',
      [userId],
    );

    return res.map((row) {
      return ErrorCauseAnalysis(
        errorId: row['error_id'] as String,
        userId: row['user_id'] as String,
        mistakeText: row['mistake_text'] as String,
        errorCategory: row['error_category'] as String,
        underlyingCause: row['underlying_cause'] as String,
        totalOccurrences: row['occurrences'] as int,
        totalRecoveries: row['recoveries'] as int,
        recommendedIntervention: row['intervention'] as String,
      );
    }).toList();
  }
}
