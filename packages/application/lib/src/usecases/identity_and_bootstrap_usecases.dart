import 'dart:async';
import 'package:dilang_learner/learner.dart';
import 'package:dilang_storage/storage.dart';

enum BootstrapStatus {
  uninitialized,
  onboardingRequired,
  authenticatedReady,
  failed,
}

class BootstrapResult {
  final BootstrapStatus status;
  final DiLangUser? user;
  final Map<String, String> settings;
  final String? errorMessage;

  const BootstrapResult({
    required this.status,
    this.user,
    this.settings = const {},
    this.errorMessage,
  });
}

class BootstrapAppUseCase {
  final BootstrapRepositoryContract bootstrapRepo;
  final IdentityRepositoryContract identityRepo;

  const BootstrapAppUseCase({
    required this.bootstrapRepo,
    required this.identityRepo,
  });

  Future<BootstrapResult> execute() async {
    try {
      final isFirstLaunch = await bootstrapRepo.isFirstLaunch();
      final settings = await bootstrapRepo.loadSystemSettings();

      if (isFirstLaunch) {
        return BootstrapResult(
          status: BootstrapStatus.onboardingRequired,
          settings: settings,
        );
      }

      final activeUser = await identityRepo.getActiveUser();
      if (activeUser == null) {
        return BootstrapResult(
          status: BootstrapStatus.onboardingRequired,
          settings: settings,
        );
      }

      return BootstrapResult(
        status: BootstrapStatus.authenticatedReady,
        user: activeUser,
        settings: settings,
      );
    } catch (e) {
      return BootstrapResult(
        status: BootstrapStatus.failed,
        errorMessage: e.toString(),
      );
    }
  }
}

class CreateIdentityUseCase {
  final IdentityRepositoryContract identityRepo;
  final BootstrapRepositoryContract bootstrapRepo;

  const CreateIdentityUseCase({
    required this.identityRepo,
    required this.bootstrapRepo,
  });

  Future<DiLangUser> execute({
    required String username,
    required String email,
    required String displayName,
    required String nativeLanguage,
    required String targetLanguage,
    required String cefrLevel,
    required String learningGoal,
    required int dailyGoalMinutes,
  }) async {
    final now = DateTime.now();
    final userId = UserId('user_${now.millisecondsSinceEpoch}');

    final profile = Profile(
      userId: userId,
      displayName: displayName.isNotEmpty ? displayName : username,
      avatarUrl: '',
      nativeLanguage: nativeLanguage,
      timezone: DateTime.now().timeZoneName,
    );

    final languageProfile = LanguageProfile(
      id: 'lp_${now.millisecondsSinceEpoch}',
      userId: userId,
      targetLanguage: targetLanguage,
      cefrLevel: cefrLevel,
      learningGoal: learningGoal,
      dailyGoalMinutes: dailyGoalMinutes,
      isPrimary: true,
    );

    final syncAccount = SyncAccount(
      syncId: 'sync_${userId.value}',
      isSyncEnabled: true,
      lastSyncedAt: null,
      syncStatus: 'idle',
    );

    final user = DiLangUser(
      id: userId,
      username: username,
      email: email,
      createdAt: now,
      lastActiveAt: now,
      profile: profile,
      languageProfiles: [languageProfile],
      syncAccount: syncAccount,
    );

    await identityRepo.saveUser(user);
    await bootstrapRepo.markOnboardingCompleted();

    return user;
  }
}
