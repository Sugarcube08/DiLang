import 'package:test/test.dart';
import 'package:dilang_application/application.dart';
import 'package:dilang_memory/memory.dart';

void main() {
  group('Platform & Performance Benchmarks', () {
    test('1. CoreKernel bootstrap latency benchmark (<500ms)', () async {
      final stopwatch = Stopwatch()..start();
      final controller = await AppLifecycleController.createDefault();
      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, lessThan(500));
      await controller.shutdownPlatform();
    });

    test('2. FSRS-4.5 Retrievability calculation throughput benchmark', () {
      const engine = MemoryEngine();
      final state = FsrsItemState.initial(DateTime.now());

      final stopwatch = Stopwatch()..start();
      for (var i = 0; i < 1000; i++) {
        engine.predictRetrievability(state: state, currentTimestamp: DateTime.now());
      }
      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, lessThan(500));
    });
  });
}
