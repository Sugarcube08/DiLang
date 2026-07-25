import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../core/events/event_bus.dart';
import '../../core/events/domain_event.dart';
import '../../core/models/user_id.dart';
import '../../infrastructure/sqlite/sqlite_storage_engine.dart';
import '../../infrastructure/sqlite/repositories/sqlite_identity_repository.dart';
import '../../modules/identity/models/user.dart';
import '../../modules/identity/models/language_profile.dart';
import '../../modules/identity/models/learning_preferences.dart';
import '../../modules/identity/models/identity_state.dart';

// Domain Managers (Internal to DiLangRuntime)
class IdentityManager {
  final SqliteIdentityRepository repository;
  IdentityState state = IdentityState.uninitialized();

  User? currentUser;
  LanguageProfile? currentLanguageProfile;
  LearningPreferences currentPreferences = LearningPreferences.defaults();

  IdentityManager({required SqliteStorageEngine engine})
      : repository = SqliteIdentityRepository(engine.db);

  Future<IdentityState> loadIdentity() async {
    state = IdentityState.loading();
    try {
      currentUser = await repository.loadUser();
      currentPreferences = await repository.loadPreferences();

      if (currentUser == null || !currentPreferences.onboardingCompleted) {
        state = IdentityState.onboardingRequired();
      } else {
        currentLanguageProfile = await repository.loadLanguageProfile(currentUser!.id);
        state = IdentityState.ready();
      }
    } catch (e) {
      state = IdentityState.error(e.toString());
    }
    return state;
  }

  Future<void> createLearnerProfile({
    required String name,
    required String nativeLanguage,
    required String targetLanguage,
    required String currentCefr,
    required String targetCefr,
    required String motivation,
    required int dailyMinutes,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final userId = 'usr_$now';

    final user = User(
      id: userId,
      displayName: name,
      email: '${name.toLowerCase().replaceAll(' ', '')}@dilang.ai',
      createdAt: now,
      updatedAt: now,
    );

    final langProfile = LanguageProfile(
      userId: userId,
      targetLanguage: targetLanguage,
      nativeLanguage: nativeLanguage,
      currentCefrLevel: currentCefr,
      targetCefrLevel: targetCefr,
      dailyGoalMinutes: dailyMinutes,
      motivation: motivation,
      brainModel: 'Conversation First',
      aiCoachPersona: 'Friendly',
    );

    final prefs = LearningPreferences(
      dailyMinutes: dailyMinutes,
      reminderEnabled: true,
      speechEnabled: true,
      preferredVoice: 'Female',
      interfaceLanguage: nativeLanguage,
      onboardingCompleted: true,
    );

    await repository.createUser(user);
    await repository.saveLanguageProfile(langProfile);
    await repository.savePreferences(prefs);

    currentUser = user;
    currentLanguageProfile = langProfile;
    currentPreferences = prefs;
    state = IdentityState.ready();
  }
}

class ConversationManager {
  const ConversationManager();
}

class LearningManager {
  const LearningManager();
}

class SpeechManager {
  const SpeechManager();
}

class SettingsManager {
  const SettingsManager();
}

class DiagnosticsManager {
  const DiagnosticsManager();
}

class LearnerProfileData extends Equatable {
  final UserId id;
  final String displayName;
  final String nativeLanguage;
  final String targetLanguage;
  final String brainModel;
  final String aiCoachPersona;

  const LearnerProfileData({
    required this.id,
    required this.displayName,
    required this.nativeLanguage,
    required this.targetLanguage,
    required this.brainModel,
    required this.aiCoachPersona,
  });

  @override
  List<Object?> get props => [id, displayName, nativeLanguage, targetLanguage, brainModel, aiCoachPersona];
}

class DiLangRuntimeState extends Equatable {
  final bool isBootstrapped;
  final bool isOnboardingRequired;
  final IdentityState identityState;
  final LearnerProfileData? learner;
  final int completedSessionsCount;
  final int currentStreak;
  final double overallHealthScore;

  const DiLangRuntimeState({
    required this.isBootstrapped,
    required this.isOnboardingRequired,
    required this.identityState,
    this.learner,
    this.completedSessionsCount = 0,
    this.currentStreak = 0,
    this.overallHealthScore = 0.85,
  });

  factory DiLangRuntimeState.initial() {
    return DiLangRuntimeState(
      isBootstrapped: false,
      isOnboardingRequired: true,
      identityState: IdentityState.uninitialized(),
      learner: null,
      completedSessionsCount: 0,
      currentStreak: 0,
      overallHealthScore: 0.85,
    );
  }

