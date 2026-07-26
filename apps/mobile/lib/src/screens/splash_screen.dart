import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/app_runtime_provider.dart';
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
    debugPrint("=== SPLASH SCREEN INITSTATE EXECUTING ===");
    _runInitializationSequence();
  }

  Future<void> _runInitializationSequence() async {
    debugPrint("=== CALLING RUST RUNTIME INITIALIZE & STARTUP STATE ===");
    final runtimeNotifier = ref.read(appRuntimeProvider.notifier);
    await runtimeNotifier.initializeRuntime((step) {
      if (mounted) {
        setState(() {
          _currentStep = step;
        });
      }
    });

    if (!mounted) return;

    final runtimeState = ref.read(appRuntimeProvider);
    debugPrint("=== RUST RETURNED STARTUP STATE: ${runtimeState.startupState} ===");

    switch (runtimeState.startupState) {
      case 'NeedsProfile':
        debugPrint("=== NAVIGATING TO: /onboarding/profile ===");
        context.go('/onboarding/profile');
        break;
      case 'NeedsLanguages':
        debugPrint("=== NAVIGATING TO: /onboarding/native-language ===");
        context.go('/onboarding/native-language');
        break;
      case 'NeedsPermissions':
        debugPrint("=== NAVIGATING TO: /onboarding/permissions ===");
        context.go('/onboarding/permissions');
        break;
      case 'NeedsModels':
        debugPrint("=== NAVIGATING TO: /onboarding/model-download ===");
        context.go('/onboarding/model-download');
        break;
      case 'Ready':
      default:
        debugPrint("=== NAVIGATING TO: /home ===");
        context.go('/home');
        break;
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
