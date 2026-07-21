import 'package:equatable/equatable.dart';

enum ModelBackend { llama_cpp, whisper_cpp, piper, onnxruntime }

class ModelDescriptor extends Equatable {
  final String modelId;
  final String version;
  final String name;
  final ModelBackend backend;
  final String format;
  final String quantization;
  final String sha256;
  final int sizeBytes;
  final int requiredRamBytes;
  final List<String> supportedCapabilities;
  final List<String> targetLanguages;

  const ModelDescriptor({
    required this.modelId,
    required this.version,
    required this.name,
    required this.backend,
    required this.format,
    required this.quantization,
    required this.sha256,
    required this.sizeBytes,
    required this.requiredRamBytes,
    required this.supportedCapabilities,
    required this.targetLanguages,
  });

  @override
  List<Object?> get props => [
        modelId,
        version,
        name,
        backend,
        format,
        quantization,
        sha256,
        sizeBytes,
        requiredRamBytes,
        supportedCapabilities,
        targetLanguages,
      ];
}
