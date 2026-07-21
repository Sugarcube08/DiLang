import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dilang_core/core.dart';
import 'package:dilang_storage/storage.dart';
import 'package:dilang_application/application.dart';
import 'package:dilang_conversation/conversation.dart';

// 1. Core EventBus, Storage & Security Singletons
final eventBusProvider = Provider<EventBus>((ref) {
  return EventBus();
});

final sqliteEngineProvider = Provider<SqliteStorageEngine>((ref) {
  final engine = SqliteStorageEngine.inMemory();
  ref.onDispose(() => engine.dispose());
  return engine;
});

final secureStorageProvider = Provider<SecureStorageContract>((ref) {
  return MemorySecureStorage();
});

// 2. Repository Singletons
final identityRepoProvider = Provider<IdentityRepositoryContract>((ref) {
  final engine = ref.watch(sqliteEngineProvider);
  return SqliteIdentityRepository(engine: engine);
});

final bootstrapRepoProvider = Provider<BootstrapRepositoryContract>((ref) {
  final engine = ref.watch(sqliteEngineProvider);
  return SqliteBootstrapRepository(engine: engine);
});

final replayRepoProvider = Provider<SqliteReplayRepository>((ref) {
  final engine = ref.watch(sqliteEngineProvider);
  return SqliteReplayRepository(engine: engine);
});

final intelligenceRepoProvider = Provider<SqliteIntelligenceRepository>((ref) {
  final engine = ref.watch(sqliteEngineProvider);
  return SqliteIntelligenceRepository(engine: engine);
});

// 3. Single Authoritative DiLangRuntimeKernel Container
class DiLangRuntimeKernelNotifier extends StateNotifier<DiLangRuntimeState> {
  final DiLangRuntimeKernel kernel;

  DiLangRuntimeKernelNotifier(this.kernel) : super(kernel.state) {
    kernel.addListener((newState) {
      if (mounted) {
        state = newState;
      }
    });
    kernel.initializeRuntime();
  }

  Future<void> createProfile({
    required String name,
    required String mediumLanguage,
    required String targetLanguage,
    required String brainModel,
    required String learningGoal,
    required String aiCoachPersona,
  }) async {
    await kernel.createLearnerProfile(
      name: name,
      mediumLanguage: mediumLanguage,
      targetLanguage: targetLanguage,
      brainModel: brainModel,
      learningGoal: learningGoal,
      aiCoachPersona: aiCoachPersona,
    );
  }

  void startSession(ConversationScenario scenario) {
    kernel.startSession(scenario);
  }

  void submitTurn(String learnerInput) {
    kernel.submitTurn(learnerInput);
  }

  Future<void> completeSession() async {
    await kernel.completeSession();
  }

  Future<void> updateSettings({
    required String nativeLanguage,
    required String targetLanguage,
    required String brainModel,
    required String aiCoachPersona,
  }) async {
    await kernel.updateSettings(
      nativeLanguage: nativeLanguage,
      targetLanguage: targetLanguage,
      brainModel: brainModel,
      aiCoachPersona: aiCoachPersona,
    );
  }
}

final dilangRuntimeKernelProvider =
    StateNotifierProvider<DiLangRuntimeKernelNotifier, DiLangRuntimeState>((ref) {
  final eventBus = ref.watch(eventBusProvider);
  final engine = ref.watch(sqliteEngineProvider);
  final identityRepo = ref.watch(identityRepoProvider) as SqliteIdentityRepository;
  final replayRepo = ref.watch(replayRepoProvider);
  final intelRepo = ref.watch(intelligenceRepoProvider);

  final kernel = DiLangRuntimeKernel(
    eventBus: eventBus,
    storageEngine: engine,
    identityRepo: identityRepo,
    replayRepo: replayRepo,
    intelRepo: intelRepo,
  );

  return DiLangRuntimeKernelNotifier(kernel);
});

// 4. Navigation Tab Provider
final activeTabProvider = StateProvider<int>((ref) => 0);
