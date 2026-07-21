import 'dart:async';
import 'package:dilang_learner/learner.dart';
import 'package:sqlite3/sqlite3.dart';
import '../contracts/repository_contracts.dart';
import '../database/sqlite_storage_engine.dart';

class SqliteIdentityRepository implements IdentityRepositoryContract {
  final SqliteStorageEngine engine;

  SqliteIdentityRepository({required this.engine});

  Database get _db => engine.db;

  @override
  Future<DiLangUser?> getActiveUser() async {
    final userResult = _db.select(
      'SELECT id, username, email, created_at, last_active_at FROM users ORDER BY last_active_at DESC LIMIT 1;',
    );

    if (userResult.isEmpty) return null;

    final uRow = userResult.first;
    final userIdVal = uRow['id'] as String;
    final userId = UserId(userIdVal);

    // Profile query
    final profileResult = _db.select(
      'SELECT display_name, avatar_url, native_language, timezone FROM profiles WHERE user_id = ?;',
      [userIdVal],
    );

    if (profileResult.isEmpty) return null;
    final pRow = profileResult.first;

    final profile = Profile(
      userId: userId,
      displayName: pRow['display_name'] as String,
      avatarUrl: pRow['avatar_url'] as String,
      nativeLanguage: pRow['native_language'] as String,
      timezone: pRow['timezone'] as String,
    );

    // Language profiles query
    final langResult = _db.select(
      'SELECT id, target_language, cefr_level, learning_goal, daily_goal_minutes, is_primary FROM language_profiles WHERE user_id = ?;',
      [userIdVal],
    );

    final languageProfiles = langResult.map((lRow) {
      return LanguageProfile(
        id: lRow['id'] as String,
        userId: userId,
        targetLanguage: lRow['target_language'] as String,
        cefrLevel: lRow['cefr_level'] as String,
        learningGoal: lRow['learning_goal'] as String,
        dailyGoalMinutes: lRow['daily_goal_minutes'] as int,
        isPrimary: (lRow['is_primary'] as int) == 1,
      );
    }).toList();

    // Sync Account query
    final syncResult = _db.select(
      'SELECT sync_id, is_sync_enabled, last_synced_at, sync_status FROM sync_accounts WHERE user_id = ?;',
      [userIdVal],
    );

    final syncAccount = syncResult.isNotEmpty
        ? SyncAccount(
            syncId: syncResult.first['sync_id'] as String,
            isSyncEnabled: (syncResult.first['is_sync_enabled'] as int) == 1,
            lastSyncedAt: syncResult.first['last_synced_at'] != null
                ? DateTime.fromMillisecondsSinceEpoch(syncResult.first['last_synced_at'] as int)
                : null,
            syncStatus: syncResult.first['sync_status'] as String,
          )
        : SyncAccount(
            syncId: 'sync_$userIdVal',
            isSyncEnabled: true,
            syncStatus: 'idle',
          );

    return DiLangUser(
      id: userId,
      username: uRow['username'] as String,
      email: uRow['email'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(uRow['created_at'] as int),
      lastActiveAt: DateTime.fromMillisecondsSinceEpoch(uRow['last_active_at'] as int),
      profile: profile,
      languageProfiles: languageProfiles,
      syncAccount: syncAccount,
    );
  }

  @override
  Future<void> saveUser(DiLangUser user) async {
    _db.execute('BEGIN TRANSACTION;');
    try {
      _db.execute(
        '''
        INSERT INTO users (id, username, email, created_at, last_active_at)
        VALUES (?, ?, ?, ?, ?)
        ON CONFLICT(id) DO UPDATE SET
          username = excluded.username,
          email = excluded.email,
          last_active_at = excluded.last_active_at;
        ''',
        [
          user.id.value,
          user.username,
          user.email,
          user.createdAt.millisecondsSinceEpoch,
          user.lastActiveAt.millisecondsSinceEpoch,
        ],
      );

      _db.execute(
        '''
        INSERT INTO profiles (user_id, display_name, avatar_url, native_language, timezone)
        VALUES (?, ?, ?, ?, ?)
        ON CONFLICT(user_id) DO UPDATE SET
          display_name = excluded.display_name,
          avatar_url = excluded.avatar_url,
          native_language = excluded.native_language,
          timezone = excluded.timezone;
        ''',
        [
          user.id.value,
          user.profile.displayName,
          user.profile.avatarUrl,
          user.profile.nativeLanguage,
          user.profile.timezone,
        ],
      );

      for (final lp in user.languageProfiles) {
        _db.execute(
          '''
          INSERT INTO language_profiles (id, user_id, target_language, cefr_level, learning_goal, daily_goal_minutes, is_primary)
          VALUES (?, ?, ?, ?, ?, ?, ?)
          ON CONFLICT(id) DO UPDATE SET
            target_language = excluded.target_language,
            cefr_level = excluded.cefr_level,
            learning_goal = excluded.learning_goal,
            daily_goal_minutes = excluded.daily_goal_minutes,
            is_primary = excluded.is_primary;
          ''',
          [
            lp.id,
            user.id.value,
            lp.targetLanguage,
            lp.cefrLevel,
            lp.learningGoal,
            lp.dailyGoalMinutes,
            lp.isPrimary ? 1 : 0,
          ],
        );
      }

      _db.execute(
        '''
        INSERT INTO sync_accounts (sync_id, user_id, is_sync_enabled, last_synced_at, sync_status)
        VALUES (?, ?, ?, ?, ?)
        ON CONFLICT(sync_id) DO UPDATE SET
          is_sync_enabled = excluded.is_sync_enabled,
          last_synced_at = excluded.last_synced_at,
          sync_status = excluded.sync_status;
        ''',
        [
          user.syncAccount.syncId,
          user.id.value,
          user.syncAccount.isSyncEnabled ? 1 : 0,
          user.syncAccount.lastSyncedAt?.millisecondsSinceEpoch,
          user.syncAccount.syncStatus,
        ],
      );

      _db.execute('COMMIT;');
    } catch (e) {
      _db.execute('ROLLBACK;');
      rethrow;
    }
  }

  @override
  Future<List<LanguageProfile>> getLanguageProfiles(UserId userId) async {
    final user = await getActiveUser();
    if (user != null && user.id == userId) {
      return user.languageProfiles;
    }
    return [];
  }

  @override
  Future<void> updateActiveLanguage(UserId userId, String targetLanguage) async {
    _db.execute('BEGIN TRANSACTION;');
    try {
      _db.execute(
        'UPDATE language_profiles SET is_primary = 0 WHERE user_id = ?;',
        [userId.value],
      );
      _db.execute(
        'UPDATE language_profiles SET is_primary = 1 WHERE user_id = ? AND target_language = ?;',
        [userId.value, targetLanguage],
      );
      _db.execute('COMMIT;');
    } catch (e) {
      _db.execute('ROLLBACK;');
      rethrow;
    }
  }
}

class SqliteBootstrapRepository implements BootstrapRepositoryContract {
  final SqliteStorageEngine engine;

  SqliteBootstrapRepository({required this.engine});

  Database get _db => engine.db;

  @override
  Future<bool> isFirstLaunch() async {
    final res = _db.select("SELECT value FROM settings WHERE key = 'onboarding_completed';");
    if (res.isEmpty) return true;
    return res.first['value'] != 'true';
  }

  @override
  Future<void> markOnboardingCompleted() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    _db.execute(
      '''
      INSERT INTO settings (key, value, updated_at)
      VALUES ('onboarding_completed', 'true', ?)
      ON CONFLICT(key) DO UPDATE SET value = 'true', updated_at = excluded.updated_at;
      ''',
      [now],
    );
  }

  @override
  Future<Map<String, String>> loadSystemSettings() async {
    final res = _db.select('SELECT key, value FROM settings;');
    final map = <String, String>{};
    for (final row in res) {
      map[row['key'] as String] = row['value'] as String;
    }
    return Map.unmodifiable(map);
  }
}
