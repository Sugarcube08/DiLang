import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Single Composition Root for Application Dependency Injection.
/// Never instantiate repositories directly inside Widgets or Screen Trees.
class AppContainer {
  static final ProviderContainer container = ProviderContainer();

  static void initialize() {
    // Initialize container Singletons
  }
}
