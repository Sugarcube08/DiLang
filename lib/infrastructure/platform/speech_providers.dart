abstract class SttProvider {
  Future<void> initialize();
  Future<String> listenOnce();
  Future<void> dispose();
}

abstract class TtsProvider {
  Future<void> initialize();
  Future<void> speak(String text);
  Future<void> dispose();
}

class NoOpSttProvider implements SttProvider {
  bool _initialized = false;

  bool get isInitialized => _initialized;

  @override
  Future<void> initialize() async {
    _initialized = true;
  }

  @override
  Future<String> listenOnce() async => '';

  @override
  Future<void> dispose() async {
    _initialized = false;
  }
}

class NoOpTtsProvider implements TtsProvider {
  bool _initialized = false;

  bool get isInitialized => _initialized;

  @override
  Future<void> initialize() async {
    _initialized = true;
  }

  @override
  Future<void> speak(String text) async {}

  @override
  Future<void> dispose() async {
    _initialized = false;
  }
}
