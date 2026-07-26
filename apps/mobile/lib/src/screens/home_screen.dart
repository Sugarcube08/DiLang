import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/app_runtime_provider.dart';
import '../providers/user_profile_provider.dart';
import '../providers/installed_models_provider.dart';
import '../theme/theme_extensions.dart';
import '../theme/design_tokens.dart';
import '../theme/di_icons.dart';
import '../theme/app_gradients.dart';
import '../components/dilang_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    final userState = ref.watch(userProfileProvider);
    final modelsState = ref.watch(installedModelsProvider);
    final runtimeState = ref.watch(appRuntimeProvider);

    final username = userState.activeUser?['username'] ?? 'Learner';
    final nativeLang = userState.activeUser?['native_language'] ?? 'English';
    final targetLang = userState.activeUser?['target_language'] ?? 'German';

    return Scaffold(
      appBar: AppBar(
        title: const Text('DiLang Learning Platform'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(DiIcons.settings),
            tooltip: 'Developer Options',
            onPressed: () {
              context.push('/developer-showcase');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.space24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header Card
            DiLangCard(
              isGlass: true,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      gradient: AppGradients.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(DiIcons.brain, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome, $username',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$nativeLang → $targetLang',
                          style: TextStyle(color: colors.primary, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Today's Learning Target Snapshot Card
            Text('Daily Learning Metrics', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DiLangCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Goal Target', style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text('0 / 20 min', style: TextStyle(fontWeight: FontWeight.bold, color: colors.primary, fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DiLangCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Due Reviews', style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text('0 Cards', style: TextStyle(fontWeight: FontWeight.bold, color: colors.secondary, fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Local AI Runtime Health Status
            Text('Local AI System Status', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            DiLangCard(
              child: Column(
                children: [
                  _buildStatusRow(
                    'SQLite Database Engine',
                    runtimeState.isDbHealthy ? 'Healthy' : 'Connecting...',
                    DiIcons.check,
                    colors.success,
                  ),
                  const Divider(height: 20),
                  _buildStatusRow(
                    'On-Device AI Models',
                    '${modelsState.models.length} Installed',
                    DiIcons.spark,
                    colors.primary,
                  ),
                  const Divider(height: 20),
                  _buildStatusRow(
                    'CPU Parallel Threads',
                    '${runtimeState.resourceBudget['max_cpu_threads'] ?? 4} Threads',
                    DiIcons.settings,
                    colors.secondary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // On-Device Model Manager Status
            Text('Installed Models', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            if (modelsState.models.isEmpty)
              const DiLangCard(child: Text('No models installed.'))
            else
              ...modelsState.models.map((m) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: DiLangCard(
                    child: ListTile(
                      leading: const Icon(DiIcons.spark, size: 24),
                      title: Text(m['name'] ?? 'Model'),
                      subtitle: Text('Version: ${m['version']} • Size: ${(m['size_bytes'] ?? 0) / 1024} KB'),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors.success.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Active',
                          style: TextStyle(color: colors.success, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            const SizedBox(height: 24),

            // Learning Modules
            Text('Learning Modules', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DiLangCard(
                    onTap: () {
                      context.push('/conversation');
                    },
                    child: Column(
                      children: [
                        Icon(DiIcons.mic, size: 32, color: colors.primary),
                        const SizedBox(height: 8),
                        const Text('Roleplay AI', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Active', style: TextStyle(color: colors.success, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DiLangCard(
                    child: Column(
                      children: [
                        Icon(DiIcons.learning, size: 32, color: colors.secondary),
                        const SizedBox(height: 8),
                        const Text('Vocabulary', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Phase 10', style: TextStyle(color: colors.textSecondary, fontSize: 12)),
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

  Widget _buildStatusRow(String label, String value, IconData icon, Color accent) {
    return Row(
      children: [
        Icon(icon, size: 20, color: accent),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: accent)),
      ],
    );
  }
}
