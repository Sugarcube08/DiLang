import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/user_profile_provider.dart';
import '../providers/installed_models_provider.dart';
import '../native_bridge.dart';
import '../theme/theme_extensions.dart';
import '../theme/design_tokens.dart';
import '../theme/di_icons.dart';
import '../components/dilang_card.dart';
import '../components/dilang_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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

    final userState = ref.watch(userProfileProvider);
    final modelsState = ref.watch(installedModelsProvider);

    final activeUser = userState.activeUser;
    final username = activeUser?['username']?.toString();
    final nativeLang = activeUser?['native_language']?.toString();
    final targetLang = activeUser?['target_language']?.toString();

    final hasProfile = activeUser != null && username != null && username.isNotEmpty;

    final installedModels = modelsState.models;
    final isGemmaInstalled = installedModels.any((m) => m['name'].toString().toLowerCase().contains('gemma'));
    final isWhisperInstalled = installedModels.any((m) => m['name'].toString().toLowerCase().contains('whisper'));
    final isPiperInstalled = installedModels.any((m) => m['name'].toString().toLowerCase().contains('piper'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('DiLang'),
        centerTitle: false,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(DiIcons.settings),
            tooltip: 'Options',
            onSelected: (val) {
              if (val == 'dev') {
                context.push('/developer-showcase');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'dev',
                child: Text('Developer Options'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.space24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Header
            Text(
              hasProfile ? username : 'No profile configured.',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
            ),
            const SizedBox(height: 16),

            // Native & Target Languages
            DiLangCard(
              child: Column(
                children: [
                  _buildLabelValueRow('Native Language', nativeLang ?? 'Unselected', colors),
                  const Divider(height: 20),
                  _buildLabelValueRow('Learning', targetLang ?? 'Unselected', colors),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // On-Device AI Models Status
            Text('Model Installation Status', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            DiLangCard(
              child: Column(
                children: [
                  _buildModelStatusRow('Gemma 3 1B', isGemmaInstalled, colors),
                  const Divider(height: 16),
                  _buildModelStatusRow('Whisper', isWhisperInstalled, colors),
                  const Divider(height: 16),
                  _buildModelStatusRow('Piper', isPiperInstalled, colors),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Learning Metrics Snapshot
            Text('Learning Metrics', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            if (_isLoadingAnalytics)
              const Center(child: CircularProgressIndicator())
            else
              DiLangCard(
                child: Column(
                  children: [
                    _buildMetricNumberRow('Vocabulary', _vocabCount, colors),
                    const Divider(height: 16),
                    _buildMetricNumberRow('Grammar', _grammarCount, colors),
                    const Divider(height: 16),
                    _buildMetricNumberRow('Conversations', _conversationsCount, colors),
                    const Divider(height: 16),
                    _buildMetricNumberRow('Reviews Due', _reviewsCount, colors),
                  ],
                ),
              ),
            const SizedBox(height: 32),

            // Start Conversation Primary Action
            SizedBox(
              width: double.infinity,
              child: DiLangButton(
                label: 'Start Conversation',
                icon: DiIcons.mic,
                onPressed: () {
                  context.push('/conversation');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelValueRow(String label, String value, dynamic colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: colors.textSecondary, fontSize: 14)),
        Text(value, style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
      ],
    );
  }

  Widget _buildModelStatusRow(String modelName, bool isInstalled, dynamic colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(modelName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Row(
          children: [
            Icon(
              isInstalled ? DiIcons.check : DiIcons.time,
              size: 16,
              color: isInstalled ? colors.success : colors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              isInstalled ? '✓ Installed' : 'Not Installed',
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

  Widget _buildMetricNumberRow(String label, int count, dynamic colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: colors.textSecondary, fontSize: 14)),
        Text('$count', style: TextStyle(color: colors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}
