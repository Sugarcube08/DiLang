import 'package:flutter_test/flutter_test.dart';
import 'package:dilang/core/events/event_bus.dart';
import 'package:dilang/infrastructure/sqlite/sqlite_storage_engine.dart';
import 'package:dilang/app/runtime/dilang_runtime.dart';

void main() {
  group('DiLang Frozen Architecture Foundation Tests', () {
    test('1. SqliteStorageEngine initializes in-memory database with migrations', () {
      final engine = SqliteStorageEngine.inMemory();
      final res = engine.db.select('SELECT MAX(version) as ver FROM schema_migrations;');
      expect(res.first['ver'], equals(5));
      engine.dispose();
    });

    test('2. DiLangRuntime initializes state and creates learner profile in SQLite', () async {
      final engine = SqliteStorageEngine.inMemory();
      final eventBus = EventBus();
      final runtime = DiLangRuntime(eventBus: eventBus, storageEngine: engine);

      await runtime.initialize();
      expect(runtime.state.isBootstrapped, isTrue);
      expect(runtime.state.isOnboardingRequired, isTrue);

      await runtime.createProfile(
        name: 'Harsh Learner',
        nativeLanguage: 'English',
        targetLanguage: 'German',
        brainModel: 'Conversation First',
        aiCoachPersona: 'Friendly',
      );

      expect(runtime.state.isOnboardingRequired, isFalse);
      expect(runtime.state.learner?.displayName, equals('Harsh Learner'));
      expect(runtime.state.learner?.targetLanguage, equals('German'));

      engine.dispose();
      await eventBus.dispose();
    });
  });
}
