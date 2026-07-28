import 'package:flutter/material.dart';
import '../providers/model_download_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import '../theme/design_tokens.dart';
import '../theme/di_icons.dart';
import '../theme/theme_extensions.dart';
import 'dilang_progress.dart';

/// 1. Pipeline Stage Stepper (Visual 4-step pipeline overview)
class PipelineStageStepper extends StatelessWidget {
  final ModelPipelineStage activeStage;
  final String? customStepText;

  const PipelineStageStepper({
    super.key,
    required this.activeStage,
    this.customStepText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.turquoise400 : AppColors.turquoise600;

    final steps = [
      {'title': 'Downloading', 'stage': ModelPipelineStage.downloading, 'stepNum': 1},
      {'title': 'Verification', 'stage': ModelPipelineStage.verifying, 'stepNum': 2},
      {'title': 'Installing', 'stage': ModelPipelineStage.installing, 'stepNum': 3},
      {'title': 'Completed', 'stage': ModelPipelineStage.installed, 'stepNum': 4},
    ];

    int activeIndex = 0;
    if (activeStage == ModelPipelineStage.downloading || activeStage == ModelPipelineStage.downloaded) {
      activeIndex = 0;
    } else if (activeStage == ModelPipelineStage.verifying) {
      activeIndex = 1;
    } else if (activeStage == ModelPipelineStage.installing) {
      activeIndex = 2;
    } else if (activeStage == ModelPipelineStage.installed) {
      activeIndex = 3;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              customStepText ?? 'Step ${activeIndex + 1}/4',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            Text(
              _getStageTitle(activeStage),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: steps.map((s) {
            final idx = (s['stepNum'] as int) - 1;
            final isCompleted = idx < activeIndex || activeStage == ModelPipelineStage.installed;
            final isActive = idx == activeIndex && activeStage != ModelPipelineStage.installed;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: DesignTokens.durationNormal,
                      curve: DesignTokens.defaultCurve,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppColors.turquoise500
                            : isActive
                                ? AppColors.amber500
                                : (isDark
                                    ? const Color.fromRGBO(255, 255, 255, 0.12)
                                    : const Color.fromRGBO(0, 0, 0, 0.08)),
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: AppColors.amber500.withValues(alpha: 0.4),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                )
                              ]
                            : null,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      s['title'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isActive || isCompleted ? FontWeight.bold : FontWeight.normal,
                        color: isCompleted
                            ? primaryColor
                            : isActive
                                ? AppColors.amber500
                                : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _getStageTitle(ModelPipelineStage stage) {
    switch (stage) {
      case ModelPipelineStage.downloading:
        return 'Downloading model...';
      case ModelPipelineStage.downloaded:
        return 'Download complete ✓';
      case ModelPipelineStage.verifying:
        return 'Calculating SHA-256 checksum...';
      case ModelPipelineStage.installing:
        return 'Registering model...';
      case ModelPipelineStage.installed:
        return 'Ready to use ✓';
      case ModelPipelineStage.failed:
        return 'Installation failed';
      default:
        return 'Idle';
    }
  }
}

/// 2. Focus Verification Banner (Informational banner when app loses focus during SHA hashing)
class FocusVerificationBanner extends StatelessWidget {
  final bool visible;

  const FocusVerificationBanner({super.key, required this.visible});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: DesignTokens.durationNormal,
      switchInCurve: DesignTokens.defaultCurve,
      switchOutCurve: DesignTokens.defaultCurve,
      transitionBuilder: (child, animation) => SizeTransition(
        sizeFactor: animation,
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: visible
          ? Container(
              key: const ValueKey('focus_banner_visible'),
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.amber500.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.amber500, width: 1.5),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber_rounded, color: AppColors.amber500, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Integrity verification is still running.',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.amber500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'For the fastest installation, keep DiLang open and on screen until verification completes. Background execution may be slower on some Android devices.',
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(key: ValueKey('focus_banner_hidden')),
    );
  }
}

/// 3. Dual Progress Indicator (Separate progress bars for Download and Verification)
class DualProgressIndicator extends StatelessWidget {
  final double downloadProgress; // 0.0 - 1.0
  final double verificationProgress; // 0.0 - 1.0
  final bool isDownloading;
  final bool isVerifying;
  final String downloadDetailText;
  final String verificationDetailText;

  const DualProgressIndicator({
    super.key,
    required this.downloadProgress,
    required this.verificationProgress,
    required this.isDownloading,
    required this.isVerifying,
    required this.downloadDetailText,
    required this.verificationDetailText,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final dlPercent = (downloadProgress * 100).clamp(0, 100).toInt();
    final vfPercent = (verificationProgress * 100).clamp(0, 100).toInt();

    final isDownloadDone = downloadProgress >= 1.0;
    final isVerifyDone = verificationProgress >= 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Download Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Download',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDownloading
                        ? AppColors.turquoise500
                        : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                  ),
                ),
                if (isDownloadDone) ...[
                  const SizedBox(width: 6),
                  const Icon(Icons.check_circle, size: 14, color: AppColors.turquoise500),
                  const SizedBox(width: 4),
                  const Text(
                    'Downloaded ✓',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.turquoise500),
                  ),
                ],
              ],
            ),
            AnimatedProgressText(text: '$dlPercent%'),
          ],
        ),
        const SizedBox(height: 6),
        DiLangGradientProgress(
          progress: downloadProgress,
          height: 7.0,
        ),
        if (downloadDetailText.isNotEmpty && isDownloading) ...[
          const SizedBox(height: 4),
          Text(
            downloadDetailText,
            style: TextStyle(fontSize: 11, color: colors.textSecondary),
          ),
        ],

        const SizedBox(height: 14),

        // Verification Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Verification (SHA-256)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isVerifying
                        ? AppColors.amber500
                        : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                  ),
                ),
                if (isVerifyDone) ...[
                  const SizedBox(width: 6),
                  const Icon(Icons.check_circle, size: 14, color: AppColors.turquoise500),
                  const SizedBox(width: 4),
                  const Text(
                    'Verified ✓',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.turquoise500),
                  ),
                ],
              ],
            ),
            AnimatedProgressText(text: '$vfPercent%'),
          ],
        ),
        const SizedBox(height: 6),
        DiLangGradientProgress(
          progress: verificationProgress,
          height: 7.0,
          gradient: isVerifying
              ? const LinearGradient(colors: [AppColors.amber500, AppColors.coral500])
              : AppGradients.primary,
        ),
        if (verificationDetailText.isNotEmpty && isVerifying) ...[
          const SizedBox(height: 4),
          const Text(
            'Calculating SHA-256 checksum...',
            style: TextStyle(fontSize: 11, color: AppColors.amber500, fontWeight: FontWeight.w600),
          ),
        ],
      ],
    );
  }
}

