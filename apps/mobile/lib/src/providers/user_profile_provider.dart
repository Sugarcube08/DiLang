import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../native_bridge.dart';

class UserProfileState {
  final Map<String, dynamic>? activeUser;
  final bool isLoading;
  final String? error;

  UserProfileState({
    this.activeUser,
    required this.isLoading,
    this.error,
  });

  UserProfileState copyWith({
    Map<String, dynamic>? activeUser,
    bool? isLoading,
    String? error,
  }) {
    return UserProfileState(
      activeUser: activeUser ?? this.activeUser,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class UserProfileNotifier extends StateNotifier<UserProfileState> {
  UserProfileNotifier() : super(UserProfileState(isLoading: true)) {
    loadActiveUser();
  }

  void loadActiveUser() {
    try {
      final userJson = DiLangNativeBridge.getActiveUser();
      if (userJson.isNotEmpty && !userJson.startsWith('Error')) {
        final map = jsonDecode(userJson) as Map<String, dynamic>;
        state = state.copyWith(activeUser: map, isLoading: false);
      } else {
        state = state.copyWith(activeUser: null, isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(activeUser: null, isLoading: false, error: e.toString());
    }
  }

  bool createUserProfile({
    required String username,
    required String nativeLang,
    required String targetLang,
    required String avatar,
    required int age,
    required String country,
    required String timezone,
    required int dailyMinutes,
  }) {
    try {
      final resultJson = DiLangNativeBridge.createUserProfile(
        username,
        nativeLang,
        targetLang,
        avatar,
        age,
        country,
        timezone,
        dailyMinutes,
      );
      if (resultJson.isNotEmpty && !resultJson.startsWith('Error')) {
        final map = jsonDecode(resultJson) as Map<String, dynamic>;
        state = state.copyWith(activeUser: map, isLoading: false);
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

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfileState>((ref) {
  return UserProfileNotifier();
});
