import 'package:equatable/equatable.dart';

enum VoiceVisualizerState { idle, listening, processing, thinking, speaking }

class VoiceVisualizerModel extends Equatable {
  final VoiceVisualizerState state;
  final double audioAmplitude; // 0.0 to 1.0

  const VoiceVisualizerModel({
    this.state = VoiceVisualizerState.idle,
    this.audioAmplitude = 0.0,
  });

  VoiceVisualizerModel copyWith({
    VoiceVisualizerState? state,
    double? audioAmplitude,
  }) {
    return VoiceVisualizerModel(
      state: state ?? this.state,
      audioAmplitude: audioAmplitude ?? this.audioAmplitude,
    );
  }

  @override
  List<Object?> get props => [state, audioAmplitude];
}
