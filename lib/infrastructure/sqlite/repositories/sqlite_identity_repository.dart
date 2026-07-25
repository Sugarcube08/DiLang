import 'package:sqlite3/sqlite3.dart';
import '../../../modules/identity/models/user.dart';
import '../../../modules/identity/models/language_profile.dart';
import '../../../modules/identity/models/learning_preferences.dart';
import '../../../modules/identity/repositories/identity_repository.dart';
import '../daos/user_dao.dart';
import '../daos/settings_dao.dart';

class SqliteIdentityRepository implements IdentityRepository {
  final Database db;
  final UserDao userDao;
  final SettingsDao settingsDao;

  SqliteIdentityRepository(this.db)
      : userDao = UserDao(db),
        settingsDao = SettingsDao(db);

  @override
  Future<User?> loadUser() async {
    final res = userDao.fetchActiveUser();
    if (res.isEmpty) return null;
    final row = res.first;
    final userId = row['id'] as String;

    final profRes = userDao.fetchUserProfile(userId);
    final name = profRes.isNotEmpty ? (profRes.first['display_name'] as String) : 'Learner';
    final email = row['email'] as String? ?? 'learner@dilang.ai';

    return User(
      id: userId,
      displayName: name,
      email: email,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  Future<void> createUser(User user) async {
    user.validate();
    userDao.insertUser(
      id: user.id,
      username: user.displayName.toLowerCase().replaceAll(' ', '_'),
      email: user.email,
      createdAt: user.createdAt,
      lastActiveAt: user.updatedAt,
    );

    userDao.insertProfile(
      userId: user.id,
      displayName: user.displayName,
      avatarUrl: '',
      nativeLanguage: 'English',
      timezone: DateTime.now().timeZoneName,
    );
  }

  @override
  Future<void> updateUser(User user) async {
    user.validate();
    db.execute('UPDATE profiles SET display_name = ? WHERE user_id = ?;', [user.displayName, user.id]);
  }

  @override
  Future<LanguageProfile?> loadLanguageProfile(String userId) async {
    final res = userDao.fetchLanguageProfile(userId);
    if (res.isEmpty) return null;
    final row = res.first;
    final profRes = userDao.fetchUserProfile(userId);
    final nativeLang = profRes.isNotEmpty ? (profRes.first['native_language'] as String) : 'English';

    return LanguageProfile(
      userId: userId,
      targetLanguage: row['target_language'] as String,
      nativeLanguage: nativeLang,
      currentCefrLevel: row['cefr_level'] as String? ?? 'A1',
      targetCefrLevel: 'B2',
      dailyGoalMinutes: 15,
      motivation: 'Daily Conversation',
      brainModel: row['brain_model'] as String? ?? 'Conversation First',
      aiCoachPersona: row['ai_coach_persona'] as String? ?? 'Friendly',
    );
  }

  @override
  Future<void> saveLanguageProfile(LanguageProfile profile) async {
    profile.validate();
    final now = DateTime.now().millisecondsSinceEpoch;
    userDao.insertLanguageProfile(
      id: 'lp_$now',
      userId: profile.userId,
      targetLanguage: profile.targetLanguage,
      cefrLevel: profile.currentCefrLevel,
      learningGoal: profile.motivation,
      dailyGoalMinutes: profile.dailyGoalMinutes,
      brainModel: profile.brainModel,
      aiCoachPersona: profile.aiCoachPersona,
      voicePreference: 'Female',
    );
  }

  @override
  Future<LearningPreferences> loadPreferences() async {
    final completed = settingsDao.getSetting('onboarding_completed') == 'true';
    final daily = int.tryParse(settingsDao.getSetting('daily_minutes') ?? '15') ?? 15;

    return LearningPreferences(
      dailyMinutes: daily,
      reminderEnabled: true,
      speechEnabled: true,
      preferredVoice: 'Female',
      interfaceLanguage: 'English',
      onboardingCompleted: completed,
    );
  }

  @override
  Future<void> savePreferences(LearningPreferences prefs) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    settingsDao.setSetting('onboarding_completed', prefs.onboardingCompleted.toString(), now);
    settingsDao.setSetting('daily_minutes', prefs.dailyMinutes.toString(), now);
  }
}
