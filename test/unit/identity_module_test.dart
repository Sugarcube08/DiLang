import 'package:flutter_test/flutter_test.dart';
import 'package:dilang/infrastructure/sqlite/sqlite_storage_engine.dart';
import 'package:dilang/infrastructure/sqlite/repositories/sqlite_identity_repository.dart';
import 'package:dilang/modules/identity/models/user.dart';
import 'package:dilang/modules/identity/models/language_profile.dart';
import 'package:dilang/modules/identity/models/learning_preferences.dart';
import 'package:dilang/modules/identity/models/identity_state.dart';

void main() {
  group('Step 4 Identity Module Tests', () {
    late SqliteStorageEngine engine;
    late SqliteIdentityRepository repo;

    setUp(() {
      engine = SqliteStorageEngine.inMemory();
      repo = SqliteIdentityRepository(engine.db);
    });

    tearDown(() {
      engine.dispose();
    });

    test('1. Validates User and LanguageProfile domain models', () {
      const validUser = User(
        id: 'u1',
        displayName: 'Alice',
        email: 'alice@dilang.ai',
        createdAt: 100,
        updatedAt: 100,
      );
      expect(() => validUser.validate(), returnsNormally);

      const invalidUser = User(
        id: 'u2',
        displayName: '',
        email: 'invalid',
        createdAt: 100,
        updatedAt: 100,
      );
      expect(() => invalidUser.validate(), throwsArgumentError);
    });

    test('2. IdentityRepository creates, persists, and reloads User, LanguageProfile, and Preferences', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      final user = User(
        id: 'usr_303',
        displayName: 'Marcus Learner',
        email: 'marcus@dilang.ai',
        createdAt: now,
        updatedAt: now,
      );

      const langProfile = LanguageProfile(
        userId: 'usr_303',
        targetLanguage: 'German',
        nativeLanguage: 'English',
        currentCefrLevel: 'A1',
        targetCefrLevel: 'B2',
        dailyGoalMinutes: 30,
        motivation: 'Work',
        brainModel: 'Conversation First',
        aiCoachPersona: 'Friendly',
      );

      const prefs = LearningPreferences(
        dailyMinutes: 30,
        reminderEnabled: true,
        speechEnabled: true,
        preferredVoice: 'Female',
        interfaceLanguage: 'English',
        onboardingCompleted: true,
      );

      await repo.createUser(user);
      await repo.saveLanguageProfile(langProfile);
      await repo.savePreferences(prefs);

      final loadedUser = await repo.loadUser();
      expect(loadedUser, isNotNull);
      expect(loadedUser!.displayName, equals('Marcus Learner'));

      final loadedProfile = await repo.loadLanguageProfile('usr_303');
      expect(loadedProfile, isNotNull);
      expect(loadedProfile!.targetLanguage, equals('German'));

      final loadedPrefs = await repo.loadPreferences();
      expect(loadedPrefs.onboardingCompleted, isTrue);
    });

    test('3. IdentityState transitions cleanly through finite states', () {
      final uninit = IdentityState.uninitialized();
      expect(uninit.status, equals(IdentityStatus.uninitialized));

      final ready = IdentityState.ready();
      expect(ready.isReady, isTrue);
      expect(ready.isOnboardingRequired, isFalse);
    });
  });
}
