import '../configuration/platform_configuration.dart';
import '../logger/platform_logger.dart';
import '../diagnostics/diagnostics_engine.dart';
import '../event_bus/event_bus.dart';
import '../capability_registry/capability_registry.dart';
import '../plugin_system/plugin_manager.dart';
import '../lifecycle/lifecycle_manager.dart';
import '../kernel/kernel.dart';

class BootstrapResult {
  final CoreKernel kernel;
  final Duration bootstrapTime;

  const BootstrapResult({
    required this.kernel,
    required this.bootstrapTime,
  });
}

class SystemBootstrapper {
  static Future<BootstrapResult> bootstrap({
    PlatformConfiguration? config,
    PlatformLogger? logger,
  }) async {
    final stopwatch = Stopwatch()..start();

    // 1. Platform Configuration
    final effectiveConfig = config ?? PlatformConfiguration.empty();
    
    // 2. Logger & Diagnostics
    final effectiveLogger = logger ?? PlatformLogger();
    effectiveLogger.info('--- DILANG CORE PLATFORM BOOTSTRAP START ---');
    final diagnostics = DiagnosticsEngine(logger: effectiveLogger);

    // 3. Capability Registry Setup
    final capabilityRegistry = CapabilityRegistry(logger: effectiveLogger);

    // 4. Event Bus Activation
    final eventBus = EventBus(logger: effectiveLogger);

    // 5. Plugin Manager & Discovery
    final pluginManager = PluginManager(logger: effectiveLogger);

    // 6. Lifecycle Manager
    final lifecycleManager = LifecycleManager(logger: effectiveLogger);

    // 7. Core Kernel Instantiation
    final kernel = CoreKernel(
      config: effectiveConfig,
      logger: effectiveLogger,
      diagnostics: diagnostics,
      eventBus: eventBus,
      capabilityRegistry: capabilityRegistry,
      pluginManager: pluginManager,
      lifecycleManager: lifecycleManager,
    );

    // 8. Bootstrap Core Modules Lifecycle
    await kernel.initialize();
    await kernel.start();

    stopwatch.stop();
    effectiveLogger.info('--- DILANG CORE PLATFORM BOOTSTRAP COMPLETE [${stopwatch.elapsedMilliseconds}ms] ---');

    return BootstrapResult(
      kernel: kernel,
      bootstrapTime: stopwatch.elapsed,
    );
  }
}
