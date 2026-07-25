import 'package:flutter_test/flutter_test.dart';
import 'package:dilang/app/bootstrap/bootstrap_pipeline.dart';
import 'package:dilang/infrastructure/ai/providers/no_op_llm_provider.dart';
import 'package:dilang/infrastructure/platform/speech_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Step 2 App Bootstrap Tests', () {
    test('1. BootstrapPipeline initializes infrastructure, preferences, SQLite, and DiLangRuntime', () async {
      final res = await BootstrapPipeline.initialize();

      expect(res.runtime.state.isBootstrapped, isTrue);
      expect(res.preferences, isNotNull);
      expect(res.llmProvider, isA<NoOpLlmProvider>());
      expect(res.sttProvider, isA<NoOpSttProvider>());
      expect(res.ttsProvider, isA<NoOpTtsProvider>());

      res.sqliteEngine.dispose();
      await res.eventBus.dispose();
    });
  });
}
