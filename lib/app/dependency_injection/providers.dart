import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/events/event_bus.dart';
import '../../infrastructure/sqlite/sqlite_storage_engine.dart';
import '../../infrastructure/ai/ai_runtime.dart';
import '../runtime/dilang_runtime.dart';

final eventBusProvider = Provider<EventBus>((ref) {
  final bus = EventBus();
  ref.onDispose(() => bus.dispose());
  return bus;
});

final sqliteEngineProvider = Provider<SqliteStorageEngine>((ref) {
  final home = Platform.environment['HOME'] ?? '.';
  final dbPath = '$home/.local/share/dilang/dilang_storage.db';
  final engine = SqliteStorageEngine(dbPath: dbPath);
  ref.onDispose(() => engine.dispose());
  return engine;
});

final aiRuntimeProvider = Provider<AiRuntime>((ref) {
  final ai = AiRuntime();
  ref.onDispose(() => ai.dispose());
  return ai;
});

class DiLangRuntimeNotifier extends StateNotifier<DiLangRuntimeState> {
  final DiLangRuntime runtime;

  DiLangRuntimeNotifier(this.runtime) : super(runtime.state) {
    runtime.addListener(_onStateChange);
    _init();
  }

  void _onStateChange(DiLangRuntimeState newState) {
    state = newState;
  }

  Future<void> _init() async {
    await runtime.initialize();
  }

  Future<void> createProfile({
    required String name,
    required String nativeLanguage,
    required String targetLanguage,
    required String brainModel,
    required String aiCoachPersona,
  }) async {
    await runtime.createProfile(
      name: name,
      nativeLanguage: nativeLanguage,
      targetLanguage: targetLanguage,
      brainModel: brainModel,
      aiCoachPersona: aiCoachPersona,
    );
  }

  Future<void> factoryReset() async {
    await runtime.factoryReset();
  }

  @override
  void dispose() {
    runtime.removeListener(_onStateChange);
    super.dispose();
  }
}

final runtimeProvider = StateNotifierProvider<DiLangRuntimeNotifier, DiLangRuntimeState>((ref) {
  final eventBus = ref.watch(eventBusProvider);
  final engine = ref.watch(sqliteEngineProvider);
  final runtime = DiLangRuntime(eventBus: eventBus, storageEngine: engine);
  return DiLangRuntimeNotifier(runtime);
});

final dilangRuntimeProvider = runtimeProvider;

final activeTabProvider = StateProvider<int>((ref) => 0);
