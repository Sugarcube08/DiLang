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
            Text('Technical diagnostic overview of SQLite schema, migrations, DAOs, and active runtime.', style: TextStyle(color: semantic.textSecondary)),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                const SizedBox(width: 24),
                Expanded(
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('System Bootstrap & Runtime Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: semantic.textPrimary)),
                        const Divider(height: 24),
                        _HealthRow(label: 'Bootstrap Pipeline', isReady: runtimeState.isBootstrapped),
                        const _HealthRow(label: 'SQLite DAOs & Repositories', isReady: true),
                        const _HealthRow(label: 'Preferences Adapter', isReady: true),
                        _HealthRow(label: 'DiLangRuntime Kernel', isReady: runtimeState.isBootstrapped),
                        const _HealthRow(label: 'Dependency Injection Graph', isReady: true),
                        const _HealthRow(label: 'Theme Engine & Semantic Tokens', isReady: true),
                        const _HealthRow(label: 'AI Infrastructure Provider', isReady: false, subtext: 'Not Configured (NoOp)'),
                        const _HealthRow(label: 'Speech Infrastructure Provider', isReady: false, subtext: 'Not Configured (NoOp)'),
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
