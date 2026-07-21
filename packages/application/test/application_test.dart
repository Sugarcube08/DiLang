import 'package:test/test.dart';
import 'package:dilang_core/core.dart';
import 'package:dilang_application/application.dart';

void main() {
  group('Application Layer Tests', () {
    test('1. AppLifecycleController boots and shuts down kernel', () async {
      final controller = await AppLifecycleController.createDefault();
      expect(controller.kernel.state, equals(ModuleState.running));

      await controller.shutdownPlatform();
      expect(controller.kernel.state, equals(ModuleState.disposed));
    });
  });
}
