abstract class TtsProvider {
  Future<void> loadVoice(String voiceModelPath);
  Future<List<int>> synthesizeSpeech(String text, {double rate = 1.0});
  Future<void> unloadVoice();
}
