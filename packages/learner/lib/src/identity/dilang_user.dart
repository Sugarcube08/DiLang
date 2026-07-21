import 'package:equatable/equatable.dart';

class UserId extends Equatable {
  final String value;
  const UserId(this.value);

  @override
  List<Object?> get props => [value];
}

class DeviceId extends Equatable {
  final String value;
  const DeviceId(this.value);

  @override
  List<Object?> get props => [value];
}

class SyncAccount extends Equatable {
  final String syncId;
  final bool isSyncEnabled;
  final DateTime? lastSyncedAt;
  final String syncStatus; // "idle", "syncing", "error", "disabled"

  const SyncAccount({
    required this.syncId,
    required this.isSyncEnabled,
    this.lastSyncedAt,
    required this.syncStatus,
  });

  @override
  List<Object?> get props => [syncId, isSyncEnabled, lastSyncedAt, syncStatus];
}

class Device extends Equatable {
  final DeviceId id;
  final String deviceName;
  final String platform;
  final DateTime registeredAt;

  const Device({
    required this.id,
    required this.deviceName,
    required this.platform,
    required this.registeredAt,
  });

  @override
  List<Object?> get props => [id, deviceName, platform, registeredAt];
}

class Profile extends Equatable {
  final UserId userId;
  final String displayName;
  final String avatarUrl;
  final String nativeLanguage;
  final String timezone;

  const Profile({
    required this.userId,
    required this.displayName,
    required this.avatarUrl,
    required this.nativeLanguage,
    required this.timezone,
  });

  @override
  List<Object?> get props => [userId, displayName, avatarUrl, nativeLanguage, timezone];
}

class LanguageProfile extends Equatable {
  final String id;
  final UserId userId;
  final String targetLanguage;
  final String cefrLevel;
  final String learningGoal;
  final int dailyGoalMinutes;
  final bool isPrimary;
  final String brainModel;
  final String aiCoachPersona;
  final String voicePreference;

  const LanguageProfile({
    required this.id,
    required this.userId,
    required this.targetLanguage,
    required this.cefrLevel,
    required this.learningGoal,
    required this.dailyGoalMinutes,
    required this.isPrimary,
    this.brainModel = 'Conversation First',
    this.aiCoachPersona = 'Friendly',
    this.voicePreference = 'Female',
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        targetLanguage,
        cefrLevel,
        learningGoal,
        dailyGoalMinutes,
        isPrimary,
        brainModel,
        aiCoachPersona,
        voicePreference,
      ];
}

class DiLangUser extends Equatable {
  final UserId id;
  final String username;
  final String email;
  final DateTime createdAt;
  final DateTime lastActiveAt;
  final Profile profile;
  final List<LanguageProfile> languageProfiles;
  final SyncAccount syncAccount;

  const DiLangUser({
    required this.id,
    required this.username,
    required this.email,
    required this.createdAt,
    required this.lastActiveAt,
    required this.profile,
    required this.languageProfiles,
    required this.syncAccount,
  });

  LanguageProfile? get primaryLanguageProfile {
    for (final lp in languageProfiles) {
      if (lp.isPrimary) return lp;
    }
    return languageProfiles.isNotEmpty ? languageProfiles.first : null;
  }

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        createdAt,
        lastActiveAt,
        profile,
        languageProfiles,
        syncAccount,
      ];
}
