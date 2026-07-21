import 'package:test/test.dart';
import 'package:dilang_core/core.dart';

class TestDomainEvent extends DomainEvent {
  final String payload;

  const TestDomainEvent({
    required super.eventId,
    required super.aggregateId,
    required super.timestamp,
    required super.producerModule,
    required this.payload,
  });

  @override
  List<Object?> get props => [...super.props, payload];
}

abstract class DummyCapability {
  String execute();
}

class DummyCapabilityImpl implements DummyCapability {
  @override
  String execute() => 'DummySuccess';
}

class TestModule extends PluginContract {
  @override
  final PluginManifest manifest;

  ModuleState _state = ModuleState.uninitialized;

  TestModule(this.manifest);

  @override
  ModuleState get state => _state;

  @override
  Future<void> initialize() async => _state = ModuleState.initialized;

  @override
  Future<void> start() async => _state = ModuleState.running;

  @override
  Future<void> pause() async => _state = ModuleState.paused;

  @override
  Future<void> resume() async => _state = ModuleState.running;

  @override
  Future<void> stop() async => _state = ModuleState.stopped;

  @override
  Future<void> dispose() async => _state = ModuleState.disposed;
}

void main() {
  group('DiLang Core Platform Kernel Tests', () {
    test('1. System Bootstrapper Pipeline initializes CoreKernel deterministically', () async {
      final config = PlatformConfiguration.fromMap({'env': 'test', 'version': '1.0.0'});
      final logger = PlatformLogger(minLevel: LogLevel.debug);

      final result = await SystemBootstrapper.bootstrap(config: config, logger: logger);

      expect(result.kernel.state, equals(ModuleState.running));
      expect(result.kernel.config.get<String>('env'), equals('test'));
      expect(result.kernel.logger.logs.isNotEmpty, isTrue);

      await result.kernel.dispose();
      expect(result.kernel.state, equals(ModuleState.disposed));
    });

    test('2. Error Taxonomy enforces strict exception types', () {
      const ex1 = ModelNotFoundException('/path/to/model.gguf');
      expect(ex1.errorCode, equals('AI_MODEL_NOT_FOUND'));
      expect(ex1.message, contains('/path/to/model.gguf'));

      const ex2 = DatabaseCorruptException('/path/to/db.sqlite');
      expect(ex2.errorCode, equals('STORAGE_DB_CORRUPT'));

      const ex3 = FfiLibraryLoadException('libdilang_llama.so', 'File not found');
      expect(ex3.errorCode, equals('RUNTIME_FFI_LOAD_FAILED'));
    });

    test('3. Capability Registry performs type-safe registration & resolution', () {
      final registry = CapabilityRegistry.instance;
      registry.reset();

      final impl = DummyCapabilityImpl();
      registry.register<DummyCapability>(impl);

      expect(registry.isRegistered<DummyCapability>(), isTrue);
      final resolved = registry.resolve<DummyCapability>();
      expect(resolved.execute(), equals('DummySuccess'));

      registry.unregister<DummyCapability>();
      expect(registry.isRegistered<DummyCapability>(), isFalse);
      expect(() => registry.resolve<DummyCapability>(), throwsA(isA<ConfigurationException>()));
    });

    test('4. EventBus publishes events asynchronously and retains history', () async {
      final eventBus = EventBus();
      TestDomainEvent? receivedEvent;

      eventBus.subscribe<TestDomainEvent>((event) {
        receivedEvent = event;
      });

      final event = TestDomainEvent(
        eventId: 'evt-001',
        aggregateId: 'agg-100',
        timestamp: DateTime.now(),
        producerModule: 'test_module',
        payload: 'Hello World',
      );

      eventBus.publish(event);

      // Yield event loop
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(receivedEvent, isNotNull);
      expect(receivedEvent!.payload, equals('Hello World'));
      expect(eventBus.history.length, equals(1));

      await eventBus.dispose();
    });

    test('5. PluginManager validates manifest dependencies and orders by priority', () {
      final manager = PluginManager();

      const manifestBase = PluginManifest(
        id: 'base_plugin',
        version: '1.0.0',
        name: 'Base Plugin',
        capabilities: ['base'],
        platforms: ['linux'],
        dependencies: [],
        priority: 5,
      );

      const manifestChild = PluginManifest(
        id: 'child_plugin',
        version: '1.0.0',
        name: 'Child Plugin',
        capabilities: ['child'],
        platforms: ['linux'],
        dependencies: ['base_plugin'],
        priority: 10,
      );

      final baseModule = TestModule(manifestBase);
      final childModule = TestModule(manifestChild);

      // Registering child before base should fail dependency check
      expect(() => manager.registerPlugin(childModule), throwsA(isA<PluginDependencyMissingException>()));

      // Register base first, then child
      manager.registerPlugin(baseModule);
      manager.registerPlugin(childModule);

      expect(manager.registeredPlugins.first.manifest.id, equals('child_plugin')); // Priority 10 first
      expect(manager.isCapabilitySupported('child'), isTrue);
    });

    test('6. Module Lifecycle Manager handles pause, resume, stop, dispose transitions', () async {
      final manager = LifecycleManager();
      const manifest = PluginManifest(
        id: 'module_a',
        version: '1.0.0',
        name: 'Module A',
        capabilities: [],
        platforms: [],
        dependencies: [],
      );

      final module = TestModule(manifest);
      manager.registerModule(module);

      await manager.initializeAll();
      expect(module.state, equals(ModuleState.initialized));

      await manager.startAll();
      expect(module.state, equals(ModuleState.running));

      await manager.pauseAll();
      expect(module.state, equals(ModuleState.paused));

      await manager.resumeAll();
      expect(module.state, equals(ModuleState.running));

      await manager.stopAll();
      expect(module.state, equals(ModuleState.stopped));

      await manager.disposeAll();
      expect(module.state, equals(ModuleState.disposed));
    });
  });
}
