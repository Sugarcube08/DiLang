import 'package:flutter_test/flutter_test.dart';
import 'package:dilang/infrastructure/sqlite/sqlite_storage_engine.dart';
import 'package:dilang/infrastructure/sqlite/daos/user_dao.dart';
import 'package:dilang/infrastructure/sqlite/daos/learning_dao.dart';
import 'package:dilang/infrastructure/sqlite/daos/conversation_dao.dart';
import 'package:dilang/infrastructure/sqlite/daos/knowledge_graph_dao.dart';
import 'package:dilang/infrastructure/sqlite/daos/settings_dao.dart';
import 'package:dilang/infrastructure/sqlite/daos/diagnostics_dao.dart';
import 'package:dilang/infrastructure/sqlite/repositories/sqlite_identity_repository.dart';
import 'package:dilang/modules/identity/models/user.dart';
import 'package:dilang/modules/identity/models/language_profile.dart';

void main() {
  group('Step 3 SQLite Infrastructure & Persistence Tests', () {
    late SqliteStorageEngine engine;

    setUp(() {
      engine = SqliteStorageEngine.inMemory();
    });

    tearDown(() {
      engine.dispose();
    });

    test('1. Executes 5 versioned schema migrations and tracks version 5 in schema_migrations', () {
      final res = engine.db.select('SELECT MAX(version) as ver FROM schema_migrations;');
      expect(res.first['ver'], equals(5));
    });

    test('2. UserDao performs inserts and selects via isolated SQL layer', () {
      final userDao = UserDao(engine.db);
      final now = DateTime.now().millisecondsSinceEpoch;

      userDao.insertUser(
        id: 'usr_101',
        username: 'learner_101',
        email: 'learner101@dilang.ai',
        createdAt: now,
        lastActiveAt: now,
      );

      final users = userDao.fetchActiveUser();
      expect(users.length, equals(1));
      expect(users.first['username'], equals('learner_101'));
    });

    test('3. LearningDao stores and queries FSRS memory cards with next_review index', () {
      final userDao = UserDao(engine.db);
      final dao = LearningDao(engine.db);
      final now = DateTime.now().millisecondsSinceEpoch;

      userDao.insertUser(
        id: 'usr_101',
        username: 'learner_101',
        email: 'learner101@dilang.ai',
        createdAt: now,
        lastActiveAt: now,
      );

      dao.insertFsrsCard(
        cardId: 'card_1',
        userId: 'usr_101',
        stability: 2.5,
        difficulty: 5.0,
        elapsedDays: 0,
        scheduledDays: 1,
        reps: 1,
        state: 1,
        nextReview: now - 100,
      );

      final dueCards = dao.fetchDueFsrsCards('usr_101', now);
      expect(dueCards.length, equals(1));
      expect(dueCards.first['card_id'], equals('card_1'));
    });

    test('4. ConversationDao & SqliteIdentityRepository execute transactionally', () async {
      final repo = SqliteIdentityRepository(engine.db);
      final now = DateTime.now().millisecondsSinceEpoch;

      final u = User(
        id: 'usr_202',
        displayName: 'Jane Learner',
        email: 'jane@dilang.ai',
        createdAt: now,
        updatedAt: now,
      );
      const lp = LanguageProfile(
        userId: 'usr_202',
        targetLanguage: 'German',
        nativeLanguage: 'English',
        currentCefrLevel: 'A1',
        targetCefrLevel: 'B2',
        dailyGoalMinutes: 15,
        motivation: 'Work',
        brainModel: 'Conversation First',
        aiCoachPersona: 'Friendly',
      );

      await repo.createUser(u);
      await repo.saveLanguageProfile(lp);

      final convDao = ConversationDao(engine.db);
      convDao.insertSession(
        sessionId: 'sess_1',
        userId: 'usr_202',
        scenarioId: 'scen_cafe',
        startTime: now,
      );

      convDao.insertReplay(
        transcriptId: 'tr_1',
        sessionId: 'sess_1',
        scenarioId: 'scen_cafe',
        timestamp: now,
        confidenceBefore: 70,
        confidenceAfter: 85,
        evidenceSummary: 'Good cafe order fluency',
        turnsJson: '[]',
      );

      final replays = convDao.fetchReplaysForSession('sess_1');
      expect(replays.length, equals(1));
      expect(replays.first['scenario_id'], equals('scen_cafe'));
    });

    test('5. SettingsDao & DiagnosticsDao persist settings and runtime logs', () {
      final settingsDao = SettingsDao(engine.db);
      final diagnosticsDao = DiagnosticsDao(engine.db);
      final now = DateTime.now().millisecondsSinceEpoch;

      settingsDao.setSetting('theme', 'dark', now);
      expect(settingsDao.getSetting('theme'), equals('dark'));

      diagnosticsDao.insertLog(
        logId: 'log_1',
        level: 'INFO',
        message: 'Database initialized cleanly',
        module: 'sqlite',
        timestamp: now,
      );

      final logs = diagnosticsDao.fetchRecentLogs(10);
      expect(logs.length, equals(1));
      expect(logs.first['message'], equals('Database initialized cleanly'));
    });

    test('6. KnowledgeGraphDao inserts nodes and queries by language index', () {
      final kgDao = KnowledgeGraphDao(engine.db);
      kgDao.insertNode(
        nodeId: 'node_de_1',
        word: 'Guten Tag',
        targetLanguage: 'German',
        cefrLevel: 'A1',
        masteryScore: 0.95,
      );

      final nodes = kgDao.fetchNodesForLanguage('German');
      expect(nodes.length, equals(1));
      expect(nodes.first['word'], equals('Guten Tag'));
    });
  });
}
