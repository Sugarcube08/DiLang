import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../components/dilang_splash.dart';
import '../components/design_showcase.dart';

abstract class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String conversation = '/conversation';
  static const String vocabulary = '/vocabulary';
  static const String grammar = '/grammar';
  static const String analytics = '/analytics';
  static const String review = '/review';
  static const String settings = '/settings';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => DiLangSplashScreen(
        onSplashComplete: () => context.go(AppRoutes.home),
      ),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => DesignSystemShowcaseScreen(
        onToggleTheme: () {},
      ),
    ),
  ],
);
