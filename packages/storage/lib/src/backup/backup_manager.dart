class BackupResult {
  final String backupPath;
  final int totalEventsBackedUp;
  final String sha256Checksum;

  const BackupResult({
    required this.backupPath,
    required this.totalEventsBackedUp,
    required this.sha256Checksum,
  });
}

class BackupManager {
  Future<BackupResult> createBackup(String targetPath, int totalEvents) async {
    return BackupResult(
      backupPath: targetPath,
      totalEventsBackedUp: totalEvents,
      sha256Checksum: 'dummy_sha256_checksum_hash',
    );
  }
}
