import 'package:sqlite3/sqlite3.dart';

class UserDao {
  final Database db;

  const UserDao(this.db);

  void insertUser({
    required String id,
    required String username,
    required String email,
    required int createdAt,
    required int lastActiveAt,
  }) {
    db.execute(
      'INSERT INTO users (id, username, email, created_at, last_active_at) VALUES (?, ?, ?, ?, ?);',
      [id, username, email, createdAt, lastActiveAt],
    );
  }

  void insertProfile({
    required String userId,
    required String displayName,
    required String avatarUrl,
    required String nativeLanguage,
    required String timezone,
  }) {
    db.execute(
      'INSERT INTO profiles (user_id, display_name, avatar_url, native_language, timezone) VALUES (?, ?, ?, ?, ?);',
      [userId, displayName, avatarUrl, nativeLanguage, timezone],
    );
  }

  void insertLanguageProfile({
    required String id,
    required String userId,
    required String targetLanguage,
    required String cefrLevel,
    required String learningGoal,
    required int dailyGoalMinutes,
    required String brainModel,
    required String aiCoachPersona,
    required String voicePreference,
  }) {
    db.execute(
      '''
      INSERT INTO language_profiles (
        id, user_id, target_language, cefr_level, learning_goal,
        daily_goal_minutes, is_primary, brain_model, ai_coach_persona, voice_preference
      ) VALUES (?, ?, ?, ?, ?, ?, 1, ?, ?, ?);
      ''',
      [id, userId, targetLanguage, cefrLevel, learningGoal, dailyGoalMinutes, brainModel, aiCoachPersona, voicePreference],
    );
  }

  ResultSet fetchActiveUser() {
    return db.select('SELECT id, username, email FROM users LIMIT 1;');
  }

  ResultSet fetchUserProfile(String userId) {
    return db.select('SELECT display_name, native_language, avatar_url FROM profiles WHERE user_id = ?;', [userId]);
  }

  ResultSet fetchLanguageProfile(String userId) {
    return db.select('SELECT target_language, cefr_level, brain_model, ai_coach_persona FROM language_profiles WHERE user_id = ?;', [userId]);
  }
}
