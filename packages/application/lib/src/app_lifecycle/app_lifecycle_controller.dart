import 'package:dilang_core/core.dart';

class AppLifecycleController {
  final CoreKernel kernel;

  const AppLifecycleController({required this.kernel});

  static Future<AppLifecycleController> createDefault() async {
    final config = PlatformConfiguration.fromMap({'env': 'production', 'version': '2.0.0'});
    final logger = PlatformLogger(minLevel: LogLevel.info);
    final result = await SystemBootstrapper.bootstrap(config: config, logger: logger);
    return AppLifecycleController(kernel: result.kernel);
  }

  Future<void> bootPlatform() async {
    if (kernel.state != ModuleState.running) {
      await kernel.initialize();
      await kernel.start();
    }
  }

  Future<void> shutdownPlatform() async {
    await kernel.stop();
    await kernel.dispose();
  }
}
