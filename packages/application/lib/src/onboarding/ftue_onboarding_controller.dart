import 'package:equatable/equatable.dart';

enum FtueStep {
  welcome,
  identity,
  sync,
  language,
  goal,
  startingPoint,
  aiSetup,
  resources,
  success,
  completed,
}

class FtueState extends Equatable {
  final FtueStep step;
  final String username;
  final String password;
  final String email;
  final bool enableSync;
  final String nativeLanguage;
  final String targetLanguage;
  final String goal;
  final String startingPoint; // "assessment" or "beginning"
  final bool aiDownloaded;
  final bool resourcesDownloaded;
  final double downloadProgress; // 0.0 to 1.0
  final String? errorMessage;

  const FtueState({
    required this.step,
    this.username = '',
    this.password = '',
    this.email = '',
    this.enableSync = true,
    this.nativeLanguage = 'English',
    this.targetLanguage = 'German',
    this.goal = 'Conversation',
    this.startingPoint = 'beginning',
    this.aiDownloaded = false,
    this.resourcesDownloaded = false,
    this.downloadProgress = 0.0,
    this.errorMessage,
  });

  FtueState copyWith({
    FtueStep? step,
    String? username,
    String? password,
    String? email,
    bool? enableSync,
    String? nativeLanguage,
    String? targetLanguage,
    String? goal,
    String? startingPoint,
    bool? aiDownloaded,
    bool? resourcesDownloaded,
    double? downloadProgress,
    String? errorMessage,
  }) {
    return FtueState(
      step: step ?? this.step,
      username: username ?? this.username,
      password: password ?? this.password,
      email: email ?? this.email,
      enableSync: enableSync ?? this.enableSync,
      nativeLanguage: nativeLanguage ?? this.nativeLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      goal: goal ?? this.goal,
      startingPoint: startingPoint ?? this.startingPoint,
      aiDownloaded: aiDownloaded ?? this.aiDownloaded,
      resourcesDownloaded: resourcesDownloaded ?? this.resourcesDownloaded,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        step,
        username,
        password,
        email,
        enableSync,
        nativeLanguage,
        targetLanguage,
        goal,
        startingPoint,
        aiDownloaded,
        resourcesDownloaded,
        downloadProgress,
        errorMessage,
      ];
}

class FtueOnboardingController {
  FtueState _state;

  FtueOnboardingController({FtueState? initialState})
      : _state = initialState ?? const FtueState(step: FtueStep.welcome);

  FtueState get state => _state;

  void nextStep() {
    switch (_state.step) {
      case FtueStep.welcome:
        _state = _state.copyWith(step: FtueStep.identity);
        break;
      case FtueStep.identity:
        if (_state.username.trim().isEmpty) {
          _state = _state.copyWith(errorMessage: 'Please enter a username');
          return;
        }
        _state = _state.copyWith(step: FtueStep.sync, errorMessage: null);
        break;
      case FtueStep.sync:
        _state = _state.copyWith(step: FtueStep.language);
        break;
      case FtueStep.language:
        _state = _state.copyWith(step: FtueStep.goal);
        break;
      case FtueStep.goal:
        _state = _state.copyWith(step: FtueStep.startingPoint);
        break;
      case FtueStep.startingPoint:
        _state = _state.copyWith(step: FtueStep.aiSetup);
        break;
      case FtueStep.aiSetup:
        _state = _state.copyWith(step: FtueStep.resources, aiDownloaded: true);
        break;
      case FtueStep.resources:
        _state = _state.copyWith(step: FtueStep.success, resourcesDownloaded: true);
        break;
      case FtueStep.success:
        _state = _state.copyWith(step: FtueStep.completed);
        break;
      case FtueStep.completed:
        break;
    }
  }

  void previousStep() {
    switch (_state.step) {
      case FtueStep.welcome:
        break;
      case FtueStep.identity:
        _state = _state.copyWith(step: FtueStep.welcome);
        break;
      case FtueStep.sync:
        _state = _state.copyWith(step: FtueStep.identity);
        break;
      case FtueStep.language:
        _state = _state.copyWith(step: FtueStep.sync);
        break;
      case FtueStep.goal:
        _state = _state.copyWith(step: FtueStep.language);
        break;
      case FtueStep.startingPoint:
        _state = _state.copyWith(step: FtueStep.goal);
        break;
      case FtueStep.aiSetup:
        _state = _state.copyWith(step: FtueStep.startingPoint);
        break;
      case FtueStep.resources:
        _state = _state.copyWith(step: FtueStep.aiSetup);
        break;
      case FtueStep.success:
        _state = _state.copyWith(step: FtueStep.resources);
        break;
      case FtueStep.completed:
        break;
    }
  }

  void updateIdentity(String username, String password, {String email = ''}) {
    _state = _state.copyWith(
      username: username,
      password: password,
      email: email,
    );
  }

  void setSyncEnabled(bool enabled) {
    _state = _state.copyWith(enableSync: enabled);
  }

  void setLanguages(String nativeLanguage, String targetLanguage) {
    _state = _state.copyWith(
      nativeLanguage: nativeLanguage,
      targetLanguage: targetLanguage,
    );
  }

  void setGoal(String goal) {
    _state = _state.copyWith(goal: goal);
  }

  void setStartingPoint(String startingPoint) {
    _state = _state.copyWith(startingPoint: startingPoint);
  }
}
