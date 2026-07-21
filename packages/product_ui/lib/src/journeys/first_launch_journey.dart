import 'package:equatable/equatable.dart';

enum OnboardingStep { welcome, languageSelection, modelDownload, ready }

class FirstLaunchJourneyState extends Equatable {
  final OnboardingStep step;
  final String selectedLanguage;
  final double downloadProgress;
  final bool isComplete;

  const FirstLaunchJourneyState({
    this.step = OnboardingStep.welcome,
    this.selectedLanguage = 'de-DE',
    this.downloadProgress = 0.0,
    this.isComplete = false,
  });

  FirstLaunchJourneyState copyWith({
    OnboardingStep? step,
    String? selectedLanguage,
    double? downloadProgress,
    bool? isComplete,
  }) {
    return FirstLaunchJourneyState(
      step: step ?? this.step,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  @override
  List<Object?> get props => [step, selectedLanguage, downloadProgress, isComplete];
}

class FirstLaunchJourneyController {
  FirstLaunchJourneyState state = const FirstLaunchJourneyState();

  void selectLanguage(String languageCode) {
    state = state.copyWith(
      selectedLanguage: languageCode,
      step: OnboardingStep.modelDownload,
    );
  }

  void updateDownloadProgress(double progress) {
    if (progress >= 1.0) {
      state = state.copyWith(
        downloadProgress: 1.0,
        step: OnboardingStep.ready,
        isComplete: true,
      );
    } else {
      state = state.copyWith(downloadProgress: progress);
    }
  }
}
