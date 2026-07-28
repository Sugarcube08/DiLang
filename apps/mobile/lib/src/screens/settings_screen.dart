import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/installed_models_provider.dart';
import '../providers/model_download_provider.dart';
import '../providers/user_profile_provider.dart';
import '../theme/theme_extensions.dart';
import '../theme/di_icons.dart';
import '../theme/app_colors.dart';
import '../components/dilang_button.dart';
import '../components/dilang_progress.dart';
import '../components/toucan_circular_logo.dart';
import '../components/responsive/responsive.dart';
import '../components/model_download_components.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // Model category tab selection
  String _selectedCategory = 'all'; // 'all', 'llm', 'stt', 'tts'

  // Model catalog
  final List<Map<String, dynamic>> _registryModels = const [
    {
      'id': 'qwen3-0.6b-instruct-q4_k_m',
      'name': 'Qwen3 0.6B Instruct',
      'category': 'llm',
      'subtitle': 'Fast on-device LLM for natural dialogue & grammar analysis (~435 MB)',
      'size': '~435 MB',
      'tag': 'Recommended',
    },
    {
      'id': 'gemma-3-1b-it-q4_k_m',
      'name': 'Gemma 3 1B IT',
      'category': 'llm',
      'subtitle': 'High-capacity instruction LLM for advanced explanations (~1.04 GB)',
      'size': '~1.04 GB',
      'tag': 'High Quality',
    },
    {
      'id': 'qwen2.5-1.5b-instruct-q4_k_m',
      'name': 'Qwen2.5 1.5B Instruct',
      'category': 'llm',
      'subtitle': 'Deep multilingual LLM for complex language scenarios (~1.04 GB)',
      'size': '~1.04 GB',
      'tag': 'Pro',
    },
    {
      'id': 'whisper-base',
      'name': 'Whisper Base (GGML)',
      'category': 'stt',
      'subtitle': 'On-device Speech-to-Text for voice input & pronunciation (~148 MB)',
      'size': '~148 MB',
      'tag': 'Default STT',
    },
    {
      'id': 'piper-en_US-lessac-medium',
      'name': 'Piper Voice (ONNX)',
      'category': 'tts',
      'subtitle': 'On-device Text-to-Speech for audio synthesis (~63 MB)',
      'size': '~63 MB',
      'tag': 'Default TTS',
    },
  ];

  Future<void> _startModelDownload(String modelId, String titleName) async {
    final success = await ref.read(modelDownloadProvider.notifier).startDownload(modelId, titleName);
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$titleName installed and verified successfully!')),
      );
    } else {
      final err = ref.read(modelDownloadProvider).error ?? 'Unknown error';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed for $titleName: $err')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final userState = ref.watch(userProfileProvider);
    final modelsState = ref.watch(installedModelsProvider);
    final downloadState = ref.watch(modelDownloadProvider);

    final downloadingModelId = downloadState.downloadingModelId;
    final downloadStatusText = downloadState.statusText;
    final downloadSpeedEta = downloadState.speedEtaText;
    final downloadProgress = downloadState.progress;

    final activeUser = userState.activeUser;
    final username = activeUser?['username']?.toString() ?? 'Learner';
    final nativeLang = activeUser?['native_language']?.toString() ?? 'English';
    final targetLang = activeUser?['target_language']?.toString() ?? 'German';

    final installedModels = modelsState.models;

    // Filter models by selected category
    final filteredModels = _registryModels.where((m) {
      if (_selectedCategory == 'all') return true;
      return m['category'] == _selectedCategory;
    }).toList();

    Widget mainContent = SingleChildScrollView(
      padding: context.responsivePadding,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: ResponsiveBreakpoints.maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Summary
              Text('Learner Profile', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              ResponsiveCard(
                child: Row(
                  children: [
                    const ToucanCircularLogo(size: 52),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 2),
                          Text('$nativeLang ➔ $targetLang', style: TextStyle(color: colors.textSecondary, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Model Download Center Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Model Download Center', style: Theme.of(context).textTheme.titleLarge),
                  IconButton(
                    icon: const Icon(DiIcons.refresh),
                    tooltip: 'Refresh Installed Models',
                    onPressed: () {
                      ref.read(installedModelsProvider.notifier).refresh();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Select and download local AI models to customize your offline speech & text pipeline.',
                style: TextStyle(color: colors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 16),

              // Category Filter Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip('all', 'All Models (${_registryModels.length})'),
                    const SizedBox(width: 8),
                    _buildCategoryChip('llm', 'LLM Dialogue'),
                    const SizedBox(width: 8),
                    _buildCategoryChip('stt', 'Speech-to-Text'),
                    const SizedBox(width: 8),
                    _buildCategoryChip('tts', 'Text-to-Speech'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Active Download Progress Widget
              if (downloadState.isDownloading || downloadingModelId != null) ...[
                ResponsiveCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(downloadStatusText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 4),
                      if (downloadSpeedEta.isNotEmpty)
                        Text(downloadSpeedEta, style: TextStyle(color: colors.primary, fontSize: 12)),
                      const SizedBox(height: 12),
                      DiLangGradientProgress(progress: downloadProgress),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Filtered Model Cards List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredModels.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final model = filteredModels[index];
                  final modelId = model['id'] as String;

                  final isInstalled = installedModels.any((m) {
                    final s = '${m['id']} ${m['name']} ${m['filename']} ${m['path']}'.toLowerCase();
                    return s.contains(modelId.toLowerCase()) || (m['id']?.toString() == modelId);
                  });

                  return _buildModelItemCard(
                    title: model['name'] as String,
                    subtitle: model['subtitle'] as String,
                    modelId: modelId,
                    sizeText: model['size'] as String,
                    tagText: model['tag'] as String,
                    isInstalled: isInstalled,
                    colors: colors,
                  );
                },
              ),
              const SizedBox(height: 32),

              // Advanced Diagnostics & Showcase Links
              Text('Advanced Diagnostics & Tools', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              ResponsiveCard(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(DiIcons.tune, color: colors.primary),
                      title: const Text('Runtime Diagnostics'),
                      subtitle: const Text('Inspect RAM, CPU, SQLite path & active loaders'),
                      trailing: Icon(
                        context.isRtl ? Icons.chevron_left : Icons.chevron_right,
                      ),
                      onTap: () => context.push('/diagnostics'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(DiIcons.spark, color: colors.primary),
                      title: const Text('Developer Showcase'),
                      subtitle: const Text('Design system tokens & component showcase'),
                      trailing: Icon(
                        context.isRtl ? Icons.chevron_left : Icons.chevron_right,
                      ),
                      onTap: () => context.push('/developer-showcase'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );

    return ResponsiveScaffold(
      selectedIndex: 2,
      onDestinationSelected: (idx) {
        if (idx == 0) context.go('/home');
        if (idx == 1) context.push('/conversation');
      },
      destinations: const [
        ResponsiveNavigationDestination(icon: DiIcons.spark, label: 'Learn'),
        ResponsiveNavigationDestination(icon: DiIcons.mic, label: 'Speak'),
        ResponsiveNavigationDestination(icon: DiIcons.settings, label: 'Settings'),
      ],
      appBar: ResponsiveAppBar(
        title: const Text('Settings & Model Center'),
      ),
      body: mainContent,
    );
  }

  Widget _buildCategoryChip(String categoryKey, String label) {
    final isSelected = _selectedCategory == categoryKey;

    return FilterChip(
      selected: isSelected,
      label: Text(label),
      selectedColor: AppColors.turquoise500.withValues(alpha: 0.2),
      checkmarkColor: AppColors.turquoise500,
      labelStyle: TextStyle(
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? AppColors.turquoise500 : null,
      ),
      onSelected: (_) {
        setState(() {
          _selectedCategory = categoryKey;
        });
      },
    );
  }

  Widget _buildModelItemCard({
    required String title,
    required String subtitle,
    required String modelId,
    required String sizeText,
    required String tagText,
    required bool isInstalled,
    required dynamic colors,
  }) {
    final downloadState = ref.watch(modelDownloadProvider);
    final isCurrentActive = downloadState.downloadingModelId == modelId;
    final isDownloading = isCurrentActive && downloadState.isDownloading;
    final isVerifying = isCurrentActive && downloadState.isVerifying;
    final activeStage = isInstalled
        ? ModelPipelineStage.installed
        : (isCurrentActive ? downloadState.stage : ModelPipelineStage.idle);

    return ResponsiveCard(
      accentColor: isInstalled
          ? colors.success
          : (isCurrentActive ? AppColors.amber500 : null),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isInstalled
                    ? DiIcons.check
                    : (isCurrentActive ? DiIcons.spark : DiIcons.time),
                color: isInstalled
                    ? colors.success
                    : (isCurrentActive ? AppColors.amber500 : colors.warning),
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
                  color: (isInstalled
                          ? colors.success
                          : (isVerifying
                              ? AppColors.amber500
                              : (isDownloading ? AppColors.turquoise500 : colors.warning)))
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isInstalled
                      ? 'Installed ✓'
                      : (isVerifying
                          ? 'Verifying Integrity'
                          : (isDownloading ? 'Downloading...' : 'Not Installed')),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isInstalled
                        ? colors.success
                        : (isVerifying
                            ? AppColors.amber500
                            : (isDownloading ? AppColors.turquoise500 : colors.warning)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(subtitle, style: TextStyle(color: colors.textSecondary, fontSize: 13)),
          const SizedBox(height: 10),

          // Multi-Stage Checkpoints Row (Requirement 7)
          InstallationCheckpointsRow(stage: activeStage),

          if (isCurrentActive && (isDownloading || isVerifying)) ...[
            const SizedBox(height: 14),
            DualProgressIndicator(
              downloadProgress: downloadState.progress,
              verificationProgress: downloadState.verificationProgress,
              isDownloading: isDownloading,
              isVerifying: isVerifying,
              downloadDetailText: downloadState.speedEtaText,
              verificationDetailText: downloadState.shaProgressText,
            ),
          ],

          const SizedBox(height: 12),
          context.isCompact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '$sizeText • $tagText',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colors.textSecondary),
                    ),
                    if (!isInstalled) ...[
                      const SizedBox(height: 10),
                      DiLangButton(
                        label: isVerifying
                            ? 'Verifying SHA-256...'
                            : (isDownloading ? 'Downloading...' : 'Download Model'),
                        icon: isVerifying ? DiIcons.time : DiIcons.spark,
                        variant: DiLangButtonVariant.secondary,
                        isFullWidth: true,
                        onPressed: (isDownloading || isVerifying)
                            ? null
                            : () => _startModelDownload(modelId, title),
                      ),
                    ],
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '$sizeText • $tagText',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colors.textSecondary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (!isInstalled)
                      DiLangButton(
                        label: isVerifying
                            ? 'Verifying SHA-256...'
                            : (isDownloading ? 'Downloading...' : 'Download Model'),
                        icon: isVerifying ? DiIcons.time : DiIcons.spark,
                        variant: DiLangButtonVariant.secondary,
                        onPressed: (isDownloading || isVerifying)
                            ? null
                            : () => _startModelDownload(modelId, title),
                      ),
                  ],
                ),
        ],
      ),
    );
  }
}
