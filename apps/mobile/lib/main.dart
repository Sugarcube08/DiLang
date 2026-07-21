import 'package:dilang_application/application.dart';

void main() async {
  final controller = await AppLifecycleController.createDefault();
  await controller.bootPlatform();
}
