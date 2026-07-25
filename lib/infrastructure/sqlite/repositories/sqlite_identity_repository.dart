import 'package:sqlite3/sqlite3.dart';
import '../daos/user_dao.dart';

class SqliteIdentityRepository {
  final UserDao userDao;

  SqliteIdentityRepository(Database db) : userDao = UserDao(db);

  void createLearnerIdentity({
    required String id,
    required String name,
    required String nativeLanguage,
    required String targetLanguage,
    required String brainModel,
    required String aiCoachPersona,
  }) {
    final now = DateTime.now().millisecondsSinceEpoch;
    userDao.insertUser(
      id: id,
      username: name.toLowerCase().replaceAll(' ', '_'),
      email: '${name.toLowerCase()}@dilang.ai',
      createdAt: now,
      lastActiveAt: now,
    );

    userDao.insertProfile(
      userId: id,
      displayName: name,
      avatarUrl: '',
      nativeLanguage: nativeLanguage,
      timezone: DateTime.now().timeZoneName,
    );

    userDao.insertLanguageProfile(
      id: 'lp_$now',
      userId: id,
      targetLanguage: targetLanguage,
      cefrLevel: 'A1',
      learningGoal: 'Daily Conversation',
      dailyGoalMinutes: 15,
      brainModel: brainModel,
      aiCoachPersona: aiCoachPersona,
      voicePreference: 'Female',
    );
  }
}
