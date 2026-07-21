import 'dart:async';
import 'package:dilang_learner/learner.dart';
import '../contracts/repository_contracts.dart';

class PersistentIdentityRepository implements IdentityRepositoryContract {
  DiLangUser? _cachedUser;
  final Map<String, LanguageProfile> _languageProfiles = {};

  PersistentIdentityRepository({DiLangUser? initialUser}) : _cachedUser = initialUser;

  @override
  Future<DiLangUser?> getActiveUser() async {
    return _cachedUser;
  }

  @override
  Future<void> saveUser(DiLangUser user) async {
    _cachedUser = user;
    for (final lp in user.languageProfiles) {
      _languageProfiles[lp.id] = lp;
    }
  }

  @override
  Future<List<LanguageProfile>> getLanguageProfiles(UserId userId) async {
    if (_cachedUser != null && _cachedUser!.id == userId) {
      return _cachedUser!.languageProfiles;
    }
    return _languageProfiles.values.where((lp) => lp.userId == userId).toList();
  }

  @override
  Future<void> updateActiveLanguage(UserId userId, String targetLanguage) async {
    if (_cachedUser != null && _cachedUser!.id == userId) {
      final updatedProfiles = _cachedUser!.languageProfiles.map((lp) {
        return LanguageProfile(
          id: lp.id,
          userId: lp.userId,
          targetLanguage: lp.targetLanguage,
          cefrLevel: lp.cefrLevel,
          learningGoal: lp.learningGoal,
          dailyGoalMinutes: lp.dailyGoalMinutes,
          isPrimary: lp.targetLanguage == targetLanguage,
        );
      }).toList();

      _cachedUser = DiLangUser(
        id: _cachedUser!.id,
        username: _cachedUser!.username,
        email: _cachedUser!.email,
        createdAt: _cachedUser!.createdAt,
        lastActiveAt: DateTime.now(),
        profile: _cachedUser!.profile,
        languageProfiles: updatedProfiles,
        syncAccount: _cachedUser!.syncAccount,
      );
    }
  }
}

class PersistentBootstrapRepository implements BootstrapRepositoryContract {
  bool _firstLaunch = true;
  final Map<String, String> _settings = {};

  PersistentBootstrapRepository({bool isFirstLaunch = true}) : _firstLaunch = isFirstLaunch;

  @override
  Future<bool> isFirstLaunch() async {
    return _firstLaunch;
  }

  @override
  Future<void> markOnboardingCompleted() async {
    _firstLaunch = false;
    _settings['onboarding_completed'] = 'true';
    _settings['onboarding_completed_at'] = DateTime.now().toIso8601String();
  }

  @override
  Future<Map<String, String>> loadSystemSettings() async {
    return Map.unmodifiable(_settings);
  }
}
