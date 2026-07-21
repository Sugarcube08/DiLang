import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:dilang_core/core.dart';
import 'package:dilang_learner/learner.dart';
import 'package:dilang_language/language.dart';
import 'package:dilang_learning_engine/learning_engine.dart';
import 'package:dilang_conversation/conversation.dart';
import 'package:dilang_storage/storage.dart';

class DiLangRuntimeState extends Equatable {
  final bool isBootstrapped;
  final bool isOnboardingRequired;
  final DiLangUser? learner;
  final List<DiLangUser> availableProfiles;
  final UniversalKnowledgeGraph knowledgeGraph;
  final LearnerCognitiveModel cognitiveModel;
  final ConversationScenario activeScenario;
  final SessionBriefing activeBriefing;
  final List<LearningReplayTurn> activeTurns;
  final SessionDebriefing? activeDebriefing;
  final bool isSessionActive;
  final bool isSessionCompleted;
  final List<LearningReplayTranscript> sessionHistory;
  final int currentStreak;
  final int completedSessionsCount;

  const DiLangRuntimeState({
    required this.isBootstrapped,
    required this.isOnboardingRequired,
    this.learner,
    this.availableProfiles = const [],
    required this.knowledgeGraph,
    required this.cognitiveModel,
    required this.activeScenario,
    required this.activeBriefing,
    this.activeTurns = const [],
    this.activeDebriefing,
    this.isSessionActive = false,
    this.isSessionCompleted = false,
    this.sessionHistory = const [],
    this.currentStreak = 0,
    this.completedSessionsCount = 0,
  });

  factory DiLangRuntimeState.initial() {
    final defaultScenario = BuiltInScenarios.ScenarioCafeVienna;
    final briefing = DialogueManager(scenario: defaultScenario).generatePreSessionBriefing();

    return DiLangRuntimeState(
      isBootstrapped: false,
      isOnboardingRequired: true,
      learner: null,
      availableProfiles: const [],
      knowledgeGraph: UniversalKnowledgeGraph.createGermanA1Graph(),
      cognitiveModel: const LearnerCognitiveModel(
        userId: 'uninitialized',
        vocabularyMastery: 0.0,
        grammarMastery: 0.0,
        pronunciationConfidence: 0.0,
        listeningComprehension: 0.0,
        readingFluency: 0.0,
        writingFluency: 0.0,
        recallStability: 0.0,
        cognitiveLoadIndex: 0.0,
        learningVelocity: 0.0,
        estimatedCefrReadiness: 0.0,
      ),
      activeScenario: defaultScenario,
      activeBriefing: briefing,
      activeTurns: const [],
      activeDebriefing: null,
      isSessionActive: false,
      isSessionCompleted: false,
      sessionHistory: const [],
      currentStreak: 0,
      completedSessionsCount: 0,
    );
  }

  DiLangRuntimeState copyWith({
    bool? isBootstrapped,
    bool? isOnboardingRequired,
    DiLangUser? learner,
    List<DiLangUser>? availableProfiles,
    UniversalKnowledgeGraph? knowledgeGraph,
    LearnerCognitiveModel? cognitiveModel,
    ConversationScenario? activeScenario,
    SessionBriefing? activeBriefing,
    List<LearningReplayTurn>? activeTurns,
    SessionDebriefing? activeDebriefing,
    bool? isSessionActive,
    bool? isSessionCompleted,
    List<LearningReplayTranscript>? sessionHistory,
    int? currentStreak,
    int? completedSessionsCount,
  }) {
    return DiLangRuntimeState(
      isBootstrapped: isBootstrapped ?? this.isBootstrapped,
      isOnboardingRequired: isOnboardingRequired ?? this.isOnboardingRequired,
      learner: learner ?? this.learner,
      availableProfiles: availableProfiles ?? this.availableProfiles,
      knowledgeGraph: knowledgeGraph ?? this.knowledgeGraph,
      cognitiveModel: cognitiveModel ?? this.cognitiveModel,
      activeScenario: activeScenario ?? this.activeScenario,
      activeBriefing: activeBriefing ?? this.activeBriefing,
      activeTurns: activeTurns ?? this.activeTurns,
      activeDebriefing: activeDebriefing ?? this.activeDebriefing,
      isSessionActive: isSessionActive ?? this.isSessionActive,
      isSessionCompleted: isSessionCompleted ?? this.isSessionCompleted,
      sessionHistory: sessionHistory ?? this.sessionHistory,
      currentStreak: currentStreak ?? this.currentStreak,
      completedSessionsCount: completedSessionsCount ?? this.completedSessionsCount,
    );
  }

