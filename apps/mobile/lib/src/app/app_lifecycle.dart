import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('AppLifecycleObserver');

class AppLifecycleObserver with WidgetsBindingObserver {
  void register() {
    WidgetsBinding.instance.addObserver(this);
    _logger.info('Registered AppLifecycleObserver');
  }

  void unregister() {
    WidgetsBinding.instance.removeObserver(this);
    _logger.info('Unregistered AppLifecycleObserver');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _logger.info('App Lifecycle State Changed: $state');
    switch (state) {
      case AppLifecycleState.resumed:
        _logger.info('Resumed: Syncing state and restoring session');
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _logger.info('Paused/Detached: Flushing write buffers to Rust core');
        break;
      default:
        break;
    }
  }
}
