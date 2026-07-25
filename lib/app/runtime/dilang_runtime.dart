import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../core/events/event_bus.dart';
import '../../core/events/domain_event.dart';
import '../../core/models/user_id.dart';
import '../../infrastructure/sqlite/sqlite_storage_engine.dart';

// Domain Managers (Internal to DiLangRuntime)
class IdentityManager {
  final SqliteStorageEngine engine;

  IdentityManager({required this.engine});

  Future<LearnerProfileData?> loadActiveUser() async {
    final db = engine.db;
    final usersRes = db.select('SELECT id, username FROM users LIMIT 1;');
    if (usersRes.isEmpty) return null;

    final userRow = usersRes.first;
    final userId = UserId(userRow['id'] as String);

    final profileRes = db.select('SELECT display_name, native_language FROM profiles WHERE user_id = ?;', [userId.value]);
    final langRes = db.select('SELECT target_language, brain_model, ai_coach_persona FROM language_profiles WHERE user_id = ?;', [userId.value]);

    final name = profileRes.isNotEmpty ? (profileRes.first['display_name'] as String) : 'Learner';
    final nativeLang = profileRes.isNotEmpty ? (profileRes.first['native_language'] as String) : 'English';
    final targetLang = langRes.isNotEmpty ? (langRes.first['target_language'] as String) : 'German';
    final brainModel = langRes.isNotEmpty ? (langRes.first['brain_model'] as String) : 'Conversation First';
    final persona = langRes.isNotEmpty ? (langRes.first['ai_coach_persona'] as String) : 'Friendly';

    return LearnerProfileData(
      id: userId,
      displayName: name,
      nativeLanguage: nativeLang,
      targetLanguage: targetLang,
      brainModel: brainModel,
      aiCoachPersona: persona,
    );
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
  final LearnerProfileData? learner;
  final int completedSessionsCount;
  final int currentStreak;
  final double overallHealthScore;

  const DiLangRuntimeState({
    required this.isBootstrapped,
    required this.isOnboardingRequired,
    this.learner,
    this.completedSessionsCount = 0,
    this.currentStreak = 0,
    this.overallHealthScore = 0.85,
  });

  factory DiLangRuntimeState.initial() {
    return const DiLangRuntimeState(
      isBootstrapped: false,
      isOnboardingRequired: true,
      learner: null,
      completedSessionsCount: 0,
      currentStreak: 0,
      overallHealthScore: 0.85,
    );
  }

  DiLangRuntimeState copyWith({
    bool? isBootstrapped,
    bool? isOnboardingRequired,
    LearnerProfileData? learner,
    int? completedSessionsCount,
    int? currentStreak,
    double? overallHealthScore,
  }) {
    return DiLangRuntimeState(
      isBootstrapped: isBootstrapped ?? this.isBootstrapped,
      isOnboardingRequired: isOnboardingRequired ?? this.isOnboardingRequired,
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
    final activeLearner = await identityManager.loadActiveUser();

    if (activeLearner == null) {
      _state = _state.copyWith(
        isBootstrapped: true,
        isOnboardingRequired: true,
      );
    } else {
      _state = _state.copyWith(
        isBootstrapped: true,
        isOnboardingRequired: false,
        learner: activeLearner,
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
    final now = DateTime.now().millisecondsSinceEpoch;
    final userId = UserId('usr_$now');

    final db = storageEngine.db;
    db.execute('BEGIN TRANSACTION;');
    try {
      db.execute(
        'INSERT INTO users (id, username, email, created_at, last_active_at) VALUES (?, ?, ?, ?, ?);',
        [userId.value, name.toLowerCase().replaceAll(' ', '_'), '${name.toLowerCase()}@dilang.ai', now, now],
      );

      db.execute(
        'INSERT INTO profiles (user_id, display_name, avatar_url, native_language, timezone) VALUES (?, ?, ?, ?, ?);',
        [userId.value, name, '', nativeLanguage, DateTime.now().timeZoneName],
      );

      db.execute(
        '''
        INSERT INTO language_profiles (
          id, user_id, target_language, cefr_level, learning_goal,
          daily_goal_minutes, is_primary, brain_model, ai_coach_persona, voice_preference
        ) VALUES (?, ?, ?, ?, ?, ?, 1, ?, ?, ?);
        ''',
        ['lp_$now', userId.value, targetLanguage, 'A1', 'Daily Conversation', 15, brainModel, aiCoachPersona, 'Female'],
      );

      db.execute('COMMIT;');
    } catch (e) {
      db.execute('ROLLBACK;');
      rethrow;
    }

    final learner = LearnerProfileData(
      id: userId,
      displayName: name,
      nativeLanguage: nativeLanguage,
      targetLanguage: targetLanguage,
      brainModel: brainModel,
      aiCoachPersona: aiCoachPersona,
    );

    _state = _state.copyWith(
      isOnboardingRequired: false,
      learner: learner,
    );

    eventBus.publish(GenericRuntimeEvent(
      eventId: 'evt_$now',
      aggregateId: userId.value,
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
