import 'package:equatable/equatable.dart';

class SttResult extends Equatable {
  final String transcription;
  final double confidence;

  const SttResult({required this.transcription, required this.confidence});

  @override
  List<Object?> get props => [transcription, confidence];
}

abstract class SttProvider {
  Future<void> loadModel(String modelPath);
  Future<SttResult> transcribePcm16(List<int> pcmBytes, String languageCode);
  Future<void> unloadModel();
}
