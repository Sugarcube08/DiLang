import 'dart:convert';
import 'package:dilang_conversation/conversation.dart';
import '../database/sqlite_storage_engine.dart';

abstract class ReplayRepositoryContract {
  Future<void> saveTranscript(LearningReplayTranscript transcript);
  Future<LearningReplayTranscript?> getTranscript(String transcriptId);
  Future<List<LearningReplayTranscript>> getTranscriptsForSession(String sessionId);
}

class SqliteReplayRepository implements ReplayRepositoryContract {
  final SqliteStorageEngine engine;

  SqliteReplayRepository({required this.engine});

  @override
  Future<void> saveTranscript(LearningReplayTranscript transcript) async {
    final db = engine.db;
    final turnsJsonStr = jsonEncode(transcript.turns.map((t) => t.toJson()).toList());

    db.execute(
      '''
      INSERT INTO replay_transcripts (
        transcript_id, session_id, scenario_id, timestamp,
        confidence_before, confidence_after, evidence_summary, turns_json
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      ON CONFLICT(transcript_id) DO UPDATE SET
        confidence_after = excluded.confidence_after,
        evidence_summary = excluded.evidence_summary,
        turns_json = excluded.turns_json;
      ''',
      [
        transcript.transcriptId,
        transcript.sessionId,
        transcript.scenarioId,
        transcript.timestamp.millisecondsSinceEpoch,
        transcript.speakingConfidenceBefore,
        transcript.speakingConfidenceAfter,
        transcript.evidenceSummary,
        turnsJsonStr,
      ],
    );
  }

  @override
  Future<LearningReplayTranscript?> getTranscript(String transcriptId) async {
    final db = engine.db;
    final res = db.select(
      'SELECT transcript_id, session_id, scenario_id, timestamp, confidence_before, confidence_after, evidence_summary, turns_json FROM replay_transcripts WHERE transcript_id = ?;',
      [transcriptId],
    );

    if (res.isEmpty) return null;
    final row = res.first;

    final turnsListRaw = jsonDecode(row['turns_json'] as String) as List;
    final turns = turnsListRaw.map((t) => LearningReplayTurn.fromJson(t as Map<String, dynamic>)).toList();

    return LearningReplayTranscript(
      transcriptId: row['transcript_id'] as String,
      sessionId: row['session_id'] as String,
      scenarioId: row['scenario_id'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(row['timestamp'] as int),
      turns: turns,
      speakingConfidenceBefore: row['confidence_before'] as int,
      speakingConfidenceAfter: row['confidence_after'] as int,
      evidenceSummary: row['evidence_summary'] as String,
    );
  }

  @override
  Future<List<LearningReplayTranscript>> getTranscriptsForSession(String sessionId) async {
    final db = engine.db;
    final res = db.select(
      'SELECT transcript_id, session_id, scenario_id, timestamp, confidence_before, confidence_after, evidence_summary, turns_json FROM replay_transcripts WHERE session_id = ?;',
      [sessionId],
    );

    return res.map((row) {
      final turnsListRaw = jsonDecode(row['turns_json'] as String) as List;
      final turns = turnsListRaw.map((t) => LearningReplayTurn.fromJson(t as Map<String, dynamic>)).toList();

      return LearningReplayTranscript(
        transcriptId: row['transcript_id'] as String,
        sessionId: row['session_id'] as String,
        scenarioId: row['scenario_id'] as String,
        timestamp: DateTime.fromMillisecondsSinceEpoch(row['timestamp'] as int),
        turns: turns,
        speakingConfidenceBefore: row['confidence_before'] as int,
        speakingConfidenceAfter: row['confidence_after'] as int,
        evidenceSummary: row['evidence_summary'] as String,
      );
    }).toList();
  }

  Future<List<LearningReplayTranscript>> getAllTranscripts() async {
    final db = engine.db;
    final res = db.select(
      'SELECT transcript_id, session_id, scenario_id, timestamp, confidence_before, confidence_after, evidence_summary, turns_json FROM replay_transcripts;',
    );

    return res.map((row) {
      final turnsListRaw = jsonDecode(row['turns_json'] as String) as List;
      final turns = turnsListRaw.map((t) => LearningReplayTurn.fromJson(t as Map<String, dynamic>)).toList();

      return LearningReplayTranscript(
        transcriptId: row['transcript_id'] as String,
        sessionId: row['session_id'] as String,
        scenarioId: row['scenario_id'] as String,
        timestamp: DateTime.fromMillisecondsSinceEpoch(row['timestamp'] as int),
        turns: turns,
        speakingConfidenceBefore: row['confidence_before'] as int,
        speakingConfidenceAfter: row['confidence_after'] as int,
        evidenceSummary: row['evidence_summary'] as String,
      );
    }).toList();
  }
}
