import 'dart:ffi';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3/open.dart';

class SqliteStorageEngine {
  late Database _db;
  final String dbPath;
  bool _isDisposed = false;

  static const int currentSchemaVersion = 1;
  static bool _ffiInitialized = false;

  static void _initFfi() {
    if (_ffiInitialized) return;
    _ffiInitialized = true;
    if (Platform.isLinux) {
      open.overrideFor(OperatingSystem.linux, () {
        try {
          return DynamicLibrary.open('/usr/lib/x86_64-linux-gnu/libsqlite3.so.0');
        } catch (_) {
          return DynamicLibrary.open('libsqlite3.so.0');
        }
      });
    }
  }

  SqliteStorageEngine({required this.dbPath}) {
    _initFfi();
    _initDatabase();
  }

  factory SqliteStorageEngine.inMemory() {
    return SqliteStorageEngine(dbPath: ':memory:');
  }

  Database get db {
    if (_isDisposed) {
      throw StateError('SqliteStorageEngine has been disposed');
    }
    return _db;
  }

  void _initDatabase() {
    if (dbPath != ':memory:') {
      final dir = Directory(p.dirname(dbPath));
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }
    }

    try {
      _db = sqlite3.open(dbPath);
      _db.execute('PRAGMA foreign_keys = ON;');
      if (dbPath != ':memory:') {
        _db.execute('PRAGMA journal_mode = WAL;');
      }
      _runIntegrityCheck();
    } catch (e) {
      if (dbPath != ':memory:') {
        final corruptedFile = File(dbPath);
        if (corruptedFile.existsSync()) {
          corruptedFile.copySync('$dbPath.corrupted.${DateTime.now().millisecondsSinceEpoch}');
          corruptedFile.deleteSync();
        }
      }
      _db = sqlite3.open(dbPath);
      _db.execute('PRAGMA foreign_keys = ON;');
    }

    _applyMigrations();
  }

  void _runIntegrityCheck() {
    final result = _db.select('PRAGMA quick_check;');
    if (result.isEmpty || result.first['quick_check'] != 'ok') {
      _db.dispose();
      if (dbPath != ':memory:') {
        final corruptedFile = File(dbPath);
        if (corruptedFile.existsSync()) {
          corruptedFile.copySync('$dbPath.corrupted.${DateTime.now().millisecondsSinceEpoch}');
          corruptedFile.deleteSync();
        }
      }
      _db = sqlite3.open(dbPath);
      _db.execute('PRAGMA foreign_keys = ON;');
    }
  }

  void _applyMigrations() {
    _db.execute('''
      CREATE TABLE IF NOT EXISTS schema_migrations (
        version INTEGER PRIMARY KEY,
        applied_at INTEGER NOT NULL
      );
    ''');

    final result = _db.select('SELECT MAX(version) as current_ver FROM schema_migrations;');
    final currentVer = (result.first['current_ver'] as int?) ?? 0;

    if (currentVer < 1) {
      _db.execute('BEGIN TRANSACTION;');
      try {
        _db.execute('''
          CREATE TABLE users (
            id TEXT PRIMARY KEY,
            username TEXT NOT NULL,
            email TEXT NOT NULL,
            created_at INTEGER NOT NULL,
            last_active_at INTEGER NOT NULL
          );

          CREATE TABLE profiles (
            user_id TEXT PRIMARY KEY,
            display_name TEXT NOT NULL,
            avatar_url TEXT NOT NULL,
            native_language TEXT NOT NULL,
            timezone TEXT NOT NULL,
            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
          );

          CREATE TABLE language_profiles (
            id TEXT PRIMARY KEY,
            user_id TEXT NOT NULL,
            target_language TEXT NOT NULL,
            cefr_level TEXT NOT NULL,
            learning_goal TEXT NOT NULL,
            daily_goal_minutes INTEGER NOT NULL,
            is_primary INTEGER NOT NULL DEFAULT 0,
            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
          );

          CREATE TABLE sync_accounts (
            sync_id TEXT PRIMARY KEY,
            user_id TEXT NOT NULL,
            is_sync_enabled INTEGER NOT NULL DEFAULT 1,
            last_synced_at INTEGER,
            sync_status TEXT NOT NULL,
            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
          );

          CREATE TABLE sync_change_log (
            id TEXT PRIMARY KEY,
            entity_type TEXT NOT NULL,
            entity_id TEXT NOT NULL,
            action TEXT NOT NULL,
            payload TEXT NOT NULL,
            timestamp INTEGER NOT NULL,
            synced INTEGER NOT NULL DEFAULT 0
          );

          CREATE TABLE settings (
            key TEXT PRIMARY KEY,
            value TEXT NOT NULL,
            updated_at INTEGER NOT NULL
          );

          CREATE TABLE replay_transcripts (
            transcript_id TEXT PRIMARY KEY,
            session_id TEXT NOT NULL,
            scenario_id TEXT NOT NULL,
            timestamp INTEGER NOT NULL,
            confidence_before INTEGER NOT NULL,
            confidence_after INTEGER NOT NULL,
            evidence_summary TEXT NOT NULL,
            turns_json TEXT NOT NULL
          );

          CREATE TABLE cognitive_models (
            user_id TEXT PRIMARY KEY,
            vocab_mastery REAL NOT NULL,
            grammar_mastery REAL NOT NULL,
            recall_stability REAL NOT NULL,
            cefr_readiness REAL NOT NULL,
            updated_at INTEGER NOT NULL
          );

          CREATE TABLE error_intelligence (
            error_id TEXT PRIMARY KEY,
            user_id TEXT NOT NULL,
            mistake_text TEXT NOT NULL,
            error_category TEXT NOT NULL,
            underlying_cause TEXT NOT NULL,
            occurrences INTEGER NOT NULL,
            recoveries INTEGER NOT NULL,
            intervention TEXT NOT NULL
          );

          CREATE INDEX idx_language_profiles_user ON language_profiles(user_id);
          CREATE INDEX idx_sync_change_log_synced ON sync_change_log(synced);
          CREATE INDEX idx_replay_transcripts_session ON replay_transcripts(session_id);
          CREATE INDEX idx_error_intelligence_user ON error_intelligence(user_id);

          INSERT INTO schema_migrations (version, applied_at) 
          VALUES (1, ${DateTime.now().millisecondsSinceEpoch});
        ''');
        _db.execute('COMMIT;');
      } catch (e) {
        _db.execute('ROLLBACK;');
        rethrow;
      }
    }
  }

  void dispose() {
    if (!_isDisposed) {
      _db.dispose();
      _isDisposed = true;
    }
  }
}
