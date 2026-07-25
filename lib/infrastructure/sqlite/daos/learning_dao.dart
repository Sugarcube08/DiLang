import 'package:sqlite3/sqlite3.dart';

class LearningDao {
  final Database db;

  const LearningDao(this.db);

  void insertFsrsCard({
    required String cardId,
    required String userId,
    required double stability,
    required double difficulty,
    required int elapsedDays,
    required int scheduledDays,
    required int reps,
    required int state,
    required int nextReview,
  }) {
    db.execute(
      '''
      INSERT INTO fsrs_cards (
        card_id, user_id, stability, difficulty, elapsed_days, scheduled_days, reps, state, next_review
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);
      ''',
      [cardId, userId, stability, difficulty, elapsedDays, scheduledDays, reps, state, nextReview],
    );
  }

  ResultSet fetchDueFsrsCards(String userId, int nowTimestamp) {
    return db.select(
      'SELECT card_id, stability, difficulty, reps, state, next_review FROM fsrs_cards WHERE user_id = ? AND next_review <= ? ORDER BY next_review ASC;',
      [userId, nowTimestamp],
    );
  }

  void insertMission({
    required String missionId,
    required String userId,
    required String title,
    required String description,
    required String targetLanguage,
    required int xpReward,
    required int isCompleted,
  }) {
    db.execute(
      'INSERT INTO missions (mission_id, user_id, title, description, target_language, xp_reward, is_completed) VALUES (?, ?, ?, ?, ?, ?, ?);',
      [missionId, userId, title, description, targetLanguage, xpReward, isCompleted],
    );
  }

  ResultSet fetchUserMissions(String userId) {
    return db.select('SELECT mission_id, title, description, xp_reward, is_completed FROM missions WHERE user_id = ?;', [userId]);
  }
}
