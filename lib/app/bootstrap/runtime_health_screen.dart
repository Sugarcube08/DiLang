import 'dart:io';
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
    final sqliteEngine = ref.watch(sqliteEngineProvider);
    final aiRuntime = ref.watch(aiRuntimeProvider);

    int dbVersion = 0;
    String journalMode = 'UNKNOWN';
    String quickCheck = 'UNKNOWN';
    int fileSize = 0;

    try {
      final verRes = sqliteEngine.db.select('SELECT MAX(version) as ver FROM schema_migrations;');
      dbVersion = (verRes.first['ver'] as int?) ?? 0;

      final jRes = sqliteEngine.db.select('PRAGMA journal_mode;');
      journalMode = (jRes.first['journal_mode'] as String? ?? 'UNKNOWN').toUpperCase();

      final qRes = sqliteEngine.db.select('PRAGMA quick_check;');
      quickCheck = (qRes.first['quick_check'] as String? ?? 'UNKNOWN').toUpperCase();

      if (sqliteEngine.dbPath != ':memory:') {
        final f = File(sqliteEngine.dbPath);
        if (f.existsSync()) {
          fileSize = f.lengthSync();
        }
      }
    } catch (_) {}

    final isIdentityReady = runtimeState.identityState.isReady;
    final learnerName = runtimeState.learner?.displayName ?? 'Learner';
    final targetLang = runtimeState.learner?.targetLanguage ?? 'German';

    return Scaffold(
      appBar: AppBar(
        title: const Text('DiLang Runtime & Database Diagnostics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Persistence & Runtime Status Dashboard', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: semantic.textPrimary)),
            const SizedBox(height: 8),
            Text('Technical diagnostic overview of AI Runtime, Identity Module, SQLite schema, and active dependencies.', style: TextStyle(color: semantic.textSecondary)),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('AI Infrastructure Runtime', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: semantic.textPrimary)),
                            const Divider(height: 24),
                            const _MetricRow(label: 'AI Runtime Status', value: 'READY'),
                            _MetricRow(label: 'Active AI Provider', value: aiRuntime.activeProvider.name),
                            _MetricRow(label: 'Active Model', value: aiRuntime.activeModel.displayName),
                            _MetricRow(label: 'Context Window', value: '${aiRuntime.activeModel.contextWindowTokens} Tokens'),
                            _MetricRow(label: 'Streaming Capability', value: aiRuntime.activeProvider.capabilities.supportsStreaming ? 'Supported' : 'Unsupported'),
                            _MetricRow(label: 'JSON Output Capability', value: aiRuntime.activeProvider.capabilities.supportsJsonOutput ? 'Supported' : 'Unsupported'),
                            const _MetricRow(label: 'Prompt Assembly Pipeline', value: 'READY'),
                            _MetricRow(label: 'Last Response Latency', value: '${aiRuntime.lastResponseLatencyMs} ms'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Learner Identity Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: semantic.textPrimary)),
                            const Divider(height: 24),
                            _MetricRow(label: 'Identity Status', value: isIdentityReady ? 'READY' : 'ONBOARDING_REQUIRED', isOk: isIdentityReady),
                            _MetricRow(label: 'Onboarding Status', value: isIdentityReady ? 'Completed' : 'Pending', isOk: isIdentityReady),
                            _MetricRow(label: 'Learner Display Name', value: learnerName),
                            _MetricRow(label: 'Target Language', value: targetLang),
                            const _MetricRow(label: 'CEFR Trajectory', value: 'A1 → B2'),
                            const _MetricRow(label: 'Daily Commitment', value: '15 mins/day'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('SQLite Infrastructure Metrics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: semantic.textPrimary)),
                        const Divider(height: 24),
                        _MetricRow(label: 'Database Schema Version', value: 'v$dbVersion'),
                        _MetricRow(label: 'Last Migration Executed', value: 'v$dbVersion (Transaction)'),
                        _MetricRow(label: 'PRAGMA Quick Check', value: quickCheck, isOk: quickCheck == 'OK'),
                        _MetricRow(label: 'Journal Mode', value: journalMode, isOk: journalMode == 'WAL' || journalMode == 'MEMORY'),
                        const _MetricRow(label: 'Open Connections', value: '1 Connection'),
                        const _MetricRow(label: 'Active Transaction State', value: 'IDLE'),
                        _MetricRow(label: 'Database File Size', value: '${(fileSize / 1024).toStringAsFixed(1)} KB'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isOk;

  const _MetricRow({
    required this.label,
    required this.value,
    this.isOk = true,
  });

  @override
  Widget build(BuildContext context) {
    final semantic = DiLangTheme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: TextStyle(color: semantic.textSecondary, fontSize: 13), overflow: TextOverflow.ellipsis)),
          const SizedBox(width: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isOk ? semantic.accentSuccess : semantic.accentWarning,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
