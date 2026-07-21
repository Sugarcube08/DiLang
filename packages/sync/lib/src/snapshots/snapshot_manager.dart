import 'package:equatable/equatable.dart';

class SyncSnapshot extends Equatable {
  final String snapshotId;
  final int lastSequenceNumber;
  final DateTime createdAt;

  const SyncSnapshot({
    required this.snapshotId,
    required this.lastSequenceNumber,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [snapshotId, lastSequenceNumber, createdAt];
}

class SnapshotManager {
  SyncSnapshot createSnapshot(int sequenceNumber) {
    return SyncSnapshot(
      snapshotId: 'snap_$sequenceNumber',
      lastSequenceNumber: sequenceNumber,
      createdAt: DateTime.now(),
    );
  }
}
