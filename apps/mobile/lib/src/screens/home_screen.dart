import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/user_profile_provider.dart';
import '../providers/installed_models_provider.dart';
import '../providers/model_download_provider.dart';
import '../native_bridge.dart';
import '../theme/theme_extensions.dart';
import '../theme/di_icons.dart';
import '../theme/app_colors.dart';
import '../components/glass_components.dart';
import '../components/toucan_mascot.dart';
import '../components/dilang_button.dart';
import '../components/responsive/responsive.dart';
import '../components/model_download_components.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedNavIndex = 0;
  int _vocabCount = 0;
  int _grammarCount = 0;
  int _conversationsCount = 0;
  int _reviewsCount = 0;
  bool _isLoadingAnalytics = true;

  @override
  void initState() {
    super.initState();
    _loadAnalyticsFromBackend();
  }

  Future<void> _loadAnalyticsFromBackend() async {
    try {
      final jsonStr = await DiLangNativeBridge.getAnalyticsSnapshot();
      if (jsonStr.isNotEmpty && !jsonStr.startsWith('Error')) {
        final map = jsonDecode(jsonStr) as Map<String, dynamic>;
        setState(() {
          _vocabCount = map['total_known_words'] ?? 0;
          _grammarCount = map['total_mastered_grammar'] ?? 0;
          _conversationsCount = map['total_conversations'] ?? 0;
          _reviewsCount = map['total_reviews_due'] ?? 0;
          _isLoadingAnalytics = false;
        });
        return;
      }
    } catch (_) {}
    setState(() {
      _isLoadingAnalytics = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final userState = ref.watch(userProfileProvider);
    final modelsState = ref.watch(installedModelsProvider);
    final downloadState = ref.watch(modelDownloadProvider);

    final activeUser = userState.activeUser;
    final username = activeUser?['username']?.toString() ?? 'Learner';
    final targetLang = activeUser?['target_language']?.toString() ?? 'German';

    final installedModels = modelsState.models;
    final isQwenInstalled = installedModels.any((m) {
      final s = '${m['id']} ${m['name']} ${m['filename']} ${m['path']}'.toLowerCase();
      return s.contains('qwen') || s.contains('gemma');
    });
    final isWhisperInstalled = installedModels.any((m) {
      final s = '${m['id']} ${m['name']} ${m['filename']} ${m['path']}'.toLowerCase();
      return s.contains('whisper') || s.contains('ggml-base');
    });
    final isPiperInstalled = installedModels.any((m) {
      final s = '${m['id']} ${m['name']} ${m['filename']} ${m['path']}'.toLowerCase();
      return s.contains('piper') || s.contains('lessac');
    });

    final hasUninstalledModels = !isQwenInstalled || !isWhisperInstalled || !isPiperInstalled;

    Widget mainContent = SingleChildScrollView(
      padding: context.responsivePadding,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: ResponsiveBreakpoints.maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Banner
              GlassContainer(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const ToucanMascot(
                      size: 72,
                      showGlow: true,
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Willkommen, $username! 👋',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Daily $targetLang learning session ready offline.',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              _buildBadgeChip('🔥 7 Streak', AppColors.coral500),
                              _buildBadgeChip('⚡ 250 XP', AppColors.amber500),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Live Background Download & Verification Card
              if (downloadState.isDownloading || downloadState.isVerifying) ...[
                ResponsiveCard(
                  accentColor: downloadState.isVerifying ? AppColors.amber500 : AppColors.turquoise500,
                  onTap: () => context.push('/settings'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                downloadState.isVerifying ? DiIcons.time : DiIcons.spark,
                                color: downloadState.isVerifying ? AppColors.amber500 : AppColors.turquoise500,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${downloadState.isVerifying ? 'Verifying' : 'Downloading'}: ${downloadState.downloadingModelName}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: (downloadState.isVerifying ? AppColors.amber500 : AppColors.turquoise500).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              downloadState.stageStepText.isNotEmpty ? downloadState.stageStepText : 'Step 1/4',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: downloadState.isVerifying ? AppColors.amber500 : AppColors.turquoise500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        downloadState.statusText,
                        style: TextStyle(color: colors.textSecondary, fontSize: 12),
                      ),
                      const SizedBox(height: 12),
                      DualProgressIndicator(
                        downloadProgress: downloadState.progress,
                        verificationProgress: downloadState.verificationProgress,
                        isDownloading: downloadState.isDownloading,
                        isVerifying: downloadState.isVerifying,
                        downloadDetailText: downloadState.speedEtaText,
                        verificationDetailText: downloadState.shaProgressText,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Interactive AI Voice Hero Card
              ResponsiveCard(
                accentColor: AppColors.turquoise500,
                onTap: () => context.push('/conversation'),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.turquoise500.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(DiIcons.mic, color: AppColors.turquoise500, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Interactive AI Voice Session',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Practice speaking $targetLang offline with local Qwen3 & Whisper',
                            style: TextStyle(fontSize: 12, color: colors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      context.isRtl ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.turquoise500,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Local AI Models Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Local AI Inference Models',
                      style: Theme.of(context).textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(DiIcons.settings, size: 16),
                    label: const Text('Model Center'),
                    onPressed: () => context.push('/settings'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              GlassCard(
                child: Column(
                  children: [
                    _buildModelRow('Qwen3-0.6B LLM', isQwenInstalled, colors),
                    const Divider(height: 16),
                    _buildModelRow('Whisper Speech-to-Text', isWhisperInstalled, colors),
                    const Divider(height: 16),
                    _buildModelRow('Piper Text-to-Speech', isPiperInstalled, colors),
                    if (hasUninstalledModels) ...[
                      const Divider(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: DiLangButton(
                          label: 'Download Missing Models in Settings',
                          icon: DiIcons.spark,
                          variant: DiLangButtonVariant.secondary,
                          onPressed: () => context.push('/settings'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Learning Analytics Section
              Text('Learning Analytics', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              if (_isLoadingAnalytics)
                const Center(child: CircularProgressIndicator())
              else
                GlassCard(
                  child: Column(
                    children: [
                      _buildMetricRow('Vocabulary Known', '$_vocabCount words', colors),
                      const Divider(height: 16),
                      _buildMetricRow('Grammar Concepts', '$_grammarCount mastered', colors),
                      const Divider(height: 16),
                      _buildMetricRow('Sessions Completed', '$_conversationsCount sessions', colors),
                      const Divider(height: 16),
                      _buildMetricRow('SRS Reviews Due', '$_reviewsCount cards', colors),
                    ],
                  ),
                ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );

    return ResponsiveScaffold(
      selectedIndex: _selectedNavIndex,
      onDestinationSelected: (idx) {
        setState(() => _selectedNavIndex = idx);
        if (idx == 1) context.push('/conversation');
        if (idx == 2) context.push('/settings');
      },
      destinations: const [
        ResponsiveNavigationDestination(icon: DiIcons.spark, label: 'Learn'),
        ResponsiveNavigationDestination(icon: DiIcons.mic, label: 'Speak'),
        ResponsiveNavigationDestination(icon: DiIcons.settings, label: 'Settings'),
      ],
      appBar: ResponsiveAppBar(
        title: const Text('DiLang'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(DiIcons.settings),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: mainContent,
    );
  }

  Widget _buildBadgeChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildModelRow(String name, bool isInstalled, dynamic colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isInstalled ? DiIcons.check : DiIcons.time,
              size: 16,
              color: isInstalled ? colors.success : colors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              isInstalled ? 'Installed' : 'Not Installed',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isInstalled ? colors.success : colors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricRow(String label, String value, dynamic colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: colors.textSecondary, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(color: AppColors.turquoise500, fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ],
    );
  }
}
