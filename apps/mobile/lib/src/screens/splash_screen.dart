import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/app_runtime_provider.dart';
import '../providers/user_profile_provider.dart';
import '../theme/theme_extensions.dart';
import '../theme/di_icons.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  String _currentStep = 'Initializing System...';

  @override
  void initState() {
    super.initState();
    _runInitializationSequence();
  }

  Future<void> _runInitializationSequence() async {
    final runtimeNotifier = ref.read(appRuntimeProvider.notifier);
    await runtimeNotifier.initializeRuntime((step) {
      if (mounted) {
        setState(() {
          _currentStep = step;
        });
      }
    });

    if (!mounted) return;

    final userState = ref.read(userProfileProvider);
    if (userState.activeUser != null) {
      context.go('/home');
    } else {
      context.go('/onboarding/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                DiIcons.brain,
                size: 72,
                color: colors.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'DiLang',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Privacy-First Local AI Runtime',
                style: TextStyle(color: colors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                ),
              ),
              const SizedBox(height: 16),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  _currentStep,
                  key: ValueKey(_currentStep),
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
