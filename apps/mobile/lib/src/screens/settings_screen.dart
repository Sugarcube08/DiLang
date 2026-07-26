import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../native_bridge.dart';
import '../providers/installed_models_provider.dart';
import '../providers/user_profile_provider.dart';
import '../theme/theme_extensions.dart';
import '../theme/design_tokens.dart';
import '../theme/di_icons.dart';
import '../components/dilang_card.dart';
import '../components/dilang_button.dart';
import '../components/dilang_progress.dart';
import '../components/budgie_circular_logo.dart';
import '../components/glass_components.dart';
import '../frb_generated.dart/api.dart' as ffi;

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // Active download state tracking
  String? _downloadingModelId;
  String _downloadStatusText = '';
  String _downloadSpeedEta = '';
  double _downloadProgress = 0.0;
  StreamSubscription<ffi.FfiDownloadProgress>? _activeStreamSub;

  @override
  void dispose() {
    _activeStreamSub?.cancel();
    super.dispose();
  }

  Future<void> _startModelDownload(String modelId, String titleName) async {
    setState(() {
      _downloadingModelId = modelId;
      _downloadStatusText = 'Connecting to download stream for $titleName...';
      _downloadSpeedEta = '';
      _downloadProgress = 0.0;
    });

    _activeStreamSub?.cancel();
    _activeStreamSub = DiLangNativeBridge.downloadModelStream(modelId).listen(
      (prog) async {
        if (!mounted) return;

        final downloadedMb = (prog.bytesDownloaded.toInt() / (1024 * 1024)).toStringAsFixed(1);
        final totalMb = (prog.totalBytes.toInt() / (1024 * 1024)).toStringAsFixed(1);
        final speedMb = (prog.bytesPerSec.toInt() / (1024 * 1024)).toStringAsFixed(1);
        final etaSecs = prog.etaSeconds.toInt();

        final ratio = prog.totalBytes.toInt() > 0
            ? (prog.bytesDownloaded.toInt() / prog.totalBytes.toInt()).clamp(0.0, 1.0)
            : 0.0;

        setState(() {
          _downloadStatusText = '$downloadedMb MB / $totalMb MB';
          _downloadSpeedEta = '$speedMb MB/s • ${etaSecs}s remaining';
          _downloadProgress = ratio;
        });

        if (prog.status == 'Verifying') {
          setState(() {
            _downloadStatusText = 'Verifying SHA-256 Checksum for $titleName...';
            _downloadSpeedEta = 'Calculating Hash...';
          });
        } else if (prog.status == 'Installed') {
          _activeStreamSub?.cancel();
          await ref.read(installedModelsProvider.notifier).refresh();
          if (!mounted) return;
          setState(() {
            _downloadingModelId = null;
            _downloadStatusText = '';
            _downloadSpeedEta = '';
            _downloadProgress = 0.0;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$titleName installed and verified successfully!')),
          );
        } else if (prog.status == 'Failed') {
          _activeStreamSub?.cancel();
          if (!mounted) return;
          setState(() {
            _downloadingModelId = null;
            _downloadStatusText = '';
            _downloadSpeedEta = '';
            _downloadProgress = 0.0;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to download $titleName. Please try again.')),
          );
        }
      },
      onError: (err) {
        if (!mounted) return;
        _activeStreamSub?.cancel();
        setState(() {
          _downloadingModelId = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download error: $err')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final userState = ref.watch(userProfileProvider);
    final modelsState = ref.watch(installedModelsProvider);

    final activeUser = userState.activeUser;
    final username = activeUser?['username']?.toString() ?? 'Learner';
    final nativeLang = activeUser?['native_language']?.toString() ?? 'English';
    final targetLang = activeUser?['target_language']?.toString() ?? 'German';

    final installedModels = modelsState.models;
    final isGemmaInstalled = installedModels.any((m) {
      final s = '${m['id']} ${m['name']} ${m['filename']} ${m['path']}'.toLowerCase();
      return s.contains('gemma');
    });
    final isWhisperInstalled = installedModels.any((m) {
      final s = '${m['id']} ${m['name']} ${m['filename']} ${m['path']}'.toLowerCase();
      return s.contains('whisper') || s.contains('ggml-base');
    });
    final isPiperInstalled = installedModels.any((m) {
      final s = '${m['id']} ${m['name']} ${m['filename']} ${m['path']}'.toLowerCase();
      return s.contains('piper') || s.contains('lessac');
    });

    return AtmosphereBackground(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings & Model Center'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(DesignTokens.space24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Summary
              Text('Learner Profile', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              DiLangCard(
                child: Row(
                  children: [
                    const BudgieCircularLogo(size: 52),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 2),
                          Text('$nativeLang -> $targetLang', style: TextStyle(color: colors.textSecondary, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            // On-Device Model Download Center
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Model Download Center', style: Theme.of(context).textTheme.titleLarge),
                IconButton(
                  icon: const Icon(DiIcons.refresh),
                  onPressed: () {
                    ref.read(installedModelsProvider.notifier).refresh();
                  },
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Download or update local AI models anytime for offline inference.',
              style: TextStyle(color: colors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 12),

            // Active Download Progress Widget
            if (_downloadingModelId != null) ...[
              DiLangCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_downloadStatusText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 4),
                    if (_downloadSpeedEta.isNotEmpty)
                      Text(_downloadSpeedEta, style: TextStyle(color: colors.primary, fontSize: 12)),
                    const SizedBox(height: 12),
                    DiLangGradientProgress(progress: _downloadProgress),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Model Cards
            _buildModelItemCard(
              title: 'Gemma 3 1B IT (GGUF Q4_K_M)',
              subtitle: 'On-device LLM for natural dialogue & grammar analysis (~806 MB)',
              modelId: 'gemma-3-1b-it-q4_k_m',
              isInstalled: isGemmaInstalled,
              colors: colors,
            ),
            const SizedBox(height: 12),
            _buildModelItemCard(
              title: 'Whisper Base (GGML)',
              subtitle: 'On-device Speech-to-Text for voice input (~148 MB)',
              modelId: 'whisper-base',
              isInstalled: isWhisperInstalled,
              colors: colors,
            ),
            const SizedBox(height: 12),
            _buildModelItemCard(
              title: 'Piper Voice (ONNX)',
              subtitle: 'On-device Text-to-Speech for audio synthesis (~63 MB)',
              modelId: 'piper-en_US-lessac-medium',
              isInstalled: isPiperInstalled,
              colors: colors,
            ),
            const SizedBox(height: 32),

            // Advanced Diagnostics & Showcase Links
            Text('Advanced Diagnostics & Tools', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            DiLangCard(
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(DiIcons.tune, color: colors.primary),
                      title: const Text('Runtime Diagnostics'),
                      subtitle: const Text('Inspect RAM, CPU, SQLite path & active loaders'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/diagnostics'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(DiIcons.spark, color: colors.primary),
                      title: const Text('Developer Showcase'),
                      subtitle: const Text('Design system tokens & component showcase'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/developer-showcase'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildModelItemCard({
    required String title,
    required String subtitle,
    required String modelId,
    required bool isInstalled,
    required dynamic colors,
  }) {
    final isDownloading = _downloadingModelId == modelId;

    return DiLangCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isInstalled ? DiIcons.check : DiIcons.time,
                color: isInstalled ? colors.success : colors.warning,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (isInstalled ? colors.success : colors.warning).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isInstalled ? 'Installed' : 'Not Installed',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isInstalled ? colors.success : colors.warning,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(subtitle, style: TextStyle(color: colors.textSecondary, fontSize: 13)),
          const SizedBox(height: 12),
          if (!isInstalled)
            SizedBox(
              width: double.infinity,
              child: DiLangButton(
                label: isDownloading ? 'Downloading...' : 'Download Model',
                icon: DiIcons.spark,
                variant: DiLangButtonVariant.secondary,
                onPressed: isDownloading ? null : () => _startModelDownload(modelId, title),
              ),
            ),
        ],
      ),
    );
  }
}
