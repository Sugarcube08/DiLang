import 'package:flutter/material.dart';
import '../../modules/design_system/pages/component_gallery_page.dart';
import '../bootstrap/runtime_health_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String gallery = '/gallery';
  static const String health = '/health';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case gallery:
        return MaterialPageRoute(builder: (_) => const ComponentGalleryPage());
      case health:
        return MaterialPageRoute(builder: (_) => const RuntimeHealthScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('DiLang Shell')),
          ),
        );
    }
  }

  const AppRoutes._();
}
