import 'package:test/test.dart';
import 'package:dilang_core/core.dart';
import 'package:dilang_application/application.dart';

void main() {
  group('Mobile App Entrypoint Tests', () {
    test('1. Mobile app boots system kernel', () async {
      final controller = await AppLifecycleController.createDefault();
      expect(controller.kernel.state, equals(ModuleState.running));
      await controller.shutdownPlatform();
    });
  });
}
