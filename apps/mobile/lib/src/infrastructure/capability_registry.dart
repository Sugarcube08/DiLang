enum AppCapability {
  conversation,
  speechToText,
  textToSpeech,
  spacedRepetition,
}

class CapabilityRegistry {
  static String getProviderName(AppCapability capability) {
    switch (capability) {
      case AppCapability.conversation:
        return 'Gemma 3 1B (llama.cpp)';
      case AppCapability.speechToText:
        return 'Whisper.cpp';
      case AppCapability.textToSpeech:
        return 'Piper ONNX';
      case AppCapability.spacedRepetition:
        return 'FSRS v4 Core';
    }
  }
}
