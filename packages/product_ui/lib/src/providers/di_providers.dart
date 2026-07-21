import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dilang_storage/storage.dart';
import 'package:dilang_application/application.dart';
import 'package:dilang_learning_engine/learning_engine.dart';
import 'package:dilang_conversation/conversation.dart';
import 'package:dilang_language/language.dart';

// 1. Core Storage & Security Singletons
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

// 3. Application Pipeline & UseCases
final bootstrapPipelineProvider = Provider<BootstrapPipeline>((ref) {
  final engine = ref.watch(sqliteEngineProvider);
  final secStorage = ref.watch(secureStorageProvider);
  final identityRepo = ref.watch(identityRepoProvider);
  final bootstrapRepo = ref.watch(bootstrapRepoProvider);

  return BootstrapPipeline(
    storageEngine: engine,
    secureStorage: secStorage,
    identityRepoOverride: identityRepo,
    bootstrapRepoOverride: bootstrapRepo,
  );
});

final bootstrapResultProvider = FutureProvider<BootstrapPipelineResult>((ref) async {
  final pipeline = ref.watch(bootstrapPipelineProvider);
  return await pipeline.runPipeline();
});

final todayDashboardUseCaseProvider = Provider<TodayDashboardUseCase>((ref) {
  final identityRepo = ref.watch(identityRepoProvider);
  final engine = ref.watch(sqliteEngineProvider);

  return TodayDashboardUseCase(
    identityRepo: identityRepo,
    storageEngine: engine,
  );
});

// 4. Live Today Dashboard View Model State Notifier
class TodayDashboardNotifier extends StateNotifier<AsyncValue<TodayDashboardViewModel>> {
  final TodayDashboardUseCase useCase;

  TodayDashboardNotifier(this.useCase) : super(const AsyncValue.loading()) {
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    state = const AsyncValue.loading();
    try {
      final vm = await useCase.loadDashboard();
      state = AsyncValue.data(vm);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> recordSessionCompleted({
    required String sessionType,
    required String title,
    required int minutesSpent,
  }) async {
    await useCase.recordCompletedSession(
      sessionType: sessionType,
      title: title,
      minutesSpent: minutesSpent,
    );
    await loadDashboard();
  }
}

final todayDashboardNotifierProvider =
    StateNotifierProvider<TodayDashboardNotifier, AsyncValue<TodayDashboardViewModel>>((ref) {
  final useCase = ref.watch(todayDashboardUseCaseProvider);
  return TodayDashboardNotifier(useCase);
});

// 5. FTUE Onboarding State Notifier
class FtueNotifier extends StateNotifier<FtueState> {
  final CreateIdentityUseCase createIdentityUseCase;
  final Ref ref;

  FtueNotifier(this.createIdentityUseCase, this.ref) : super(const FtueState(step: FtueStep.welcome));

  void updateIdentity(String username, String password, {String email = ''}) {
    state = state.copyWith(username: username, password: password, email: email);
  }

  void setSyncEnabled(bool enabled) {
    state = state.copyWith(enableSync: enabled);
  }

  void setLanguages(String nativeLanguage, String targetLanguage) {
    state = state.copyWith(nativeLanguage: nativeLanguage, targetLanguage: targetLanguage);
  }

  void setGoal(String goal) {
    state = state.copyWith(goal: goal);
  }

  void setStartingPoint(String startingPoint) {
    state = state.copyWith(startingPoint: startingPoint);
  }

  Future<void> completeOnboarding() async {
    state = state.copyWith(step: FtueStep.resources, aiDownloaded: true);
    await Future.delayed(const Duration(milliseconds: 300));
    state = state.copyWith(step: FtueStep.success, resourcesDownloaded: true);

    await createIdentityUseCase.execute(
      username: state.username.isNotEmpty ? state.username : 'learner',
      email: state.email,
      displayName: state.username.isNotEmpty ? state.username : 'Learner',
      nativeLanguage: state.nativeLanguage,
      targetLanguage: state.targetLanguage,
      cefrLevel: 'A1',
      learningGoal: state.goal,
      dailyGoalMinutes: 15,
    );

    state = state.copyWith(step: FtueStep.completed);
    ref.invalidate(bootstrapResultProvider);
  }
}

final ftueNotifierProvider = StateNotifierProvider<FtueNotifier, FtueState>((ref) {
  final identityRepo = ref.watch(identityRepoProvider);
  final bootstrapRepo = ref.watch(bootstrapRepoProvider);
  final createUseCase = CreateIdentityUseCase(
    identityRepo: identityRepo,
    bootstrapRepo: bootstrapRepo,
  );

  return FtueNotifier(createUseCase, ref);
});

// 6. Navigation Router State Notifier
final activeTabProvider = StateProvider<int>((ref) => 0);
