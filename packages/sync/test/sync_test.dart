import 'package:test/test.dart';
import 'package:dilang_core/core.dart';
import 'package:dilang_sync/sync.dart';

class SampleEvent extends DomainEvent {
  const SampleEvent({
    required super.eventId,
    required super.aggregateId,
    required super.timestamp,
    required super.producerModule,
  });
}

void main() {
  group('Synchronization & Event Replication Engine Tests', () {
    test('1. VectorClock handles increments and dominance checks', () {
      var v1 = VectorClock.empty();
      v1 = v1.increment('device_A');

      var v2 = VectorClock.empty();
      v2 = v2.increment('device_A');
      v2 = v2.increment('device_A');

      expect(v2.dominates(v1), isTrue);
      expect(v1.dominates(v2), isFalse);
    });

    test('2. Lz4CompressionEngine compresses and decompresses payloads', () {
      final comp = Lz4CompressionEngine();
      final original = [1, 2, 3, 4, 5, 6, 7, 8];

      final compressed = comp.compressPayload(original);
      expect(compressed.length, equals(original.length + 4));

      final decompressed = comp.decompressPayload(compressed);
      expect(decompressed, equals(original));
    });

    test('3. ConflictResolver merges local and remote event streams deterministically', () {
      final resolver = ConflictResolver();
      final now = DateTime.now();

      final ev1 = SampleEvent(
        eventId: 'evt_100',
        aggregateId: 'agg_1',
        timestamp: now,
        producerModule: 'module_a',
      );

      final ev2 = SampleEvent(
        eventId: 'evt_200',
        aggregateId: 'agg_2',
        timestamp: now.add(const Duration(seconds: 1)),
        producerModule: 'module_b',
      );

      final localBlock = SyncEventBlock(
        event: ev1,
        clock: const VectorClock({'devA': 1}),
      );

      final remoteBlock = SyncEventBlock(
        event: ev2,
        clock: const VectorClock({'devB': 1}),
      );

      final merged = resolver.resolveMerge(
        localBlocks: [localBlock],
        remoteBlocks: [remoteBlock],
      );

      expect(merged.length, equals(2));
      expect(merged.first.event.eventId, equals('evt_100'));
    });
  });
}
