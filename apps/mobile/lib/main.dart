import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'src/native_bridge.dart';

void main() {
  // Step 7: Configure Flutter Logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('[${record.level.name}] ${record.time}: ${record.message}');
  });

  runApp(
    const ProviderScope(
      child: DiLangApp(),
    ),
  );
}

class DiLangApp extends StatelessWidget {
  const DiLangApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DiLang Milestone 0',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFF10B981),
          surface: Color(0xFF1E293B),
        ),
      ),
      home: const BootstrapVerificationScreen(),
    );
  }
}

class BootstrapVerificationScreen extends StatefulWidget {
  const BootstrapVerificationScreen({super.key});

  @override
  State<BootstrapVerificationScreen> createState() => _BootstrapVerificationScreenState();
}

class _BootstrapVerificationScreenState extends State<BootstrapVerificationScreen> {
  String _pingStatus = 'Initializing...';
  String _dbStatus = 'Checking DB...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _runVerification();
  }

  Future<void> _runVerification() async {
    setState(() => _isLoading = true);

    final pingRes = await DiLangNativeBridge.ping();
    final dbRes = await DiLangNativeBridge.checkDbHealth();

    if (mounted) {
      setState(() {
        _pingStatus = pingRes;
        _dbStatus = dbRes;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DiLang — Milestone 0 Bootstrap'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.verified_user_rounded,
                size: 72,
                color: Color(0xFF6366F1),
              ),
              const SizedBox(height: 16),
              const Text(
                'Toolchain Stability Verified',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Milestone 0: Project Bootstrap & Dependencies Verification',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 32),
              _buildStatusCard(
                title: 'Rust Core FFI Status',
                value: _pingStatus,
                icon: Icons.electrical_services_rounded,
                accentColor: const Color(0xFF6366F1),
              ),
              const SizedBox(height: 16),
              _buildStatusCard(
                title: 'SQLite Database Health',
                value: _dbStatus,
                icon: Icons.storage_rounded,
                accentColor: const Color(0xFF10B981),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _runVerification,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.refresh_rounded),
                label: Text(
                  _isLoading ? 'Verifying...' : 'Re-verify Toolchain',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard({
    required String title,
    required String value,
    required IconData icon,
    required Color accentColor,
  }) {
    return Card(
      color: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: accentColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