  @override
  List<Object?> get props => [
        isBootstrapped,
        isOnboardingRequired,
        learner,
        availableProfiles,
        knowledgeGraph,
        cognitiveModel,
        activeScenario,
        activeBriefing,
        activeTurns,
        activeDebriefing,
        isSessionActive,
        isSessionCompleted,
        sessionHistory,
        currentStreak,
        completedSessionsCount,
      ];
}

class DiLangRuntimeKernel {
  final EventBus eventBus;
  final SqliteStorageEngine storageEngine;
  final SqliteIdentityRepository identityRepo;
  final SqliteReplayRepository replayRepo;
  final SqliteIntelligenceRepository intelRepo;

  DiLangRuntimeState _state = DiLangRuntimeState.initial();
  final List<void Function(DiLangRuntimeState)> _listeners = [];

  DiLangRuntimeKernel({
    required this.eventBus,
    required this.storageEngine,
    required this.identityRepo,
    required this.replayRepo,
    required this.intelRepo,
  });

  DiLangRuntimeState get state => _state;

  void addListener(void Function(DiLangRuntimeState) listener) {
    _listeners.add(listener);
  }

  void removeListener(void Function(DiLangRuntimeState) listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final l in List.from(_listeners)) {
      l(_state);
    }
  }

  Future<void> initializeRuntime() async {
    final activeUser = await identityRepo.getActiveUser();
    final allUsers = await identityRepo.getAllUsers();

    if (activeUser == null) {
      _state = _state.copyWith(
        isBootstrapped: true,
        isOnboardingRequired: true,
        availableProfiles: allUsers,
      );
    } else {
      final history = await replayRepo.getAllTranscripts();
      final cognitiveModel = await intelRepo.getCognitiveModel(activeUser.id.value) ??
          LearnerCognitiveModel(
            userId: activeUser.id.value,
            vocabularyMastery: history.isNotEmpty ? 0.85 : 0.0,
            grammarMastery: history.isNotEmpty ? 0.80 : 0.0,
            pronunciationConfidence: history.isNotEmpty ? 0.82 : 0.0,
            listeningComprehension: history.isNotEmpty ? 0.80 : 0.0,
            readingFluency: history.isNotEmpty ? 0.85 : 0.0,
            writingFluency: history.isNotEmpty ? 0.75 : 0.0,
            recallStability: history.isNotEmpty ? 0.90 : 0.0,
            cognitiveLoadIndex: 0.2,
            learningVelocity: 1.0,
            estimatedCefrReadiness: history.isNotEmpty ? 0.75 : 0.0,
          );

      _state = _state.copyWith(
        isBootstrapped: true,
        isOnboardingRequired: false,
        learner: activeUser,
        availableProfiles: allUsers,
        cognitiveModel: cognitiveModel,
        sessionHistory: history,
        completedSessionsCount: history.length,
        currentStreak: history.isNotEmpty ? 1 : 0,
      );
    }

    eventBus.publish(GenericRuntimeEvent(
      eventName: 'RuntimeInitialized',
      aggregateId: 'kernel',
      payload: {'user': _state.learner?.username ?? 'guest'},
    ));
    _notifyListeners();
  }

  Future<void> createLearnerProfile({
    required String name,
    required String mediumLanguage,
    required String targetLanguage,
    required String brainModel,
    required String learningGoal,
    required String aiCoachPersona,
  }) async {
    final now = DateTime.now();
    final userId = UserId('usr_${now.millisecondsSinceEpoch}');

    final profile = Profile(
      userId: userId,
      displayName: name,
      avatarUrl: '',
      nativeLanguage: mediumLanguage,
      timezone: DateTime.now().timeZoneName,
    );

    final langProfile = LanguageProfile(
      id: 'lp_${now.millisecondsSinceEpoch}',
      userId: userId,
      targetLanguage: targetLanguage,
      cefrLevel: 'A1',
      learningGoal: learningGoal,
      dailyGoalMinutes: 15,
      isPrimary: true,
      brainModel: brainModel,
      aiCoachPersona: aiCoachPersona,
      voicePreference: 'Female',
    );

    final user = DiLangUser(
      id: userId,
      username: name.toLowerCase().replaceAll(' ', '_'),
      email: '${name.toLowerCase()}@dilang.ai',
      createdAt: now,
      lastActiveAt: now,
      profile: profile,
      languageProfiles: [langProfile],
      syncAccount: SyncAccount(syncId: 'sync_${userId.value}', isSyncEnabled: true, syncStatus: 'idle'),
    );

    await identityRepo.saveUser(user);
    final allUsers = await identityRepo.getAllUsers();

    _state = _state.copyWith(
      isOnboardingRequired: false,
      learner: user,
      availableProfiles: allUsers,
      cognitiveModel: LearnerCognitiveModel(
        userId: userId.value,
        vocabularyMastery: 0.0,
        grammarMastery: 0.0,
        pronunciationConfidence: 0.0,
        listeningComprehension: 0.0,
        readingFluency: 0.0,
        writingFluency: 0.0,
        recallStability: 0.0,
        cognitiveLoadIndex: 0.0,
        learningVelocity: 0.0,
        estimatedCefrReadiness: 0.0,
      ),
      currentStreak: 0,
      completedSessionsCount: 0,
    );

    eventBus.publish(GenericRuntimeEvent(
      eventName: 'LearnerProfileCreated',
      aggregateId: userId.value,
      payload: {'name': name, 'targetLanguage': targetLanguage},
    ));
    _notifyListeners();
  }

  void startSession(ConversationScenario scenario) {
    final manager = DialogueManager(scenario: scenario);
    final briefing = manager.generatePreSessionBriefing();

    _state = _state.copyWith(
      activeScenario: scenario,
      activeBriefing: briefing,
      activeTurns: const [],
      activeDebriefing: null,
      isSessionActive: true,
      isSessionCompleted: false,
    );

    eventBus.publish(GenericRuntimeEvent(
      eventName: 'SessionStarted',
      aggregateId: scenario.id,
      payload: {'scenario': scenario.title},
    ));
    _notifyListeners();
  }

  void submitTurn(String learnerInput) {
    if (!_state.isSessionActive || learnerInput.trim().isEmpty) return;

    final manager = DialogueManager(scenario: _state.activeScenario);
    for (final existingTurn in _state.activeTurns) {
      manager.processTurn(
        tutorPrompt: existingTurn.tutorPrompt,
        learnerResponse: existingTurn.learnerResponse,
        correctedResponse: existingTurn.correctedResponse,
        grammarNote: existingTurn.grammarNote,
        phoneticScore: existingTurn.phoneticScore,
      );
    }

    String corrected = learnerInput;
    String note = 'Grammar structure is natural.';
    double score = 95.0;

    if (learnerInput.contains('heiße Kaffee') || learnerInput.contains('ein Kaffee')) {
      corrected = 'Ich möchte einen heißen Kaffee, bitte.';
      note = 'Masculine accusative requires weak adjective ending "-en" ("einen heißen Kaffee").';
      score = 78.0;
    }

    final newTurn = manager.processTurn(
      tutorPrompt: 'Guten Tag! Was darf ich Ihnen bringen?',
      learnerResponse: learnerInput,
      correctedResponse: corrected,
      grammarNote: note,
      phoneticScore: score,
    );

    _state = _state.copyWith(
      activeTurns: List.from(manager.turns),
    );

    eventBus.publish(GenericRuntimeEvent(
      eventName: 'TurnProcessed',
      aggregateId: _state.activeScenario.id,
      payload: {'turnIndex': newTurn.turnIndex, 'score': score},
    ));
    _notifyListeners();
  }

  Future<void> completeSession() async {
    final manager = DialogueManager(scenario: _state.activeScenario);
    for (final t in _state.activeTurns) {
      manager.processTurn(
        tutorPrompt: t.tutorPrompt,
        learnerResponse: t.learnerResponse,
        correctedResponse: t.correctedResponse,
        grammarNote: t.grammarNote,
        phoneticScore: t.phoneticScore,
      );
    }

    final debriefing = manager.generatePostSessionDebriefing(initialConfidence: 70);

    final replay = LearningReplayTranscript(
      transcriptId: 'tr_${DateTime.now().millisecondsSinceEpoch}',
      sessionId: 'sess_${DateTime.now().millisecondsSinceEpoch}',
      scenarioId: _state.activeScenario.id,
      timestamp: DateTime.now(),
      speakingConfidenceBefore: debriefing.speakingConfidenceBefore,
      speakingConfidenceAfter: debriefing.speakingConfidenceAfter,
      evidenceSummary: debriefing.evidenceSummary,
      turns: manager.turns,
    );

    await replayRepo.saveTranscript(replay);

    const intelEngine = LearnerIntelligenceEngine();
    final newModel = intelEngine.inferCognitiveModel(
      userId: _state.learner?.id.value ?? 'usr_guest',
      totalSessions: _state.completedSessionsCount + 1,
      averageAccuracy: debriefing.grammarAccuracyRatio,
      dueReviewsCount: 3,
    );

    await intelRepo.saveCognitiveModel(newModel);

    final newHistory = List<LearningReplayTranscript>.from(_state.sessionHistory)..add(replay);

    _state = _state.copyWith(
      activeDebriefing: debriefing,
      isSessionActive: false,
      isSessionCompleted: true,
      cognitiveModel: newModel,
      sessionHistory: newHistory,
      completedSessionsCount: newHistory.length,
      currentStreak: 1,
    );

    eventBus.publish(GenericRuntimeEvent(
      eventName: 'SessionCompleted',
      aggregateId: _state.activeScenario.id,
      payload: {'sessionsCount': _state.completedSessionsCount},
    ));
    _notifyListeners();
  }

  Future<void> updateSettings({
    required String displayName,
    required String nativeLanguage,
    required String targetLanguage,
    required String brainModel,
    required String aiCoachPersona,
  }) async {
    if (_state.learner == null) return;

    final user = _state.learner!;
    final profile = Profile(
      userId: user.id,
      displayName: displayName.isNotEmpty ? displayName : user.profile.displayName,
      avatarUrl: user.profile.avatarUrl,
      nativeLanguage: nativeLanguage,
      timezone: user.profile.timezone,
    );

    final langProfile = LanguageProfile(
      id: user.primaryLanguageProfile?.id ?? 'lp_1',
      userId: user.id,
      targetLanguage: targetLanguage,
      cefrLevel: user.primaryLanguageProfile?.cefrLevel ?? 'A1',
      learningGoal: user.primaryLanguageProfile?.learningGoal ?? 'Daily Conversation',
      dailyGoalMinutes: 15,
      isPrimary: true,
      brainModel: brainModel,
      aiCoachPersona: aiCoachPersona,
      voicePreference: user.primaryLanguageProfile?.voicePreference ?? 'Female',
    );

    final updatedUser = DiLangUser(
      id: user.id,
      username: user.username,
      email: user.email,
      createdAt: user.createdAt,
      lastActiveAt: DateTime.now(),
      profile: profile,
      languageProfiles: [langProfile],
      syncAccount: user.syncAccount,
    );

    await identityRepo.saveUser(updatedUser);

    _state = _state.copyWith(
      learner: updatedUser,
      knowledgeGraph: targetLanguage == 'French'
          ? UniversalKnowledgeGraph(initialNodes: const [])
          : UniversalKnowledgeGraph.createGermanA1Graph(),
    );

    eventBus.publish(GenericRuntimeEvent(
      eventName: 'SettingsUpdated',
      aggregateId: user.id.value,
      payload: {'displayName': displayName, 'targetLanguage': targetLanguage},
    ));
    _notifyListeners();
  }

  Future<void> softLogout() async {
    _state = DiLangRuntimeState.initial().copyWith(
      isBootstrapped: true,
      isOnboardingRequired: true,
      availableProfiles: await identityRepo.getAllUsers(),
    );

    eventBus.publish(GenericRuntimeEvent(
      eventName: 'SoftLogoutExecuted',
      aggregateId: 'kernel',
      payload: {},
    ));
    _notifyListeners();
  }

  Future<void> factoryReset() async {
    storageEngine.dispose();

    final dbFile = File(storageEngine.dbPath);
    if (dbFile.existsSync()) {
      dbFile.deleteSync();
    }

    _state = DiLangRuntimeState.initial().copyWith(
      isBootstrapped: true,
      isOnboardingRequired: true,
      availableProfiles: const [],
    );

    eventBus.publish(GenericRuntimeEvent(
      eventName: 'FactoryResetExecuted',
      aggregateId: 'kernel',
      payload: {},
    ));
    _notifyListeners();
  }
}
