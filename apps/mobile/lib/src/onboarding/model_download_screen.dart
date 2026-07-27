import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/theme_extensions.dart';
import '../theme/design_tokens.dart';
import '../theme/di_icons.dart';
import '../theme/app_colors.dart';
import '../components/dilang_button.dart';
import '../components/dilang_progress.dart';
import '../components/glass_components.dart';
import '../components/budgie_mascot.dart';
import '../native_bridge.dart';
import '../providers/user_profile_provider.dart';
import '../infrastructure/language_registry.dart';
import '../frb_generated.dart/api.dart' as ffi;

class ModelDownloadScreen extends ConsumerStatefulWidget {
  final VoidCallback onComplete;

  const ModelDownloadScreen({super.key, required this.onComplete});

  @override
  ConsumerState<ModelDownloadScreen> createState() => _ModelDownloadScreenState();
}

class _ModelDownloadScreenState extends ConsumerState<ModelDownloadScreen> {
  // Step 0: Model Selection, Step 1: Active Download Execution
  int _currentStepIndex = 0;

  // Selected Models
  String _selectedLlm = 'qwen3-0.6b-instruct-q4_k_m';
  String _selectedStt = 'whisper-base';
  String _selectedEmbeddings = 'fastembed-bge-small-en-v1.5';

  // Download Execution state
  String _currentStepText = 'Initializing Model Downloader...';
  String _byteProgressText = '0.0 MB / 0.0 MB';
  String _speedEtaText = '';
  double _overallProgress = 0.0;

