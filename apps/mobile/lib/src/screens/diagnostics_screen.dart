import 'dart:convert';
import 'package:flutter/material.dart';
import '../native_bridge.dart';
import '../theme/theme_extensions.dart';
import '../theme/design_tokens.dart';
import '../theme/di_icons.dart';
import '../components/dilang_card.dart';

class DiagnosticsScreen extends StatefulWidget {
  const DiagnosticsScreen({super.key});

  @override
  State<DiagnosticsScreen> createState() => _DiagnosticsScreenState();
}

class _DiagnosticsScreenState extends State<DiagnosticsScreen> {
  bool _isLoading = true;
  Map<String, dynamic> _diagnostics = {};

  @override
  void initState() {
    super.initState();
    _loadDiagnostics();
  }

  Future<void> _loadDiagnostics() async {
    setState(() => _isLoading = true);
    final jsonStr = await DiLangNativeBridge.getRuntimeDiagnostics();
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          _diagnostics = map;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Runtime Diagnostics'),
        actions: [
          IconButton(
            icon: Icon(DiIcons.settings, color: colors.primary),
            onPressed: _loadDiagnostics,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(DesignTokens.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Local AI Runtime Health & Telemetry',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // SQLite Status Card
                  DiLangCard(
                    child: ListTile(
                      leading: Icon(DiIcons.check, color: colors.success),
                      title: const Text('SQLite Database Path'),
                      subtitle: Text(
                        _diagnostics['sqlite_database_path']?.toString() ?? 'Unknown',
                        style: TextStyle(fontSize: 12, color: colors.textSecondary),
                      ),
                      trailing: Chip(
                        label: Text(_diagnostics['sqlite_status']?.toString() ?? 'Healthy'),
                        backgroundColor: colors.success.withValues(alpha: 0.1),
                        labelStyle: TextStyle(color: colors.success),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Hardware Budget Card
                  DiLangCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hardware Budget & Accelerators', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Max CPU Threads:', style: TextStyle(color: colors.textSecondary)),
                            Text('${_diagnostics['max_cpu_threads'] ?? 4}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Max RAM Allocation:', style: TextStyle(color: colors.textSecondary)),
                            Text('${_diagnostics['max_ram_mb'] ?? 4096} MB', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('GPU Hardware Acceleration:', style: TextStyle(color: colors.textSecondary)),
                            Text(
                              (_diagnostics['gpu_available'] == true) ? 'Available (Vulkan/Metal)' : 'Disabled (CPU Native)',
                              style: TextStyle(color: (_diagnostics['gpu_available'] == true) ? colors.success : colors.warning),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // AI Engine Loaders Card
                  DiLangCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('On-Device Model Loaders', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        ListTile(
                          dense: true,
                          leading: Icon(DiIcons.brain, color: colors.primary),
                          title: const Text('LLM Engine (Gemma 3 1B)'),
                          subtitle: Text(_diagnostics['gemma_loader']?.toString() ?? 'llama.cpp GGUF'),
                        ),
                        ListTile(
                          dense: true,
                          leading: Icon(DiIcons.mic, color: colors.primary),
                          title: const Text('STT Engine (Whisper)'),
                          subtitle: Text(_diagnostics['whisper_loader']?.toString() ?? 'whisper.cpp GGML'),
                        ),
                        ListTile(
                          dense: true,
                          leading: Icon(DiIcons.speaker, color: colors.primary),
                          title: const Text('TTS Engine (Piper)'),
                          subtitle: Text(_diagnostics['piper_loader']?.toString() ?? 'Piper ONNX'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