/// 4. Animated Progress Text (Smooth fade/slide transition for numbers)
class AnimatedProgressText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const AnimatedProgressText({
    super.key,
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final defaultStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: colors.primary,
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
      child: Text(
        text,
        key: ValueKey(text),
        style: style ?? defaultStyle,
      ),
    );
  }
}

/// 5. Installation Summary Checkpoints Widget
class InstallationCheckpointsRow extends StatelessWidget {
  final ModelPipelineStage stage;

  const InstallationCheckpointsRow({super.key, required this.stage});

  @override
  Widget build(BuildContext context) {
    final isDownloaded = stage.index >= ModelPipelineStage.downloaded.index && stage != ModelPipelineStage.failed;
    final isVerified = stage.index >= ModelPipelineStage.installing.index && stage != ModelPipelineStage.failed;
    final isInstalled = stage == ModelPipelineStage.installed;

    return Row(
      children: [
        _buildCheckpointChip('Downloaded', isDownloaded),
        const SizedBox(width: 8),
        _buildCheckpointChip('Verified', isVerified),
        const SizedBox(width: 8),
        _buildCheckpointChip('Installed', isInstalled),
      ],
    );
  }

  Widget _buildCheckpointChip(String label, bool isDone) {
    return AnimatedContainer(
      duration: DesignTokens.durationNormal,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isDone
            ? AppColors.turquoise500.withValues(alpha: 0.12)
            : const Color.fromRGBO(128, 128, 128, 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDone ? AppColors.turquoise500 : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isDone ? DiIcons.check : Icons.circle_outlined,
            size: 12,
            color: isDone ? AppColors.turquoise500 : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
              color: isDone ? AppColors.turquoise500 : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
