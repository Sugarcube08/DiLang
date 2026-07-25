import 'dart:ffi';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3/open.dart';

class SqliteStorageEngine {
  late Database _db;
  final String dbPath;
  bool _isDisposed = false;

  static const int currentSchemaVersion = 5;
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
    int currentVer = (result.first['current_ver'] as int?) ?? 0;

    if (currentVer < 1) {
      _db.execute('BEGIN TRANSACTION;');
      try {
        _db.execute('''
          CREATE TABLE IF NOT EXISTS users (
            id TEXT PRIMARY KEY,
            username TEXT NOT NULL,
            email TEXT NOT NULL,
            created_at INTEGER NOT NULL,
            last_active_at INTEGER NOT NULL
          );

          CREATE TABLE IF NOT EXISTS profiles (
            user_id TEXT PRIMARY KEY,
            display_name TEXT NOT NULL,
            avatar_url TEXT NOT NULL,
            native_language TEXT NOT NULL,
            timezone TEXT NOT NULL,
            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
          );

          CREATE TABLE IF NOT EXISTS language_profiles (
            id TEXT PRIMARY KEY,
            user_id TEXT NOT NULL,
            target_language TEXT NOT NULL,
            cefr_level TEXT NOT NULL,
            learning_goal TEXT NOT NULL,
            daily_goal_minutes INTEGER NOT NULL,
            is_primary INTEGER NOT NULL DEFAULT 0,
            brain_model TEXT NOT NULL DEFAULT 'Conversation First',
            ai_coach_persona TEXT NOT NULL DEFAULT 'Friendly',
            voice_preference TEXT NOT NULL DEFAULT 'Female',
            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
          );

          CREATE INDEX IF NOT EXISTS idx_language_profiles_user ON language_profiles(user_id);
          CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

          INSERT INTO schema_migrations (version, applied_at) VALUES (1, ${DateTime.now().millisecondsSinceEpoch});
        ''');
        _db.execute('COMMIT;');
        currentVer = 1;
      } catch (e) {
        _db.execute('ROLLBACK;');
        rethrow;
      }
    }

    if (currentVer < 2) {
      _db.execute('BEGIN TRANSACTION;');
      try {
        _db.execute('''
          CREATE TABLE IF NOT EXISTS fsrs_cards (
            card_id TEXT PRIMARY KEY,
            user_id TEXT NOT NULL,
            stability REAL NOT NULL,
            difficulty REAL NOT NULL,
            elapsed_days INTEGER NOT NULL,
            scheduled_days INTEGER NOT NULL,
            reps INTEGER NOT NULL,
            state INTEGER NOT NULL,
            next_review INTEGER NOT NULL,
            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
          );

          CREATE TABLE IF NOT EXISTS learning_sessions (
            session_id TEXT PRIMARY KEY,
            user_id TEXT NOT NULL,
            duration_seconds INTEGER NOT NULL,
            items_reviewed INTEGER NOT NULL,
            timestamp INTEGER NOT NULL
          );

          CREATE TABLE IF NOT EXISTS learning_reviews (
            review_id TEXT PRIMARY KEY,
            card_id TEXT NOT NULL,
            rating INTEGER NOT NULL,
            review_time INTEGER NOT NULL
          );

          CREATE TABLE IF NOT EXISTS missions (
            mission_id TEXT PRIMARY KEY,
            user_id TEXT NOT NULL,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            target_language TEXT NOT NULL,
            xp_reward INTEGER NOT NULL,
            is_completed INTEGER NOT NULL DEFAULT 0
          );

          CREATE INDEX IF NOT EXISTS idx_fsrs_next_review ON fsrs_cards(next_review);
          CREATE INDEX IF NOT EXISTS idx_learning_sessions_user ON learning_sessions(user_id);
          CREATE INDEX IF NOT EXISTS idx_reviews_card_id ON learning_reviews(card_id);
          CREATE INDEX IF NOT EXISTS idx_missions_status ON missions(user_id, is_completed);

          INSERT INTO schema_migrations (version, applied_at) VALUES (2, ${DateTime.now().millisecondsSinceEpoch});
        ''');
        _db.execute('COMMIT;');
        currentVer = 2;
      } catch (e) {
        _db.execute('ROLLBACK;');
        rethrow;
      }
    }

