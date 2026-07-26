import 'dart:convert';
import 'package:flutter/material.dart';
import '../native_bridge.dart';
import '../theme/theme_extensions.dart';
import '../theme/design_tokens.dart';
import '../theme/di_icons.dart';
import '../theme/app_gradients.dart';
import '../components/dilang_card.dart';
import 'conversation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? _user;
  List<dynamic> _models = [];
  String _dbStatus = 'Checking DB...';
  String _analyticsSummary = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRuntimeData();
  }

  void _loadRuntimeData() {
    final userJson = DiLangNativeBridge.getActiveUser();
    Map<String, dynamic>? userData;
    if (userJson.isNotEmpty && !userJson.startsWith('Error')) {
      try {
        userData = jsonDecode(userJson);
      } catch (_) {}
    }

    final modelsJson = DiLangNativeBridge.listInstalledModels();
    List<dynamic> modelsList = [];
    if (modelsJson.isNotEmpty && !modelsJson.startsWith('Error')) {
      try {
        modelsList = jsonDecode(modelsJson);
      } catch (_) {}
    }

    final dbHealth = DiLangNativeBridge.checkDbHealth();
    final analytics = DiLangNativeBridge.getAnalyticsSnapshot();

    setState(() {
      _user = userData;
      _models = modelsList;
      _dbStatus = dbHealth;
      _analyticsSummary = analytics;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final username = _user?['username'] ?? 'Learner';
    final nativeLang = _user?['native_language'] ?? 'English';
    final targetLang = _user?['target_language'] ?? 'German';

    return Scaffold(
      appBar: AppBar(
        title: const Text('DiLang Learning Platform'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(DiIcons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(DesignTokens.space24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header Banner
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

                  // Local AI Runtime Health Card
                  Text('Local AI Runtime Health', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  DiLangCard(
                    child: Column(
                      children: [
                        _buildStatusRow('Database Engine', _dbStatus, DiIcons.check),
                        const Divider(height: 20),
                        _buildStatusRow('Installed Models', '${_models.length} Operational', DiIcons.spark),
                        const Divider(height: 20),
                        _buildStatusRow('Analytics Engine', _analyticsSummary, DiIcons.analytics),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Installed Models List
                  Text('Installed On-Device Models', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  if (_models.isEmpty)
                    const DiLangCard(child: Text('No models installed yet.'))
                  else
                    ..._models.map((m) {
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

                  // Quick Action Cards
                  Text('Learning Modules', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DiLangCard(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const ConversationScreen(
                                  scenarioId: 'cafe_order',
                                  scenarioTitle: 'Ordering Coffee in Berlin',
                                ),
                              ),
                            );
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

  Widget _buildStatusRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }
}
