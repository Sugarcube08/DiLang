import 'package:go_router/go_router.dart';
import '../native_bridge.dart';
import '../components/dilang_splash.dart';
import '../onboarding/profile_setup_screen.dart';
import '../onboarding/language_selection_screen.dart';
import '../onboarding/permission_manager_screen.dart';
import '../onboarding/runtime_check_screen.dart';
import '../onboarding/model_download_screen.dart';
import '../screens/home_screen.dart';

abstract class AppRoutes {
  static const String splash = '/';
  static const String onboardingProfile = '/onboarding/profile';
  static const String onboardingLanguages = '/onboarding/languages';
  static const String onboardingPermissions = '/onboarding/permissions';
  static const String onboardingRuntimeCheck = '/onboarding/runtime-check';
  static const String onboardingDownload = '/onboarding/download';
  static const String home = '/home';
}

// Global Onboarding Draft State
class OnboardingState {
  static String username = 'Learner';
  static String nativeLang = 'English';
  static String targetLang = 'German';
  static String dailyGoal = '15 min/day';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => DiLangSplashScreen(
        onSplashComplete: () {
          final activeUser = DiLangNativeBridge.getActiveUser();
          if (activeUser.isNotEmpty && !activeUser.startsWith('Error')) {
            context.go(AppRoutes.home);
          } else {
            context.go(AppRoutes.onboardingProfile);
          }
        },
      ),
    ),
    GoRoute(
      path: AppRoutes.onboardingProfile,
      builder: (context, state) => ProfileSetupScreen(
        onNext: (name, goal) {
          OnboardingState.username = name;
          OnboardingState.dailyGoal = goal;
          context.go(AppRoutes.onboardingLanguages);
        },
      ),
    ),
    GoRoute(
      path: AppRoutes.onboardingLanguages,
      builder: (context, state) => LanguageSelectionScreen(
        onNext: (native, target) {
          OnboardingState.nativeLang = native;
          OnboardingState.targetLang = target;
          context.go(AppRoutes.onboardingPermissions);
        },
      ),
    ),
    GoRoute(
      path: AppRoutes.onboardingPermissions,
      builder: (context, state) => PermissionManagerScreen(
        onNext: () => context.go(AppRoutes.onboardingRuntimeCheck),
      ),
    ),
    GoRoute(
      path: AppRoutes.onboardingRuntimeCheck,
      builder: (context, state) => RuntimeCheckScreen(
        onNext: () => context.go(AppRoutes.onboardingDownload),
      ),
    ),
    GoRoute(
      path: AppRoutes.onboardingDownload,
      builder: (context, state) => ModelDownloadScreen(
        onComplete: () {
          // Persist user profile to SQLite before entering Home
          DiLangNativeBridge.createUserProfile(
            OnboardingState.username,
            OnboardingState.nativeLang,
            OnboardingState.targetLang,
            'default_avatar.svg',
            25,
            'US',
            'UTC',
            15,
          );
          context.go(AppRoutes.home);
        },
      ),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
