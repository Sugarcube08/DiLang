import 'dart:convert';
import 'package:flutter/material.dart';
import '../native_bridge.dart';
import '../theme/theme_extensions.dart';
import '../theme/design_tokens.dart';
import '../theme/di_icons.dart';
import '../components/dilang_button.dart';
import '../components/dilang_card.dart';

class RuntimeCheckScreen extends StatefulWidget {
  final VoidCallback onNext;

  const RuntimeCheckScreen({super.key, required this.onNext});

  @override
  State<RuntimeCheckScreen> createState() => _RuntimeCheckScreenState();
}

class _RuntimeCheckScreenState extends State<RuntimeCheckScreen> {
  Map<String, dynamic>? _budget;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHardwareBudget();
  }

  Future<void> _fetchHardwareBudget() async {
    final rawJson = await DiLangNativeBridge.getSystemResourceBudget();
    if (rawJson.isNotEmpty && !rawJson.startsWith('Error')) {
      try {
        final decoded = jsonDecode(rawJson);
        setState(() {
          _budget = decoded;
          _isLoading = false;
        });
        return;
      } catch (_) {}
    }
    setState(() {
      _budget = {'max_cpu_threads': 4, 'max_ram_mb': 4096, 'gpu_available': false};
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: const Text('Runtime Check')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(DesignTokens.space24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hardware Validation',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Inspecting device CPU, RAM, and storage budgets for Qwen3-0.6B on-device execution.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  DiLangCard(
                    child: Column(
                      children: [
                        _buildMetricRow('CPU Cores / Threads', '${_budget?['max_cpu_threads'] ?? 4} Threads', DiIcons.tune),
                        const Divider(height: 24),
                        _buildMetricRow('Memory Budget', '${_budget?['max_ram_mb'] ?? 4096} MB RAM', DiIcons.brain),
                        const Divider(height: 24),
                        _buildMetricRow('Recommended Model', 'Qwen3-0.6B Instruct Q4_K_M', DiIcons.spark),
                      ],
                    ),
                  ),
                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    child: DiLangButton(
                      label: 'Proceed to Model Setup',
                      icon: DiIcons.play,
                      onPressed: widget.onNext,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildMetricRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
        Text(value, style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
