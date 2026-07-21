enum ModuleState {
  uninitialized,
  initialized,
  running,
  paused,
  stopped,
  disposed,
}

abstract class ModuleLifecycle {
  String get moduleId;
  ModuleState get state;

  Future<void> initialize();
  Future<void> start();
  Future<void> pause();
  Future<void> resume();
  Future<void> stop();
  Future<void> dispose();
}
