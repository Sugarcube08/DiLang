import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dilang_core/core.dart';
import 'package:dilang_storage/storage.dart';
import 'package:dilang_application/application.dart';
import 'package:dilang_learning_engine/learning_engine.dart';
import 'package:dilang_conversation/conversation.dart';
import 'package:dilang_language/language.dart';

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
  final res = await pipeline.runPipeline();
  ref.read(eventBusProvider).publish(GenericRuntimeEvent(eventName: 'BootstrapCompleted', aggregateId: 'sys', payload: {'status': res.status.name}));
  return res;
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
  final EventBus eventBus;

  TodayDashboardNotifier(this.useCase, this.eventBus) : super(const AsyncValue.loading()) {
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    state = const AsyncValue.loading();
    try {
      final vm = await useCase.loadDashboard();
      state = AsyncValue.data(vm);
      eventBus.publish(GenericRuntimeEvent(eventName: 'DashboardUpdated', aggregateId: 'dash', payload: {'username': vm.username}));
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
  final eventBus = ref.watch(eventBusProvider);
  return TodayDashboardNotifier(useCase, eventBus);
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

    ref.read(eventBusProvider).publish(GenericRuntimeEvent(eventName: 'IdentityCreated', aggregateId: 'user', payload: {'username': state.username}));

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

// 6. Interactive Conversation Dialogue State & Notifier
class InteractiveDialogueState {
  final ConversationScenario scenario;
  final SessionBriefing briefing;
  final List<LearningReplayTurn> turns;
  final SessionDebriefing? debriefing;
  final bool isSessionActive;
  final bool isCompleted;

  const InteractiveDialogueState({
    required this.scenario,
    required this.briefing,
    this.turns = const [],
    this.debriefing,
    this.isSessionActive = false,
    this.isCompleted = false,
  });

  InteractiveDialogueState copyWith({
    ConversationScenario? scenario,
    SessionBriefing? briefing,
    List<LearningReplayTurn>? turns,
    SessionDebriefing? debriefing,
    bool? isSessionActive,
    bool? isCompleted,
  }) {
    return InteractiveDialogueState(
      scenario: scenario ?? this.scenario,
      briefing: briefing ?? this.briefing,
      turns: turns ?? this.turns,
      debriefing: debriefing ?? this.debriefing,
      isSessionActive: isSessionActive ?? this.isSessionActive,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class InteractiveDialogueNotifier extends StateNotifier<InteractiveDialogueState> {
  final Ref ref;
  late DialogueManager _dialogueManager;

  InteractiveDialogueNotifier(this.ref)
      : super(
          InteractiveDialogueState(
            scenario: BuiltInScenarios.ScenarioCafeVienna,
            briefing: DialogueManager(scenario: BuiltInScenarios.ScenarioCafeVienna).generatePreSessionBriefing(),
          ),
        ) {
    _dialogueManager = DialogueManager(scenario: state.scenario);
  }

  void startSession(ConversationScenario scenario) {
    _dialogueManager = DialogueManager(scenario: scenario);
    final briefing = _dialogueManager.generatePreSessionBriefing();

    state = InteractiveDialogueState(
      scenario: scenario,
      briefing: briefing,
      turns: const [],
      debriefing: null,
      isSessionActive: true,
      isCompleted: false,
    );

    ref.read(eventBusProvider).publish(GenericRuntimeEvent(eventName: 'SessionStarted', aggregateId: scenario.id, payload: {'scenarioId': scenario.id}));
  }

  void submitTurn({required String learnerInput}) {
    if (!state.isSessionActive || learnerInput.trim().isEmpty) return;

    String corrected = learnerInput;
    String note = 'Grammar structure looks natural.';
    double score = 95.0;

    if (learnerInput.contains('heiße Kaffee') || learnerInput.contains('ein Kaffee')) {
      corrected = 'Ich möchte einen heißen Kaffee, bitte.';
      note = 'Masculine accusative requires weak adjective ending "-en" ("einen heißen Kaffee").';
      score = 78.0;
    }

    final turn = _dialogueManager.processTurn(
      tutorPrompt: 'Guten Tag! Was darf ich Ihnen bringen?',
      learnerResponse: learnerInput,
      correctedResponse: corrected,
      grammarNote: note,
      phoneticScore: score,
    );

    state = state.copyWith(turns: List.from(_dialogueManager.turns));
    ref.read(eventBusProvider).publish(GenericRuntimeEvent(eventName: 'TurnProcessed', aggregateId: state.scenario.id, payload: {'turnIndex': turn.turnIndex}));
  }

  Future<void> completeSession() async {
    final debriefing = _dialogueManager.generatePostSessionDebriefing(initialConfidence: 75);

    final replay = LearningReplayTranscript(
      transcriptId: 'tr_${DateTime.now().millisecondsSinceEpoch}',
      sessionId: 'sess_${DateTime.now().millisecondsSinceEpoch}',
      scenarioId: state.scenario.id,
      timestamp: DateTime.now(),
      speakingConfidenceBefore: debriefing.speakingConfidenceBefore,
      speakingConfidenceAfter: debriefing.speakingConfidenceAfter,
      evidenceSummary: debriefing.evidenceSummary,
      turns: _dialogueManager.turns,
    );

    // Save Replay Transcript to SQLite
    final replayRepo = ref.read(replayRepoProvider);
    await replayRepo.saveTranscript(replay);
    ref.read(eventBusProvider).publish(GenericRuntimeEvent(eventName: 'ReplayStored', aggregateId: replay.transcriptId, payload: {'transcriptId': replay.transcriptId}));

    // Infer & Save Cognitive Model to SQLite
    const intelEngine = LearnerIntelligenceEngine();
    final intelRepo = ref.read(intelligenceRepoProvider);
    final model = intelEngine.inferCognitiveModel(
      userId: 'usr_learner',
      totalSessions: 1,
      averageAccuracy: debriefing.grammarAccuracyRatio,
      dueReviewsCount: 5,
    );
    await intelRepo.saveCognitiveModel(model);
    ref.read(eventBusProvider).publish(GenericRuntimeEvent(eventName: 'IntelligenceUpdated', aggregateId: 'usr_learner', payload: {'userId': 'usr_learner'}));

    // Record Session in Dashboard UseCase
    final todayUseCase = ref.read(todayDashboardUseCaseProvider);
    await todayUseCase.recordCompletedSession(
      sessionType: 'Conversation',
      title: state.scenario.title,
      minutesSpent: state.scenario.estimatedDurationMinutes,
    );

    state = state.copyWith(
      debriefing: debriefing,
      isSessionActive: false,
      isCompleted: true,
    );

    ref.read(eventBusProvider).publish(GenericRuntimeEvent(eventName: 'SessionCompleted', aggregateId: state.scenario.id, payload: {'scenarioId': state.scenario.id}));
    ref.read(todayDashboardNotifierProvider.notifier).loadDashboard();
  }
}

final interactiveDialogueNotifierProvider =
    StateNotifierProvider<InteractiveDialogueNotifier, InteractiveDialogueState>((ref) {
  return InteractiveDialogueNotifier(ref);
});

// 7. Navigation Router State Notifier
final activeTabProvider = StateProvider<int>((ref) => 0);
