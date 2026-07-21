import 'package:test/test.dart';
import 'package:dilang_core/core.dart';
import 'package:dilang_application/application.dart';

void main() {
  group('Desktop App Entrypoint Tests', () {
    test('1. Desktop app boots system kernel', () async {
      final controller = await AppLifecycleController.createDefault();
      expect(controller.kernel.state, equals(ModuleState.running));
      await controller.shutdownPlatform();
    });
  });
}
