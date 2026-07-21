import 'dart:io';
import 'package:test/test.dart';
import 'package:dilang_core/core.dart';
import 'package:dilang_storage/storage.dart';
import 'package:dilang_application/application.dart';
import 'package:dilang_conversation/conversation.dart';

void main() {
  late String dbPath;

  setUp(() {
    final tempDir = Directory.systemTemp.createTempSync('dilang_test_db_');
    dbPath = '${tempDir.path}/dilang_storage.db';
  });

  tearDown(() {
    final file = File(dbPath);
    if (file.existsSync()) {
      file.deleteSync();
    }
  });

  group('Disk Persistence & Process Restart Verification', () {
    test('Learner Profile and Replays survive disk process restart', () async {
      final eventBus = EventBus();

      // Process 1: Save User & Session Replay
      {
        final engine1 = SqliteStorageEngine(dbPath: dbPath);
        final identityRepo1 = SqliteIdentityRepository(engine: engine1);
        final replayRepo1 = SqliteReplayRepository(engine: engine1);
        final intelRepo1 = SqliteIntelligenceRepository(engine: engine1);

        final kernel1 = DiLangRuntimeKernel(
          eventBus: eventBus,
          storageEngine: engine1,
          identityRepo: identityRepo1,
          replayRepo: replayRepo1,
          intelRepo: intelRepo1,
        );

        await kernel1.createLearnerProfile(
          name: 'SugarCube',
          mediumLanguage: 'English',
          targetLanguage: 'German',
          brainModel: 'Conversation First',
          learningGoal: 'Daily Conversation',
          aiCoachPersona: 'Friendly',
        );

        kernel1.startSession(BuiltInScenarios.ScenarioCafeVienna);
        kernel1.submitTurn('Ich möchte einen heißen Kaffee, bitte.');
        await kernel1.completeSession();

        expect(kernel1.state.learner?.profile.displayName, equals('SugarCube'));
        expect(kernel1.state.completedSessionsCount, equals(1));

        engine1.dispose();
      }

      // Process 2: Relaunch from Disk & Verify Restoration
      {
        final engine2 = SqliteStorageEngine(dbPath: dbPath);
        final identityRepo2 = SqliteIdentityRepository(engine: engine2);
        final replayRepo2 = SqliteReplayRepository(engine: engine2);
        final intelRepo2 = SqliteIntelligenceRepository(engine: engine2);

        final kernel2 = DiLangRuntimeKernel(
          eventBus: eventBus,
          storageEngine: engine2,
          identityRepo: identityRepo2,
          replayRepo: replayRepo2,
          intelRepo: intelRepo2,
        );

        await kernel2.initializeRuntime();

        expect(kernel2.state.isOnboardingRequired, isFalse);
        expect(kernel2.state.learner, isNotNull);
        expect(kernel2.state.learner?.profile.displayName, equals('SugarCube'));
        expect(kernel2.state.learner?.profile.nativeLanguage, equals('English'));
        expect(kernel2.state.learner?.primaryLanguageProfile?.targetLanguage, equals('German'));
        expect(kernel2.state.completedSessionsCount, equals(1));
        expect(kernel2.state.sessionHistory.length, equals(1));
        expect(kernel2.state.currentStreak, equals(1));

        engine2.dispose();
      }
    });
  });
}
