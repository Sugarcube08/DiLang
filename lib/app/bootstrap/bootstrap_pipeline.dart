import 'dart:io';
import 'package:flutter/widgets.dart';
import '../../core/events/event_bus.dart';
import '../../infrastructure/sqlite/sqlite_storage_engine.dart';
import '../../infrastructure/ai/providers/llm_provider.dart';
import '../../infrastructure/ai/providers/no_op_llm_provider.dart';
import '../../infrastructure/platform/speech_providers.dart';
import '../../infrastructure/preferences/preferences_adapter.dart';
import '../runtime/dilang_runtime.dart';

class BootstrapResult {
  final EventBus eventBus;
  final SqliteStorageEngine sqliteEngine;
  final PreferencesAdapter preferences;
  final LlmProvider llmProvider;
  final SttProvider sttProvider;
  final TtsProvider ttsProvider;
  final DiLangRuntime runtime;

  const BootstrapResult({
    required this.eventBus,
    required this.sqliteEngine,
    required this.preferences,
    required this.llmProvider,
    required this.sttProvider,
    required this.ttsProvider,
    required this.runtime,
  });
}

class BootstrapPipeline {
  static Future<BootstrapResult> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    final eventBus = EventBus();

    final home = Platform.environment['HOME'] ?? '.';
    final dbPath = '$home/.local/share/dilang/dilang_storage.db';
    final sqliteEngine = SqliteStorageEngine(dbPath: dbPath);

    final preferences = MemoryPreferencesAdapter();
    await preferences.initialize();

    final llmProvider = NoOpLlmProvider();
    await llmProvider.initialize();

    final sttProvider = NoOpSttProvider();
    await sttProvider.initialize();

    final ttsProvider = NoOpTtsProvider();
    await ttsProvider.initialize();

    final runtime = DiLangRuntime(
      eventBus: eventBus,
      storageEngine: sqliteEngine,
    );
    await runtime.initialize();

    return BootstrapResult(
      eventBus: eventBus,
      sqliteEngine: sqliteEngine,
      preferences: preferences,
      llmProvider: llmProvider,
      sttProvider: sttProvider,
      ttsProvider: ttsProvider,
      runtime: runtime,
    );
  }

  const BootstrapPipeline._();
}