    if (currentVer < 3) {
      _db.execute('BEGIN TRANSACTION;');
      try {
        _db.execute('''
          CREATE TABLE IF NOT EXISTS conversation_sessions (
            session_id TEXT PRIMARY KEY,
            user_id TEXT NOT NULL,
            scenario_id TEXT NOT NULL,
            start_time INTEGER NOT NULL,
            is_completed INTEGER NOT NULL DEFAULT 0
          );

          CREATE TABLE IF NOT EXISTS conversation_turns (
            turn_id TEXT PRIMARY KEY,
            session_id TEXT NOT NULL,
            turn_index INTEGER NOT NULL,
            speaker TEXT NOT NULL,
            text TEXT NOT NULL,
            phonetics_ipa TEXT NOT NULL,
            timestamp INTEGER NOT NULL
          );

          CREATE TABLE IF NOT EXISTS conversation_replays (
            transcript_id TEXT PRIMARY KEY,
            session_id TEXT NOT NULL,
            scenario_id TEXT NOT NULL,
            timestamp INTEGER NOT NULL,
            confidence_before INTEGER NOT NULL,
            confidence_after INTEGER NOT NULL,
            evidence_summary TEXT NOT NULL,
            turns_json TEXT NOT NULL
          );

          CREATE INDEX IF NOT EXISTS idx_conv_sessions_user ON conversation_sessions(user_id);
          CREATE INDEX IF NOT EXISTS idx_conversation_turns_session ON conversation_turns(session_id);
          CREATE INDEX IF NOT EXISTS idx_replays_session ON conversation_replays(session_id);

          INSERT INTO schema_migrations (version, applied_at) VALUES (3, ${DateTime.now().millisecondsSinceEpoch});
        ''');
        _db.execute('COMMIT;');
        currentVer = 3;
      } catch (e) {
        _db.execute('ROLLBACK;');
        rethrow;
      }
    }

    if (currentVer < 4) {
      _db.execute('BEGIN TRANSACTION;');
      try {
        _db.execute('''
          CREATE TABLE IF NOT EXISTS knowledge_nodes (
            node_id TEXT PRIMARY KEY,
            word TEXT NOT NULL,
            target_language TEXT NOT NULL,
            cefr_level TEXT NOT NULL,
            mastery_score REAL NOT NULL
          );

          CREATE TABLE IF NOT EXISTS knowledge_edges (
            edge_id TEXT PRIMARY KEY,
            source_node_id TEXT NOT NULL,
            target_node_id TEXT NOT NULL,
            relation_type TEXT NOT NULL,
            weight REAL NOT NULL
          );

          CREATE TABLE IF NOT EXISTS vocabulary (
            vocab_id TEXT PRIMARY KEY,
            word TEXT NOT NULL,
            phonetics_ipa TEXT NOT NULL,
            translation TEXT NOT NULL,
            target_language TEXT NOT NULL
          );

          CREATE INDEX IF NOT EXISTS idx_knowledge_nodes_word ON knowledge_nodes(word);
          CREATE INDEX IF NOT EXISTS idx_knowledge_edges_source ON knowledge_edges(source_node_id);
          CREATE INDEX IF NOT EXISTS idx_vocabulary_lemma ON vocabulary(word);

          INSERT INTO schema_migrations (version, applied_at) VALUES (4, ${DateTime.now().millisecondsSinceEpoch});
        ''');
        _db.execute('COMMIT;');
        currentVer = 4;
      } catch (e) {
        _db.execute('ROLLBACK;');
        rethrow;
      }
    }

    if (currentVer < 5) {
      _db.execute('BEGIN TRANSACTION;');
      try {
        _db.execute('''
          CREATE TABLE IF NOT EXISTS settings (
            key TEXT PRIMARY KEY,
            value TEXT NOT NULL,
            updated_at INTEGER NOT NULL
          );

          CREATE TABLE IF NOT EXISTS preferences (
            key TEXT PRIMARY KEY,
            value TEXT NOT NULL,
            updated_at INTEGER NOT NULL
          );

          CREATE TABLE IF NOT EXISTS runtime_logs (
            log_id TEXT PRIMARY KEY,
            level TEXT NOT NULL,
            message TEXT NOT NULL,
            module TEXT NOT NULL,
            timestamp INTEGER NOT NULL
          );

          CREATE TABLE IF NOT EXISTS performance_metrics (
            metric_id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            value REAL NOT NULL,
            timestamp INTEGER NOT NULL
          );

          CREATE TABLE IF NOT EXISTS crash_reports (
            report_id TEXT PRIMARY KEY,
            error_message TEXT NOT NULL,
            stack_trace TEXT NOT NULL,
            timestamp INTEGER NOT NULL
          );

          CREATE INDEX IF NOT EXISTS idx_logs_timestamp ON runtime_logs(timestamp);
          CREATE INDEX IF NOT EXISTS idx_metrics_timestamp ON performance_metrics(timestamp);
          CREATE INDEX IF NOT EXISTS idx_crashes_timestamp ON crash_reports(timestamp);

          INSERT INTO schema_migrations (version, applied_at) VALUES (5, ${DateTime.now().millisecondsSinceEpoch});
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
