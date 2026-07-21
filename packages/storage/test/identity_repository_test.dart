import 'package:test/test.dart';
import 'package:dilang_learner/learner.dart';
import 'package:dilang_storage/storage.dart';

void main() {
  group('PersistentIdentityRepository Tests', () {
    late PersistentIdentityRepository identityRepo;

    setUp(() {
      identityRepo = PersistentIdentityRepository();
    });

    test('getActiveUser returns null initially', () async {
      final user = await identityRepo.getActiveUser();
      expect(user, isNull);
    });

    test('saveUser persists DiLangUser and updates active user', () async {
      final userId = const UserId('user_1001');
      final profile = Profile(
        userId: userId,
        displayName: 'Alex Learner',
        avatarUrl: '',
        nativeLanguage: 'en',
        timezone: 'UTC',
      );
      final lp = LanguageProfile(
        id: 'lp_1',
        userId: userId,
        targetLanguage: 'de',
        cefrLevel: 'A1',
        learningGoal: 'fluency',
        dailyGoalMinutes: 15,
        isPrimary: true,
      );
      final syncAcc = const SyncAccount(
        syncId: 'sync_1001',
        isSyncEnabled: true,
        syncStatus: 'idle',
      );
      final user = DiLangUser(
        id: userId,
        username: 'alex',
        email: 'alex@example.com',
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
        profile: profile,
        languageProfiles: [lp],
        syncAccount: syncAcc,
      );

      await identityRepo.saveUser(user);

      final activeUser = await identityRepo.getActiveUser();
      expect(activeUser, isNotNull);
      expect(activeUser!.username, equals('alex'));
      expect(activeUser.primaryLanguageProfile?.targetLanguage, equals('de'));
    });
  });

  group('PersistentBootstrapRepository Tests', () {
    late PersistentBootstrapRepository bootstrapRepo;

    setUp(() {
      bootstrapRepo = PersistentBootstrapRepository();
    });

    test('isFirstLaunch returns true initially and false after completion', () async {
      expect(await bootstrapRepo.isFirstLaunch(), isTrue);
      await bootstrapRepo.markOnboardingCompleted();
      expect(await bootstrapRepo.isFirstLaunch(), isFalse);
    });
  });
}
