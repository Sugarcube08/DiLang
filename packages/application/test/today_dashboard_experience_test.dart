import 'package:test/test.dart';
import 'package:dilang_storage/storage.dart';
import 'package:dilang_application/application.dart';

void main() {
  group('Today Dashboard Experience & Acceptance Scenario Tests', () {
    late SqliteStorageEngine storageEngine;
    late SqliteIdentityRepository identityRepo;
    late SqliteBootstrapRepository bootstrapRepo;
    late CreateIdentityUseCase createIdentityUseCase;
    late TodayDashboardUseCase dashboardUseCase;

    setUp(() {
      storageEngine = SqliteStorageEngine.inMemory();
      identityRepo = SqliteIdentityRepository(engine: storageEngine);
      bootstrapRepo = SqliteBootstrapRepository(engine: storageEngine);
      createIdentityUseCase = CreateIdentityUseCase(
        identityRepo: identityRepo,
        bootstrapRepo: bootstrapRepo,
      );
      dashboardUseCase = TodayDashboardUseCase(
        identityRepo: identityRepo,
        storageEngine: storageEngine,
      );
    });

    tearDown(() {
      storageEngine.dispose();
    });

    test('Full Acceptance Scenario: Onboarding -> Today -> Session Completion -> State Update -> Relaunch Restoration', () async {
      // Step 1: User finishes onboarding
      final user = await createIdentityUseCase.execute(
        username: 'sugarcube',
        email: 'user@dilang.ai',
        displayName: 'Sugar Cube',
        nativeLanguage: 'en',
        targetLanguage: 'de',
        cefrLevel: 'A1',
        learningGoal: 'fluency',
        dailyGoalMinutes: 15,
      );
      expect(user.username, equals('sugarcube'));

      // Step 2 & 3: App opens Today -> Dashboard loads persisted user data & generates primary mission
      var vm = await dashboardUseCase.loadDashboard();
      expect(vm.username, equals('Sugar Cube'));
      expect(vm.mission.targetLanguage, equals('DE'));
      expect(vm.mission.estimatedMinutes, equals(12));
      expect(vm.health.overallScore, greaterThanOrEqualTo(60));
      expect(vm.currentStreak, equals(1));
      expect(vm.timeline.isNotEmpty, isTrue);

      // Step 4 & 5: User starts & completes a lesson -> Repositories updated via SQL transaction
      await dashboardUseCase.recordCompletedSession(
        sessionType: 'Conversation',
        title: 'Ordering at a Viennese Café',
        minutesSpent: 12,
      );

      // Step 6 & 7: Returning to Today immediately reflects new state (Streak incremented to 2, Timeline event added)
      vm = await dashboardUseCase.loadDashboard();
      expect(vm.currentStreak, equals(2));
      expect(vm.timeline.any((item) => item.title.contains('Completed Conversation')), isTrue);
      expect(vm.timeline.first.description, contains('Ordering at a Viennese Café'));

      // Step 8: Closing & reopening app preserves everything cleanly
      final newIdentityRepo = SqliteIdentityRepository(engine: storageEngine);
      final newDashboardUseCase = TodayDashboardUseCase(
        identityRepo: newIdentityRepo,
        storageEngine: storageEngine,
      );

      final restoredVm = await newDashboardUseCase.loadDashboard();
      expect(restoredVm.username, equals('Sugar Cube'));
      expect(restoredVm.currentStreak, equals(2));
      expect(restoredVm.timeline.any((item) => item.title.contains('Completed Conversation')), isTrue);
    });
  });
}
