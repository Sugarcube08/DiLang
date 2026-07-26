import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../native_bridge.dart';

class AppRuntimeState {
  final bool isInitializing;
  final String statusMessage;
  final bool isDbHealthy;
  final String startupState; // NeedsProfile, NeedsLanguages, NeedsPermissions, NeedsModels, Ready
  final Map<String, dynamic> resourceBudget;
  final String? error;

  AppRuntimeState({
    required this.isInitializing,
    required this.statusMessage,
    required this.isDbHealthy,
    required this.startupState,
    required this.resourceBudget,
    this.error,
  });

  AppRuntimeState copyWith({
    bool? isInitializing,
    String? statusMessage,
    bool? isDbHealthy,
    String? startupState,
    Map<String, dynamic>? resourceBudget,
    String? error,
  }) {
    return AppRuntimeState(
      isInitializing: isInitializing ?? this.isInitializing,
      statusMessage: statusMessage ?? this.statusMessage,
      isDbHealthy: isDbHealthy ?? this.isDbHealthy,
      startupState: startupState ?? this.startupState,
      resourceBudget: resourceBudget ?? this.resourceBudget,
      error: error,
    );
  }
}

class AppRuntimeNotifier extends StateNotifier<AppRuntimeState> {
  AppRuntimeNotifier()
      : super(AppRuntimeState(
          isInitializing: true,
          statusMessage: 'Starting Runtime...',
          isDbHealthy: false,
          startupState: 'NeedsProfile',
          resourceBudget: {},
        ));

  Future<void> initializeRuntime(void Function(String) onProgress) async {
    try {
      onProgress('Initializing SQLite Engine...');
      final dbHealth = await DiLangNativeBridge.checkDbHealth();

      onProgress('Checking Hardware Resource Budget...');
      final budgetJson = await DiLangNativeBridge.getSystemResourceBudget();
      Map<String, dynamic> budgetMap = {};
      if (budgetJson.isNotEmpty && !budgetJson.startsWith('Error')) {
        try {
          budgetMap = jsonDecode(budgetJson);
        } catch (_) {}
      }

      onProgress('Querying Backend Startup State Machine...');
      final stateStr = await DiLangNativeBridge.getStartupState();

      state = state.copyWith(
        isInitializing: false,
        statusMessage: 'Runtime Operational',
        isDbHealthy: dbHealth.contains('Healthy'),
        startupState: stateStr,
        resourceBudget: budgetMap,
      );
    } catch (e) {
      state = state.copyWith(
        isInitializing: false,
        statusMessage: 'Initialization Error',
        error: e.toString(),
      );
    }
  }
}

final appRuntimeProvider =
    StateNotifierProvider<AppRuntimeNotifier, AppRuntimeState>((ref) {
  return AppRuntimeNotifier();
});
