import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../native_bridge.dart';

class InstalledModelsState {
  final List<dynamic> models;
  final bool isLoading;
  final String? error;

  InstalledModelsState({
    required this.models,
    required this.isLoading,
    this.error,
  });

  InstalledModelsState copyWith({
    List<dynamic>? models,
    bool? isLoading,
    String? error,
  }) {
    return InstalledModelsState(
      models: models ?? this.models,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class InstalledModelsNotifier extends StateNotifier<InstalledModelsState> {
  InstalledModelsNotifier() : super(InstalledModelsState(models: [], isLoading: true)) {
    loadInstalledModels();
  }

  Future<void> loadInstalledModels() async {
    try {
      final jsonStr = await DiLangNativeBridge.listInstalledModels();
      if (jsonStr.isNotEmpty && !jsonStr.startsWith('Error')) {
        final list = jsonDecode(jsonStr) as List<dynamic>;
        state = state.copyWith(models: list, isLoading: false);
      } else {
        state = state.copyWith(models: [], isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(models: [], isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() => loadInstalledModels();

  Future<bool> installModel(String name, String version, List<int> bytes) async {
    try {
      final resultJson = await DiLangNativeBridge.installModel(name, version, bytes);
      if (resultJson.isNotEmpty && !resultJson.startsWith('Error')) {
        await loadInstalledModels();
        return true;
      } else {
        state = state.copyWith(error: resultJson);
        return false;
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

final installedModelsProvider =
    StateNotifierProvider<InstalledModelsNotifier, InstalledModelsState>((ref) {
  return InstalledModelsNotifier();
});
