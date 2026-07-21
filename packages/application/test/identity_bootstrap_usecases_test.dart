import 'package:test/test.dart';
import 'package:dilang_storage/storage.dart';
import 'package:dilang_application/application.dart';

void main() {
  group('Identity & Bootstrap UseCases Integration Tests', () {
    late PersistentBootstrapRepository bootstrapRepo;
    late PersistentIdentityRepository identityRepo;
    late BootstrapAppUseCase bootstrapUseCase;
    late CreateIdentityUseCase createIdentityUseCase;

    setUp(() {
      bootstrapRepo = PersistentBootstrapRepository();
      identityRepo = PersistentIdentityRepository();
      bootstrapUseCase = BootstrapAppUseCase(
        bootstrapRepo: bootstrapRepo,
        identityRepo: identityRepo,
      );
      createIdentityUseCase = CreateIdentityUseCase(
        identityRepo: identityRepo,
        bootstrapRepo: bootstrapRepo,
      );
    });

    test('Fresh launch requires onboarding', () async {
      final result = await bootstrapUseCase.execute();
      expect(result.status, equals(BootstrapStatus.onboardingRequired));
      expect(result.user, isNull);
    });

    test('Creating identity marks onboarding completed and returns active user on subsequent boot', () async {
      // 1. First Launch
      final initialBoot = await bootstrapUseCase.execute();
      expect(initialBoot.status, equals(BootstrapStatus.onboardingRequired));

      // 2. User completes onboarding wizard
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
      expect(user.profile.displayName, equals('Sugar Cube'));
      expect(user.primaryLanguageProfile?.targetLanguage, equals('de'));

      // 3. Second Launch (bypasses onboarding directly to Today Dashboard)
      final secondBoot = await bootstrapUseCase.execute();
      expect(secondBoot.status, equals(BootstrapStatus.authenticatedReady));
      expect(secondBoot.user, isNotNull);
      expect(secondBoot.user!.username, equals('sugarcube'));
    });
  });
}
