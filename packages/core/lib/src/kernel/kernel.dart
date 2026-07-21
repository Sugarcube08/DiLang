import '../configuration/platform_configuration.dart';
import '../logger/platform_logger.dart';
import '../diagnostics/diagnostics_engine.dart';
import '../event_bus/event_bus.dart';
import '../capability_registry/capability_registry.dart';
import '../plugin_system/plugin_manager.dart';
import '../lifecycle/lifecycle_manager.dart';
import '../lifecycle/module_lifecycle.dart';

class CoreKernel implements ModuleLifecycle {
  final PlatformConfiguration config;
  final PlatformLogger logger;
  final DiagnosticsEngine diagnostics;
  final EventBus eventBus;
  final CapabilityRegistry capabilityRegistry;
  final PluginManager pluginManager;
  final LifecycleManager lifecycleManager;

  ModuleState _state = ModuleState.uninitialized;

  CoreKernel({
    required this.config,
    required this.logger,
    required this.diagnostics,
    required this.eventBus,
    required this.capabilityRegistry,
    required this.pluginManager,
    required this.lifecycleManager,
  });

  @override
  String get moduleId => 'dilang.core.kernel';

  @override
  ModuleState get state => _state;

  @override
  Future<void> initialize() async {
    if (_state != ModuleState.uninitialized) return;
    logger.info('Initializing CoreKernel...');
    await lifecycleManager.initializeAll();
    _state = ModuleState.initialized;
  }

  @override
  Future<void> start() async {
    if (_state != ModuleState.initialized && _state != ModuleState.stopped) return;
    logger.info('Starting CoreKernel...');
    await lifecycleManager.startAll();
    _state = ModuleState.running;
  }

  @override
  Future<void> pause() async {
    if (_state != ModuleState.running) return;
    logger.info('Pausing CoreKernel...');
    await lifecycleManager.pauseAll();
    _state = ModuleState.paused;
  }

  @override
  Future<void> resume() async {
    if (_state != ModuleState.paused) return;
    logger.info('Resuming CoreKernel...');
    await lifecycleManager.resumeAll();
    _state = ModuleState.running;
  }

  @override
  Future<void> stop() async {
    if (_state != ModuleState.running && _state != ModuleState.paused) return;
    logger.info('Stopping CoreKernel...');
    await lifecycleManager.stopAll();
    _state = ModuleState.stopped;
  }

  @override
  Future<void> dispose() async {
    logger.info('Disposing CoreKernel...');
    await lifecycleManager.disposeAll();
    await eventBus.dispose();
    _state = ModuleState.disposed;
  }

  SystemMetrics getHealthReport() {
    return diagnostics.generateReport(
      totalEvents: eventBus.history.length,
      activePlugins: pluginManager.registeredPlugins.length,
      capabilities: [],
    );
  }
}
