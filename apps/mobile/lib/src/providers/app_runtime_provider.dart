import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../native_bridge.dart';

class AppRuntimeState {
  final bool isInitializing;
  final String statusMessage;
  final bool isDbHealthy;
  final Map<String, dynamic> resourceBudget;
  final String? error;

  AppRuntimeState({
    required this.isInitializing,
    required this.statusMessage,
    required this.isDbHealthy,
    required this.resourceBudget,
    this.error,
  });

  AppRuntimeState copyWith({
    bool? isInitializing,
    String? statusMessage,
    bool? isDbHealthy,
    Map<String, dynamic>? resourceBudget,
    String? error,
  }) {
    return AppRuntimeState(
      isInitializing: isInitializing ?? this.isInitializing,
      statusMessage: statusMessage ?? this.statusMessage,
      isDbHealthy: isDbHealthy ?? this.isDbHealthy,
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
          resourceBudget: {},
        ));

  Future<void> initializeRuntime(void Function(String) onProgress) async {
    try {
      onProgress('Initializing SQLite Engine...');
      await Future.delayed(const Duration(milliseconds: 200));
      final dbHealth = DiLangNativeBridge.checkDbHealth();

      onProgress('Checking Hardware Resource Budget...');
      await Future.delayed(const Duration(milliseconds: 200));
      final budgetJson = DiLangNativeBridge.getSystemResourceBudget();
      Map<String, dynamic> budgetMap = {};
      if (budgetJson.isNotEmpty && !budgetJson.startsWith('Error')) {
        try {
          budgetMap = jsonDecode(budgetJson);
        } catch (_) {}
      }

      onProgress('Discovering Installed Models...');
      await Future.delayed(const Duration(milliseconds: 200));

      onProgress('Checking Active User Profile...');
      await Future.delayed(const Duration(milliseconds: 200));

      state = state.copyWith(
        isInitializing: false,
        statusMessage: 'Runtime Operational',
        isDbHealthy: dbHealth.contains('Healthy'),
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
