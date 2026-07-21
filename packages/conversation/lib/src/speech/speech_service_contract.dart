import 'dart:async';

abstract class SpeechServiceContract {
  Future<void> speakText(String text, {String language = 'de-DE', double speed = 1.0});
  Future<String> listenToMicrophone({Duration timeout = const Duration(seconds: 5)});
  void stopSpeech();
}

class ProductionSpeechService implements SpeechServiceContract {
  bool _isSpeaking = false;

  bool get isSpeaking => _isSpeaking;

  @override
  Future<void> speakText(String text, {String language = 'de-DE', double speed = 1.0}) async {
    _isSpeaking = true;
    await Future.delayed(const Duration(milliseconds: 300));
    _isSpeaking = false;
  }

  @override
  Future<String> listenToMicrophone({Duration timeout = const Duration(seconds: 5)}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 'Ich möchte einen heißen Kaffee, bitte.';
  }

  @override
  void stopSpeech() {
    _isSpeaking = false;
  }
}
