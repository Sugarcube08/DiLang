import 'package:test/test.dart';
import 'package:dilang_storage/storage.dart';
import 'package:dilang_learner/learner.dart';

void main() {
  group('Storage Infrastructure & Repository Contract Tests', () {
    test('1. PersistentIdentityRepository saves and retrieves identity user', () async {
      final repo = PersistentIdentityRepository();
      const userId = UserId('usr_001');
      const profile = Profile(
        userId: userId,
        displayName: 'Learner',
        avatarUrl: '',
        nativeLanguage: 'en',
        timezone: 'UTC',
      );
      final user = DiLangUser(
        id: userId,
        username: 'usr_001',
        email: 'test@example.com',
        createdAt: DateTime.utc(2026, 1, 1),
        lastActiveAt: DateTime.utc(2026, 1, 1),
        profile: profile,
        languageProfiles: const [],
        syncAccount: const SyncAccount(syncId: 's1', isSyncEnabled: true, syncStatus: 'idle'),
      );

      await repo.saveUser(user);
      final retrieved = await repo.getActiveUser();

      expect(retrieved, isNotNull);
      expect(retrieved!.id, equals(userId));
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
