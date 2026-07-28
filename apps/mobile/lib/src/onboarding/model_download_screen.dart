import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../native_bridge.dart';
import '../providers/user_profile_provider.dart';
import '../providers/model_download_provider.dart';
import '../theme/theme_extensions.dart';
import '../theme/design_tokens.dart';
import '../theme/di_icons.dart';
import '../theme/app_colors.dart';
import '../components/toucan_mascot.dart';
import '../components/dilang_button.dart';
import '../components/responsive/responsive.dart';
import '../components/model_download_components.dart';

class ModelDownloadScreen extends ConsumerStatefulWidget {
  final VoidCallback onComplete;

  const ModelDownloadScreen({super.key, required this.onComplete});

  @override
  ConsumerState<ModelDownloadScreen> createState() =>
      _ModelDownloadScreenState();
}

class _ModelDownloadScreenState extends ConsumerState<ModelDownloadScreen>
    with WidgetsBindingObserver {
  int _currentStepIndex = 0; // 0 = Selection, 1 = Downloading

  // Selected models
  String _selectedLlm = 'qwen3-0.6b-instruct-q4_k_m';
  String _selectedStt = 'whisper-base';

  // State tracking
  bool _isAllComplete = false;
  bool _showFocusBanner = false;

  final Set<String> _completedModelIds = {};

  final Map<String, double> _modelSizeMbMap = {
    'qwen3-0.6b-instruct-q4_k_m': 435.0,
    'gemma-3-1b-it-q4_k_m': 1040.0,
    'qwen2.5-1.5b-instruct-q4_k_m': 1040.0,
    'whisper-base': 148.0,
    'whisper-small': 465.0,
    'piper-en_US-lessac-medium': 63.0,
    'bge-small-en-v1.5': 130.0,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final downloadState = ref.read(modelDownloadProvider);
    final isHidden = state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden;

    if (isHidden && downloadState.isVerifying) {
      if (!_showFocusBanner) {
        setState(() => _showFocusBanner = true);
      }
    } else if (state == AppLifecycleState.resumed || !downloadState.isVerifying) {
      if (_showFocusBanner) {
        setState(() => _showFocusBanner = false);
      }
    }
  }

  double _calculateTotalDownloadSize() {
    final llmSize = _modelSizeMbMap[_selectedLlm] ?? 435.0;
    final sttSize = _modelSizeMbMap[_selectedStt] ?? 148.0;
    final ttsSize = _modelSizeMbMap['piper-en_US-lessac-medium'] ?? 63.0;
    return llmSize + sttSize + ttsSize;
  }

  void _startSelectedDownloadPipeline(String targetLang) async {
    final pipeline = [
      {'id': _selectedLlm, 'name': 'Conversation LLM', 'desc': 'On-device language reasoning engine'},
      {'id': _selectedStt, 'name': 'Whisper STT Engine', 'desc': 'On-device speech recognition'},
      {'id': 'piper-en_US-lessac-medium', 'name': 'Piper TTS Engine', 'desc': 'On-device text-to-speech audio synthesis'},
    ];

    int completedCount = 0;
    _completedModelIds.clear();

    for (final item in pipeline) {
      final modelId = item['id']!;
      final modelName = item['name']!;

      if (!mounted) return;

      final success = await ref
          .read(modelDownloadProvider.notifier)
          .startDownload(modelId, modelName);

      if (success) {
        completedCount++;
        _completedModelIds.add(modelId);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Warning: $modelName download encountered an issue.'),
          ),
        );
      }
    }

    if (!mounted) return;

    if (completedCount == pipeline.length) {
      setState(() {
        _isAllComplete = true;
        _showFocusBanner = false;
      });
    } else {
      setState(() {
        _isAllComplete = false;
        _showFocusBanner = false;
      });
    }
  }

  Future<void> _handleBackNavigation() async {
    final downloadState = ref.read(modelDownloadProvider);
    if (_currentStepIndex == 1) {
      if (!_isAllComplete && (downloadState.isDownloading || downloadState.isVerifying)) {
        final shouldCancel = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Cancel Model Installation?'),
            content: const Text(
              'Model download or verification is currently in progress. Returning to model selection will cancel active operations.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Keep Downloading'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Cancel & Go Back', style: TextStyle(color: AppColors.coral500)),
              ),
            ],
          ),
        ) ?? false;

        if (!shouldCancel) return;
        ref.read(modelDownloadProvider.notifier).cancelActiveDownload();
      }
      setState(() {
        _currentStepIndex = 0;
        _showFocusBanner = false;
      });
    } else {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else {
        context.go('/onboarding/permissions');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProfileProvider);
    final activeUser = userState.activeUser;
    final targetLang = activeUser?['target_language']?.toString() ?? 'German';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackNavigation();
      },
      child: Scaffold(
        appBar: ResponsiveAppBar(
          title: Text(
            _currentStepIndex == 0 ? 'Select AI Models' : 'Model Installation',
          ),
          leading: IconButton(
            icon: Icon(
              context.isRtl ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
              size: 20,
            ),
            tooltip: _currentStepIndex == 1 ? 'Back to Selection' : 'Previous Page',
            onPressed: _handleBackNavigation,
          ),
        ),
        body: SafeArea(
          child: _currentStepIndex == 0
              ? _buildSetupSelectionView(targetLang)
              : _buildDownloadProgressView(),
        ),
      ),
    );
  }

  Widget _buildSetupSelectionView(String targetLang) {
    final colors = context.colors;
    final totalSizeMb = _calculateTotalDownloadSize();
    const freeSpaceMb = 28.4 * 1024;

    return ResponsiveForm(
      actions: [
        DiLangButton(
          label: 'Begin Download & Installation',
          icon: DiIcons.spark,
          onPressed: () {
            setState(() => _currentStepIndex = 1);
            _startSelectedDownloadPipeline(targetLang);
          },
        ),
        DiLangButton(
          label: 'Previous Page',
          icon: context.isRtl ? Icons.arrow_forward : Icons.arrow_back,
          variant: DiLangButtonVariant.secondary,
          onPressed: _handleBackNavigation,
        ),
        DiLangButton(
          label: 'Download Later in Settings',
          icon: DiIcons.settings,
          variant: DiLangButtonVariant.secondary,
          onPressed: () async {
            await DiLangNativeBridge.setOnboardingStep('Completed');
            widget.onComplete();
          },
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ToucanMascot(
            size: 85,
            mood: ToucanMood.happy,
            speechBubbleText:
                'Select on-device models for offline speech & dialogue!',
          ),
          const SizedBox(height: 20),

          // LLM Section
          Text('1. Conversation LLM Model',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          _buildRadioTile(
            id: 'qwen3-0.6b-instruct-q4_k_m',
            title: 'Qwen3 0.6B Instruct (GGUF Q4_K_M)',
            subtitle: 'Recommended • Fast & low RAM usage (~435 MB)',
            groupValue: _selectedLlm,
            onChanged: (v) => setState(() => _selectedLlm = v!),
          ),
          _buildRadioTile(
            id: 'gemma-3-1b-it-q4_k_m',
            title: 'Gemma 3 1B IT (GGUF Q4_K_M)',
            subtitle: 'High precision • Rich explanations (~1.04 GB)',
            groupValue: _selectedLlm,
            onChanged: (v) => setState(() => _selectedLlm = v!),
          ),
          _buildRadioTile(
            id: 'qwen2.5-1.5b-instruct-q4_k_m',
            title: 'Qwen2.5 1.5B Instruct (GGUF Q4_K_M)',
            subtitle: 'Pro • Complex grammar & syntax (~1.04 GB)',
            groupValue: _selectedLlm,
            onChanged: (v) => setState(() => _selectedLlm = v!),
          ),
          const SizedBox(height: 20),

          // STT Section
          Text('2. Speech-to-Text Model',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          _buildRadioTile(
            id: 'whisper-base',
            title: 'Whisper Base (GGML)',
            subtitle:
                'Recommended • Fast & balanced speech recognition (~148 MB)',
            groupValue: _selectedStt,
            onChanged: (v) => setState(() => _selectedStt = v!),
          ),
          const SizedBox(height: 20),

          // Storage Summary Card
          ResponsiveCard(
            accentColor: AppColors.turquoise500,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Estimated Download:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('${totalSizeMb.toStringAsFixed(1)} MB',
                        style: const TextStyle(
                            color: AppColors.turquoise500,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Free Space Available:',
                        style: TextStyle(color: colors.textSecondary)),
                    Text('${(freeSpaceMb / 1024).toStringAsFixed(1)} GB',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
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
      child: ResponsiveCard(
        accentColor: isSelected ? AppColors.turquoise500 : null,
        onTap: () => onChanged(id),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.turquoise500 : colors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isSelected
                              ? colors.primary
                              : colors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style:
                          TextStyle(fontSize: 12, color: colors.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadProgressView() {
    final colors = context.colors;
    final downloadState = ref.watch(modelDownloadProvider);
    final activeStage = downloadState.stage;

    // Check if verification finish should auto-hide focus banner
    if (!downloadState.isVerifying && _showFocusBanner) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _showFocusBanner) {
          setState(() => _showFocusBanner = false);
        }
      });
    }

    final pipelineList = [
      {'id': _selectedLlm, 'name': 'Conversation LLM', 'desc': 'On-device language reasoning engine'},
      {'id': _selectedStt, 'name': 'Whisper STT Engine', 'desc': 'On-device speech recognition'},
      {'id': 'piper-en_US-lessac-medium', 'name': 'Piper TTS Engine', 'desc': 'On-device text-to-speech synthesis'},
    ];

    final isDownloading = downloadState.isDownloading;
    final isVerifying = downloadState.isVerifying;

    return ResponsiveForm(
      actions: _isAllComplete
          ? [
              DiLangButton(
                label: 'Complete Setup & Launch',
                icon: DiIcons.check,
                onPressed: () async {
                  await DiLangNativeBridge.setOnboardingStep('Completed');
                  widget.onComplete();
                },
              ),
            ]
          : [
              DiLangButton(
                label: 'Back to Model Selection',
                icon: context.isRtl ? Icons.arrow_forward : Icons.arrow_back,
                variant: DiLangButtonVariant.secondary,
                onPressed: _handleBackNavigation,
              ),
            ],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Focus Awareness Banner (Requirement 4)
            FocusVerificationBanner(visible: _showFocusBanner),

            // Toucan Mascot Header
            Center(
              child: ToucanMascot(
                size: 85,
                mood: _isAllComplete ? ToucanMood.celebrating : ToucanMood.studying,
                speechBubbleText: _isAllComplete
                    ? 'All AI Engines Installed & Verified!'
                    : (isVerifying
                        ? 'Calculating SHA-256 Checksum...'
                        : 'Streaming AI Weights from HuggingFace...'),
              ),
            ),
            const SizedBox(height: 20),

            // Overall Pipeline Multi-step Overview Card (Requirements 1 & 3)
            ResponsiveCard(
              accentColor: _isAllComplete ? AppColors.turquoise500 : AppColors.amber500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PipelineStageStepper(
                    activeStage: _isAllComplete ? ModelPipelineStage.installed : activeStage,
                  ),
                  const SizedBox(height: 16),

                  // Overall Stage Status Message (Requirement 5)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      _isAllComplete
                          ? 'Ready to use ✓'
                          : (isVerifying
                              ? 'Calculating SHA-256 checksum...'
                              : (isDownloading
                                  ? 'Downloading model...'
                                  : 'Preparing pipeline...')),
                      key: ValueKey('${activeStage.name}_$_isAllComplete'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _isAllComplete ? AppColors.turquoise500 : colors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Detailed Progress Row (Requirements 2 & 6)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _isAllComplete
                              ? '3 / 3 AI Models Ready for Offline Use'
                              : (downloadState.speedEtaText.isNotEmpty
                                  ? downloadState.speedEtaText
                                  : downloadState.statusText),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: colors.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Text(
              'Model Pipeline Assets',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),

            // Individual Asset Cards with stage checkpoints & dual progress (Requirements 7, 8, 10, 12)
            ...pipelineList.map((item) {
              final modelId = item['id']!;
              final modelName = item['name']!;
              final modelDesc = item['desc']!;

              final modelState = downloadState.perModelProgress[modelId] ??
                  (_completedModelIds.contains(modelId)
                      ? ModelDownloadState(
                          stage: ModelPipelineStage.installed,
                          progress: 1.0,
                          verificationProgress: 1.0,
                          statusText: 'Ready to use',
                        )
                      : ModelDownloadState());

              final isCurrentActive = downloadState.downloadingModelId == modelId;
              final isDone = _completedModelIds.contains(modelId) || modelState.isInstalled;
              final isModelDl = isCurrentActive && downloadState.isDownloading;
              final isModelVf = isCurrentActive && downloadState.isVerifying;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: ResponsiveCard(
                  accentColor: isDone
                      ? AppColors.turquoise500
                      : (isCurrentActive ? AppColors.amber500 : null),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isDone
                                    ? DiIcons.check
                                    : (isCurrentActive ? DiIcons.spark : DiIcons.time),
                                color: isDone
                                    ? AppColors.turquoise500
                                    : (isCurrentActive ? AppColors.amber500 : colors.textSecondary),
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                modelName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: (isDone
                                      ? AppColors.turquoise500
                                      : (isCurrentActive ? AppColors.amber500 : Colors.grey))
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isDone
                                  ? 'Installed ✓'
                                  : (isModelVf
                                      ? 'Verifying...'
                                      : (isModelDl ? 'Downloading...' : 'Pending')),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isDone
                                    ? AppColors.turquoise500
                                    : (isCurrentActive ? AppColors.amber500 : colors.textSecondary),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        modelDesc,
                        style: TextStyle(fontSize: 12, color: colors.textSecondary),
                      ),
                      const SizedBox(height: 12),

                      // Stage Checkpoints Row (Requirement 7)
                      InstallationCheckpointsRow(
                        stage: isDone
                            ? ModelPipelineStage.installed
                            : (isCurrentActive ? modelState.stage : ModelPipelineStage.idle),
                      ),

                      // Dual Progress Indicator for active downloads/verification (Requirements 2, 8, 12)
                      if (isCurrentActive && (isModelDl || isModelVf)) ...[
                        const SizedBox(height: 14),
                        DualProgressIndicator(
                          downloadProgress: downloadState.progress,
                          verificationProgress: downloadState.verificationProgress,
                          isDownloading: isModelDl,
                          isVerifying: isModelVf,
                          downloadDetailText: downloadState.speedEtaText,
                          verificationDetailText: downloadState.shaProgressText,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),

            // Completion Banner Card (Requirement 11)
            if (_isAllComplete) ...[
              const SizedBox(height: 16),
              AnimatedContainer(
                duration: DesignTokens.durationNormal,
                curve: DesignTokens.defaultCurve,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromRGBO(0, 200, 150, 0.15),
                      Color.fromRGBO(0, 180, 220, 0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.turquoise500, width: 1.5),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: AppColors.turquoise500, size: 44),
                    const SizedBox(height: 10),
                    const Text(
                      '✓ All required AI assets installed.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.turquoise500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'DiLang is ready for offline practice.',
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
