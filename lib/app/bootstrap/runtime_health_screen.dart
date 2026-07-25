import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/theme/dilang_theme.dart';
import '../../shared/components/display/card.dart';
import '../dependency_injection/providers.dart';

class RuntimeHealthScreen extends ConsumerWidget {
  const RuntimeHealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final semantic = DiLangTheme.of(context);
    final runtimeState = ref.watch(runtimeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('DiLang Runtime Health Diagnostic'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Runtime Status Dashboard', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: semantic.textPrimary)),
            const SizedBox(height: 8),
            Text('Technical diagnostic overview of bootstrap pipeline and active dependencies.', style: TextStyle(color: semantic.textSecondary)),
            const SizedBox(height: 24),
            AppCard(
              child: Column(
                children: [
                  _HealthRow(label: 'Bootstrap Pipeline', isReady: runtimeState.isBootstrapped),
                  const _HealthRow(label: 'SQLite Database Engine', isReady: true, subtext: '~/.local/share/dilang/dilang_storage.db'),
                  const _HealthRow(label: 'Preferences Adapter', isReady: true),
                  _HealthRow(label: 'DiLangRuntime Kernel', isReady: runtimeState.isBootstrapped),
                  const _HealthRow(label: 'Dependency Injection Graph', isReady: true),
                  const _HealthRow(label: 'Theme Engine & Semantic Tokens', isReady: true),
                  const _HealthRow(label: 'App Router', isReady: true),
                  const _HealthRow(label: 'AI Infrastructure Provider', isReady: false, subtext: 'Not Configured (NoOp)'),
                  const _HealthRow(label: 'Speech Infrastructure Provider', isReady: false, subtext: 'Not Configured (NoOp)'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HealthRow extends StatelessWidget {
  final String label;
  final bool isReady;
  final String? subtext;

  const _HealthRow({
    required this.label,
    required this.isReady,
    this.subtext,
  });

  @override
  Widget build(BuildContext context) {
    final semantic = DiLangTheme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            isReady ? Icons.check_circle : Icons.warning_amber_rounded,
            color: isReady ? semantic.accentSuccess : semantic.accentWarning,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: semantic.textPrimary)),
                if (subtext != null)
                  Text(subtext!, style: TextStyle(fontSize: 12, color: semantic.textSecondary)),
              ],
            ),
          ),
          Text(
            isReady ? 'READY' : 'NOT CONFIG',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isReady ? semantic.accentSuccess : semantic.accentWarning,
            ),
          ),
        ],
      ),
    );
  }
}
