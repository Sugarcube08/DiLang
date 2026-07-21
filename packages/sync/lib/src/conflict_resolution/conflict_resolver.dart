import 'package:dilang_core/core.dart';
import 'vector_clock.dart';

class SyncEventBlock {
  final DomainEvent event;
  final VectorClock clock;

  const SyncEventBlock({required this.event, required this.clock});
}

class ConflictResolver {
  List<SyncEventBlock> resolveMerge({
    required List<SyncEventBlock> localBlocks,
    required List<SyncEventBlock> remoteBlocks,
  }) {
    final mergedMap = <String, SyncEventBlock>{};

    for (final b in localBlocks) {
      mergedMap[b.event.eventId] = b;
    }

    for (final remote in remoteBlocks) {
      final existing = mergedMap[remote.event.eventId];
      if (existing == null) {
        mergedMap[remote.event.eventId] = remote;
      } else {
        // Deterministic resolution: if remote vector clock dominates, use remote
        if (remote.clock.dominates(existing.clock)) {
          mergedMap[remote.event.eventId] = remote;
        }
      }
    }

    final result = mergedMap.values.toList();
    result.sort((a, b) => a.event.timestamp.compareTo(b.event.timestamp));
    return result;
  }
}
