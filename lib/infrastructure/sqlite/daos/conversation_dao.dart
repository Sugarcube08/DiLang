import 'package:sqlite3/sqlite3.dart';

class ConversationDao {
  final Database db;

  const ConversationDao(this.db);

  void insertSession({
    required String sessionId,
    required String userId,
    required String scenarioId,
    required int startTime,
  }) {
    db.execute(
      'INSERT INTO conversation_sessions (session_id, user_id, scenario_id, start_time, is_completed) VALUES (?, ?, ?, ?, 0);',
      [sessionId, userId, scenarioId, startTime],
    );
  }

  void insertTurn({
    required String turnId,
    required String sessionId,
    required int turnIndex,
    required String speaker,
    required String text,
    required String phoneticsIpa,
    required int timestamp,
  }) {
    db.execute(
      'INSERT INTO conversation_turns (turn_id, session_id, turn_index, speaker, text, phonetics_ipa, timestamp) VALUES (?, ?, ?, ?, ?, ?, ?);',
      [turnId, sessionId, turnIndex, speaker, text, phoneticsIpa, timestamp],
    );
  }

  void insertReplay({
    required String transcriptId,
    required String sessionId,
    required String scenarioId,
    required int timestamp,
    required int confidenceBefore,
    required int confidenceAfter,
    required String evidenceSummary,
    required String turnsJson,
  }) {
    db.execute(
      '''
      INSERT INTO conversation_replays (
        transcript_id, session_id, scenario_id, timestamp, confidence_before, confidence_after, evidence_summary, turns_json
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?);
      ''',
      [transcriptId, sessionId, scenarioId, timestamp, confidenceBefore, confidenceAfter, evidenceSummary, turnsJson],
    );
  }

  ResultSet fetchReplaysForSession(String sessionId) {
    return db.select('SELECT transcript_id, scenario_id, timestamp, evidence_summary, turns_json FROM conversation_replays WHERE session_id = ?;', [sessionId]);
  }
}
