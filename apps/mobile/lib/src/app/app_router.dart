import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/conversation_screen.dart';
import '../screens/developer_showcase_screen.dart';
import '../onboarding/profile_setup_screen.dart';
import '../onboarding/native_language_screen.dart';
import '../onboarding/target_language_screen.dart';
import '../onboarding/permission_manager_screen.dart';
import '../onboarding/model_download_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding/profile',
      builder: (context, state) => const ProfileSetupScreen(),
    ),
    GoRoute(
      path: '/onboarding/native-language',
      builder: (context, state) => const NativeLanguageScreen(),
    ),
    GoRoute(
      path: '/onboarding/target-language',
      builder: (context, state) => const TargetLanguageScreen(),
    ),
    GoRoute(
      path: '/onboarding/permissions',
      builder: (context, state) => PermissionManagerScreen(
        onNext: () => context.go('/onboarding/model-download'),
      ),
    ),
    GoRoute(
      path: '/onboarding/model-download',
      builder: (context, state) => ModelDownloadScreen(
        onComplete: () => context.go('/home'),
      ),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/conversation',
      builder: (context, state) => const ConversationScreen(),
    ),
    GoRoute(
      path: '/developer-showcase',
      builder: (context, state) => const DeveloperShowcaseScreen(),
    ),
  ],
);
