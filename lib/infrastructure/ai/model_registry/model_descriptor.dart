import 'package:equatable/equatable.dart';
import 'ai_provider_capabilities.dart';

class ModelDescriptor extends Equatable {
  final String id;
  final String displayName;
  final String vendor;
  final int contextWindowTokens;
  final AiProviderCapabilities capabilities;

  const ModelDescriptor({
    required this.id,
    required this.displayName,
    required this.vendor,
    required this.contextWindowTokens,
    required this.capabilities,
  });

  @override
  List<Object?> get props => [id, displayName, vendor, contextWindowTokens, capabilities];
}
