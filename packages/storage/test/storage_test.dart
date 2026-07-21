import 'package:test/test.dart';
import 'package:dilang_storage/storage.dart';
import 'package:dilang_learner/learner.dart';

void main() {
  group('Storage Infrastructure & Repository Contract Tests', () {
    test('1. InMemoryLearnerRepository saves and retrieves learner graphs', () async {
      final repo = InMemoryLearnerRepository();
      const graph = LearnerKnowledgeGraph(
        learnerId: 'usr_001',
        targetLanguage: 'de-DE',
      );

      await repo.saveLearnerGraph(graph);
      final retrieved = await repo.getLearnerGraph('usr_001');

      expect(retrieved, isNotNull);
      expect(retrieved!.learnerId, equals('usr_001'));
      expect(retrieved.targetLanguage, equals('de-DE'));
    });

    test('2. StorageEncryptionManager encrypts and decrypts payloads symmetrically', () {
      final enc = StorageEncryptionManager();
      final original = [72, 101, 108, 108, 111]; // "Hello"
      const key = 'secret_key';

      final encrypted = enc.encryptPayload(original, key);
      expect(encrypted, isNot(equals(original)));

      final decrypted = enc.decryptPayload(encrypted, key);
      expect(decrypted, equals(original));
    });

    test('3. BackupManager generates backup reports with SHA256 checksums', () async {
      final backup = BackupManager();
      final report = await backup.createBackup('/tmp/backup.db', 1500);

      expect(report.backupPath, equals('/tmp/backup.db'));
      expect(report.totalEventsBackedUp, equals(1500));
      expect(report.sha256Checksum.isNotEmpty, isTrue);
    });
  });
}
