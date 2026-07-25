import 'package:equatable/equatable.dart';

class AiProviderCapabilities extends Equatable {
  final bool supportsStreaming;
  final bool supportsImages;
  final bool supportsAudio;
  final bool supportsJsonOutput;
  final bool supportsToolCalling;
  final bool supportsEmbeddings;

  const AiProviderCapabilities({
    this.supportsStreaming = true,
    this.supportsImages = false,
    this.supportsAudio = false,
    this.supportsJsonOutput = true,
    this.supportsToolCalling = false,
    this.supportsEmbeddings = false,
  });

  const AiProviderCapabilities.basic()
      : supportsStreaming = true,
        supportsImages = false,
        supportsAudio = false,
        supportsJsonOutput = true,
        supportsToolCalling = false,
        supportsEmbeddings = false;

  @override
  List<Object?> get props => [
        supportsStreaming,
        supportsImages,
        supportsAudio,
        supportsJsonOutput,
        supportsToolCalling,
        supportsEmbeddings,
      ];
}
