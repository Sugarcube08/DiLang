import 'package:equatable/equatable.dart';

enum OnboardingStage {
  splash,
  welcome,
  identityCreation,
  syncSetup,
  languageSelection,
  goalSelection,
  levelSelection,
  aiEngineSetup,
  voiceSetup,
  storageSetup,
  ready
}

class FirstRunOnboardingState extends Equatable {
  final OnboardingStage stage;
  final String username;
  final String email;
  final bool isSyncEnabled;
  final String nativeLanguage;
  final String targetLanguage;
  final String learningGoal;
  final String currentLevel;
  final double aiEngineDownloadProgress;
  final bool isAiEngineReady;
  final String voiceSelection;

  const FirstRunOnboardingState({
    this.stage = OnboardingStage.splash,
    this.username = '',
    this.email = '',
    this.isSyncEnabled = true,
    this.nativeLanguage = 'en-US',
    this.targetLanguage = 'de-DE',
    this.learningGoal = 'Conversation',
    this.currentLevel = 'A1',
    this.aiEngineDownloadProgress = 0.0,
    this.isAiEngineReady = false,
    this.voiceSelection = 'Natural Female',
  });

  FirstRunOnboardingState copyWith({
    OnboardingStage? stage,
    String? username,
    String? email,
    bool? isSyncEnabled,
    String? nativeLanguage,
    String? targetLanguage,
    String? learningGoal,
    String? currentLevel,
    double? aiEngineDownloadProgress,
    bool? isAiEngineReady,
    String? voiceSelection,
  }) {
    return FirstRunOnboardingState(
      stage: stage ?? this.stage,
      username: username ?? this.username,
      email: email ?? this.email,
      isSyncEnabled: isSyncEnabled ?? this.isSyncEnabled,
      nativeLanguage: nativeLanguage ?? this.nativeLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      learningGoal: learningGoal ?? this.learningGoal,
      currentLevel: currentLevel ?? this.currentLevel,
      aiEngineDownloadProgress: aiEngineDownloadProgress ?? this.aiEngineDownloadProgress,
      isAiEngineReady: isAiEngineReady ?? this.isAiEngineReady,
      voiceSelection: voiceSelection ?? this.voiceSelection,
    );
  }

  @override
  List<Object?> get props => [
        stage,
        username,
        email,
        isSyncEnabled,
        nativeLanguage,
        targetLanguage,
        learningGoal,
        currentLevel,
        aiEngineDownloadProgress,
        isAiEngineReady,
        voiceSelection,
      ];
}

class FirstRunOnboardingController {
  FirstRunOnboardingState state = const FirstRunOnboardingState();

  void proceedFromSplash() {
    state = state.copyWith(stage: OnboardingStage.welcome);
  }

  void createIdentity(String username, String email) {
    state = state.copyWith(
      username: username,
      email: email,
      stage: OnboardingStage.syncSetup,
    );
  }

  void configureSync(bool enabled) {
    state = state.copyWith(
      isSyncEnabled: enabled,
      stage: OnboardingStage.languageSelection,
    );
  }

  void selectLanguages(String nativeLang, String targetLang) {
    state = state.copyWith(
      nativeLanguage: nativeLang,
      targetLanguage: targetLang,
      stage: OnboardingStage.goalSelection,
    );
  }

  void selectGoalAndLevel(String goal, String level) {
    state = state.copyWith(
      learningGoal: goal,
      currentLevel: level,
      stage: OnboardingStage.aiEngineSetup,
    );
  }

  void downloadAiEngine(double progress) {
    if (progress >= 1.0) {
      state = state.copyWith(
        aiEngineDownloadProgress: 1.0,
        isAiEngineReady: true,
        stage: OnboardingStage.voiceSetup,
      );
    } else {
      state = state.copyWith(aiEngineDownloadProgress: progress);
    }
  }

  void completeVoiceAndFinish(String voice) {
    state = state.copyWith(
      voiceSelection: voice,
      stage: OnboardingStage.ready,
    );
  }
}
