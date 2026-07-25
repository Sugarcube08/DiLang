import 'model_descriptor.dart';
import 'ai_provider_capabilities.dart';

class ModelRegistry {
  static final List<ModelDescriptor> _registeredModels = [
    const ModelDescriptor(
      id: 'gemini-2.5-flash',
      displayName: 'Gemini 2.5 Flash',
      vendor: 'Google',
      contextWindowTokens: 1048576,
      capabilities: AiProviderCapabilities(
        supportsStreaming: true,
        supportsImages: true,
        supportsAudio: true,
        supportsJsonOutput: true,
        supportsToolCalling: true,
      ),
    ),
    const ModelDescriptor(
      id: 'gpt-4o-mini',
      displayName: 'GPT-4o Mini',
      vendor: 'OpenAI',
      contextWindowTokens: 128000,
      capabilities: AiProviderCapabilities(
        supportsStreaming: true,
        supportsImages: true,
        supportsJsonOutput: true,
        supportsToolCalling: true,
      ),
    ),
    const ModelDescriptor(
      id: 'claude-3-5-sonnet',
      displayName: 'Claude 3.5 Sonnet',
      vendor: 'Anthropic',
      contextWindowTokens: 200000,
      capabilities: AiProviderCapabilities(
        supportsStreaming: true,
        supportsImages: true,
        supportsJsonOutput: true,
        supportsToolCalling: true,
      ),
    ),
    const ModelDescriptor(
      id: 'llama-3.1-8b',
      displayName: 'Llama 3.1 8B (Local)',
      vendor: 'Meta / Local llama.cpp',
      contextWindowTokens: 128000,
      capabilities: AiProviderCapabilities(
        supportsStreaming: true,
        supportsJsonOutput: true,
      ),
    ),
    const ModelDescriptor(
      id: 'qwen-2.5-7b',
      displayName: 'Qwen 2.5 7B (Ollama)',
      vendor: 'Alibaba / Ollama',
      contextWindowTokens: 32768,
      capabilities: AiProviderCapabilities(
        supportsStreaming: true,
        supportsJsonOutput: true,
      ),
    ),
    const ModelDescriptor(
      id: 'deepseek-r1',
      displayName: 'DeepSeek R1',
      vendor: 'DeepSeek',
      contextWindowTokens: 64000,
      capabilities: AiProviderCapabilities(
        supportsStreaming: true,
        supportsJsonOutput: true,
      ),
    ),
  ];

  static List<ModelDescriptor> get availableModels => List.unmodifiable(_registeredModels);

  static ModelDescriptor get defaultModel => _registeredModels.first;

  static ModelDescriptor findById(String modelId) {
    return _registeredModels.firstWhere(
      (m) => m.id == modelId,
      orElse: () => defaultModel,
    );
  }

  const ModelRegistry._();
}
