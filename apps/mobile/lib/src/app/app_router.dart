import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/conversation_screen.dart';
import '../screens/developer_showcase_screen.dart';
import '../onboarding/profile_setup_screen.dart';
import '../onboarding/language_selection_screen.dart';
import '../onboarding/permission_manager_screen.dart';
import '../onboarding/runtime_check_screen.dart';
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
      path: '/onboarding/languages',
      builder: (context, state) => LanguageSelectionScreen(
        onNext: (native, target) => context.go('/onboarding/permissions'),
      ),
    ),
    GoRoute(
      path: '/onboarding/permissions',
      builder: (context, state) => PermissionManagerScreen(
        onNext: () => context.go('/onboarding/runtime-check'),
      ),
    ),
    GoRoute(
      path: '/onboarding/runtime-check',
      builder: (context, state) => RuntimeCheckScreen(
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
      builder: (context, state) => const ConversationScreen(
        scenarioId: 'cafe_order',
        scenarioTitle: 'Ordering Coffee in Berlin',
      ),
    ),
    GoRoute(
      path: '/developer-showcase',
      builder: (context, state) => const DeveloperShowcaseScreen(),
    ),
  ],
);