  DiLangRuntimeState copyWith({
    bool? isBootstrapped,
    bool? isOnboardingRequired,
    IdentityState? identityState,
    LearnerProfileData? learner,
    int? completedSessionsCount,
    int? currentStreak,
    double? overallHealthScore,
  }) {
    return DiLangRuntimeState(
      isBootstrapped: isBootstrapped ?? this.isBootstrapped,
      isOnboardingRequired: isOnboardingRequired ?? this.isOnboardingRequired,
      identityState: identityState ?? this.identityState,
      learner: learner ?? this.learner,
      completedSessionsCount: completedSessionsCount ?? this.completedSessionsCount,
      currentStreak: currentStreak ?? this.currentStreak,
      overallHealthScore: overallHealthScore ?? this.overallHealthScore,
    );
  }

  @override
  List<Object?> get props => [
        isBootstrapped,
        isOnboardingRequired,
        identityState,
        learner,
        completedSessionsCount,
        currentStreak,
        overallHealthScore,
      ];
}

class DiLangRuntime {
  final EventBus eventBus;
  final SqliteStorageEngine storageEngine;

  late final IdentityManager identityManager;
  late final ConversationManager conversationManager;
  late final LearningManager learningManager;
  late final SpeechManager speechManager;
  late final SettingsManager settingsManager;
  late final DiagnosticsManager diagnosticsManager;

  DiLangRuntimeState _state = DiLangRuntimeState.initial();
  final List<void Function(DiLangRuntimeState)> _listeners = [];

  DiLangRuntime({
    required this.eventBus,
    required this.storageEngine,
  }) {
    identityManager = IdentityManager(engine: storageEngine);
    conversationManager = const ConversationManager();
    learningManager = const LearningManager();
    speechManager = const SpeechManager();
    settingsManager = const SettingsManager();
    diagnosticsManager = const DiagnosticsManager();
  }

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

  Future<void> initialize() async {
    final identityStatus = await identityManager.loadIdentity();

    if (identityStatus.isOnboardingRequired || identityManager.currentUser == null) {
      _state = _state.copyWith(
        isBootstrapped: true,
        isOnboardingRequired: true,
        identityState: identityStatus,
      );
    } else {
      final u = identityManager.currentUser!;
      final lp = identityManager.currentLanguageProfile;

      _state = _state.copyWith(
        isBootstrapped: true,
        isOnboardingRequired: false,
        identityState: identityStatus,
        learner: LearnerProfileData(
          id: UserId(u.id),
          displayName: u.displayName,
          nativeLanguage: lp?.nativeLanguage ?? 'English',
          targetLanguage: lp?.targetLanguage ?? 'German',
          brainModel: lp?.brainModel ?? 'Conversation First',
          aiCoachPersona: lp?.aiCoachPersona ?? 'Friendly',
        ),
      );
    }

    eventBus.publish(GenericRuntimeEvent(
      eventId: 'evt_${DateTime.now().millisecondsSinceEpoch}',
      aggregateId: 'runtime',
      timestamp: DateTime.now(),
      producerModule: 'app.runtime',
      eventName: 'RuntimeInitialized',
      payload: {'user': _state.learner?.displayName ?? 'guest'},
    ));
    _notifyListeners();
  }

  Future<void> createProfile({
    required String name,
    required String nativeLanguage,
    required String targetLanguage,
    required String brainModel,
    required String aiCoachPersona,
  }) async {
    await identityManager.createLearnerProfile(
      name: name,
      nativeLanguage: nativeLanguage,
      targetLanguage: targetLanguage,
      currentCefr: 'A1',
      targetCefr: 'B2',
      motivation: 'Daily Conversation',
      dailyMinutes: 15,
    );

    final u = identityManager.currentUser!;
    final lp = identityManager.currentLanguageProfile!;

    _state = _state.copyWith(
      isOnboardingRequired: false,
      identityState: IdentityState.ready(),
      learner: LearnerProfileData(
        id: UserId(u.id),
        displayName: u.displayName,
        nativeLanguage: lp.nativeLanguage,
        targetLanguage: lp.targetLanguage,
        brainModel: lp.brainModel,
        aiCoachPersona: lp.aiCoachPersona,
      ),
    );

    eventBus.publish(GenericRuntimeEvent(
      eventId: 'evt_${DateTime.now().millisecondsSinceEpoch}',
      aggregateId: u.id,
      timestamp: DateTime.now(),
      producerModule: 'app.runtime',
      eventName: 'LearnerProfileCreated',
      payload: {'name': name, 'targetLanguage': targetLanguage},
    ));
    _notifyListeners();
  }

  Future<void> factoryReset() async {
    storageEngine.dispose();
    final file = File(storageEngine.dbPath);
    if (file.existsSync()) {
      file.deleteSync();
    }

    _state = DiLangRuntimeState.initial().copyWith(
      isBootstrapped: true,
      isOnboardingRequired: true,
      identityState: IdentityState.onboardingRequired(),
    );

    eventBus.publish(GenericRuntimeEvent(
      eventId: 'evt_${DateTime.now().millisecondsSinceEpoch}',
      aggregateId: 'runtime',
      timestamp: DateTime.now(),
      producerModule: 'app.runtime',
      eventName: 'FactoryResetExecuted',
      payload: const {},
    ));
    _notifyListeners();
  }
}