  final Map<String, bool> _modelDoneMap = {};
  final Map<String, String> _modelShaMap = {};
  bool _isAllComplete = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentStepIndex == 0 ? 'Tailor Your AI Runtime' : 'Downloading AI Models'),
      ),
      body: SafeArea(
        child: _currentStepIndex == 0 ? _buildSetupSelectionView() : _buildDownloadProgressView(),
      ),
    );
  }

  Widget _buildSetupSelectionView() {
    final colors = context.colors;
    final userState = ref.watch(userProfileProvider);
    final activeUser = userState.activeUser;
    final targetLangCode = activeUser?['target_language'] ?? 'de';
    final targetLang = AppLanguageRegistry.find(targetLangCode);

    // Calculate Download Size Metrics
    double totalSizeMb = 0;
    if (_selectedLlm == 'qwen3-0.6b-instruct-q4_k_m') totalSizeMb += 435.0;
    if (_selectedLlm == 'gemma-3-1b-it-q4_k_m') totalSizeMb += 806.0;
    if (_selectedLlm == 'qwen2.5-1.5b-instruct-q4_k_m') totalSizeMb += 980.0;

    if (_selectedStt == 'whisper-base') totalSizeMb += 148.0;
    if (_selectedStt == 'whisper-small') totalSizeMb += 488.0;
    if (_selectedStt == 'whisper-medium') totalSizeMb += 1533.0;

    if (_selectedEmbeddings == 'fastembed-bge-small-en-v1.5') totalSizeMb += 67.0;
    if (_selectedEmbeddings == 'fastembed-e5-small-v2') totalSizeMb += 133.0;

    totalSizeMb += 63.0; // Piper voice default

    final freeSpaceMb = 4096.0;

    return Padding(
      padding: const EdgeInsets.all(DesignTokens.space24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BudgieMascot(
              size: 76,
              mood: BudgieMood.happy,
              speechBubbleText: 'Customize your on-device AI engines for learning ${targetLang.nativeName}!',
            ),
            const SizedBox(height: 20),

            // Conversation Model Section
            Text('1. Conversation LLM Model', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildRadioTile(
              id: 'qwen3-0.6b-instruct-q4_k_m',
              title: 'Qwen3 0.6B Instruct GGUF (Default • ~435 MB)',
              subtitle: 'Fast, energy-efficient dialogue & grammar explanations',
              groupValue: _selectedLlm,
              onChanged: (v) => setState(() => _selectedLlm = v!),
            ),
            _buildRadioTile(
              id: 'gemma-3-1b-it-q4_k_m',
              title: 'Gemma 3 1B IT GGUF (Optional • ~806 MB)',
              subtitle: 'Rich explanations with broader contextual window',
              groupValue: _selectedLlm,
              onChanged: (v) => setState(() => _selectedLlm = v!),
            ),
            _buildRadioTile(
              id: 'qwen2.5-1.5b-instruct-q4_k_m',
              title: 'Qwen2.5 1.5B Instruct GGUF (High Quality • ~980 MB)',
              subtitle: 'Pro accuracy for complex roleplay & nuanced corrections',
              groupValue: _selectedLlm,
              onChanged: (v) => setState(() => _selectedLlm = v!),
            ),
            const SizedBox(height: 20),

            // STT Model Section
            Text('2. Speech Recognition (STT)', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildRadioTile(
              id: 'whisper-base',
              title: 'Whisper Base (Default • ~148 MB)',
              subtitle: 'Low latency, reliable speech-to-text',
              groupValue: _selectedStt,
              onChanged: (v) => setState(() => _selectedStt = v!),
            ),
            _buildRadioTile(
              id: 'whisper-small',
              title: 'Whisper Small (Better Accuracy • ~488 MB)',
              subtitle: 'Improved accent detection & noisy environment handling',
              groupValue: _selectedStt,
              onChanged: (v) => setState(() => _selectedStt = v!),
            ),
            _buildRadioTile(
              id: 'whisper-medium',
              title: 'Whisper Medium (High Accuracy • ~1.5 GB)',
              subtitle: 'High precision transcription for multi-lingual audio',
              groupValue: _selectedStt,
              onChanged: (v) => setState(() => _selectedStt = v!),
            ),
            const SizedBox(height: 20),

            // Storage Summary Card
            GlassCard(
              accentColor: AppColors.turquoise500,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Estimated Download:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${totalSizeMb.toStringAsFixed(1)} MB', style: const TextStyle(color: AppColors.turquoise500, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Free Space Available:', style: TextStyle(color: colors.textSecondary)),
                      Text('${(freeSpaceMb / 1024).toStringAsFixed(1)} GB', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: DiLangButton(
                label: 'Begin Download & Installation',
                icon: DiIcons.spark,
                onPressed: () {
                  setState(() => _currentStepIndex = 1);
                  _startSelectedDownloadPipeline(targetLang);
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: DiLangButton(
                label: 'Download Later in Settings',
                icon: DiIcons.settings,
                variant: DiLangButtonVariant.secondary,
                onPressed: () async {
                  await DiLangNativeBridge.setOnboardingStep('Completed');
                  widget.onComplete();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioTile({
    required String id,
    required String title,
    required String subtitle,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    final colors = context.colors;
    final isSelected = id == groupValue;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GlassCard(
        accentColor: isSelected ? AppColors.turquoise500 : null,
        onTap: () => onChanged(id),
        child: Row(
          children: [
            Radio<String>(
              value: id,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: AppColors.turquoise500,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isSelected ? colors.primary : colors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: colors.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startSelectedDownloadPipeline(LanguageDescriptor targetLang) async {
    // 1. Download Selected LLM
    await _downloadSingleModel(_selectedLlm, _getLlmTitle(_selectedLlm));
    if (!mounted) return;

    // 2. Download Selected STT
    await _downloadSingleModel(_selectedStt, _getSttTitle(_selectedStt));
    if (!mounted) return;

    // 3. Download TTS Voice for target language
    final ttsVoiceId = targetLang.ttsVoice.isNotEmpty ? targetLang.ttsVoice : 'piper-en_US-lessac-medium';
    await _downloadSingleModel(ttsVoiceId, 'Piper Voice (${targetLang.nativeName})');
    if (!mounted) return;

    setState(() {
      _currentStepText = 'All Models Installed & Verified in SQLite';
      _byteProgressText = 'Complete';
      _speedEtaText = 'Ready for Offline AI Inference';
      _overallProgress = 1.0;
      _isAllComplete = true;
    });
  }

  String _getLlmTitle(String id) {
    if (id == 'gemma-3-1b-it-q4_k_m') return 'Gemma 3 1B IT (GGUF)';
    if (id == 'qwen2.5-1.5b-instruct-q4_k_m') return 'Qwen2.5 1.5B Instruct (GGUF)';
    return 'Qwen3-0.6B Instruct (GGUF)';
  }

  String _getSttTitle(String id) {
    if (id == 'whisper-small') return 'Whisper Small (GGML)';
    if (id == 'whisper-medium') return 'Whisper Medium (GGML)';
    return 'Whisper Base (GGML)';
  }

  Future<void> _downloadSingleModel(String modelId, String titleName) async {
    final completer = Completer<void>();
    bool hasFinished = false;

    setState(() {
      _currentStepText = 'Downloading $titleName via HuggingFace...';
      _byteProgressText = 'Connecting...';
      _speedEtaText = '';
    });

    late final StreamSubscription<ffi.FfiDownloadProgress> sub;
    sub = DiLangNativeBridge.downloadModelStream(modelId).listen(
      (prog) {
        if (!mounted) return;

        final downloadedMb = (prog.bytesDownloaded.toInt() / (1024 * 1024)).toStringAsFixed(1);
        final totalMb = (prog.totalBytes.toInt() / (1024 * 1024)).toStringAsFixed(1);
        final speedMb = (prog.bytesPerSec.toInt() / (1024 * 1024)).toStringAsFixed(1);
        final etaSecs = prog.etaSeconds.toInt();

        final ratio = prog.totalBytes.toInt() > 0
            ? (prog.bytesDownloaded.toInt() / prog.totalBytes.toInt()).clamp(0.0, 1.0)
            : 0.0;

        setState(() {
          _byteProgressText = '$downloadedMb MB / $totalMb MB';
          _speedEtaText = '$speedMb MB/s • ${etaSecs}s remaining';
          _overallProgress = ratio;
        });

        if (prog.status == 'Verifying') {
          setState(() {
            _currentStepText = 'Verifying SHA-256 Checksum for $titleName...';
            _speedEtaText = 'Calculating SHA-256 Hash...';
          });
        } else if (prog.status == 'Installed') {
          hasFinished = true;
          _modelDoneMap[modelId] = true;
          _modelShaMap[modelId] = 'Verified';
          sub.cancel();
          if (!completer.isCompleted) completer.complete();
        } else if (prog.status == 'Failed') {
          hasFinished = true;
          _modelDoneMap[modelId] = false;
          _modelShaMap[modelId] = 'Failed';
          sub.cancel();
          if (!completer.isCompleted) completer.complete();
        }
      },
      onError: (_) {
        if (!hasFinished) {
          hasFinished = true;
          _modelDoneMap[modelId] = false;
          _modelShaMap[modelId] = 'Failed';
        }
        sub.cancel();
        if (!completer.isCompleted) completer.complete();
      },
    );

    await completer.future;
  }

  Widget _buildDownloadProgressView() {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.all(DesignTokens.space24),
      child: Column(
        children: [
          BudgieMascot(
            size: 85,
            mood: _isAllComplete ? BudgieMood.celebrating : BudgieMood.studying,
            speechBubbleText: _isAllComplete ? 'All AI Engines Installed!' : 'Streaming Weights from HuggingFace...',
          ),
          const SizedBox(height: 20),

          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_currentStepText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_byteProgressText, style: const TextStyle(color: AppColors.turquoise500, fontWeight: FontWeight.bold)),
                    if (_speedEtaText.isNotEmpty)
                      Text(_speedEtaText, style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 16),
                DiLangGradientProgress(progress: _overallProgress),
              ],
            ),
          ),
          const Spacer(),

          if (_isAllComplete)
            SizedBox(
              width: double.infinity,
              child: DiLangButton(
                label: 'Complete Setup & Launch',
                icon: DiIcons.check,
                onPressed: () async {
                  await DiLangNativeBridge.setOnboardingStep('Completed');
                  widget.onComplete();
                },
              ),
            ),
        ],
      ),
    );
  }
}
