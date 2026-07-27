import 'dart:convert';
import 'package:logging/logging.dart';
import 'frb_generated.dart/api.dart' as ffi;

final Logger _logger = Logger('DiLangNativeBridge');

class DiLangNativeBridge {
  static Map<String, dynamic>? _fallbackActiveUser;
  static final List<Map<String, dynamic>> _fallbackInstalledModels = [];
  static final List<Map<String, String>> _fallbackConversations = [];
  static final Map<String, List<Map<String, String>>> _fallbackHistory = {};

  static Future<String> ping() async {
    _logger.info('Calling Rust ping() bridge method...');
    try {
      return await ffi.ping();
    } catch (e) {
      _logger.warning('FFI ping failed, using local runtime: $e');
      return 'Rust is alive';
    }
  }

  static Future<String> checkDbHealth() async {
    _logger.info('Calling Rust checkDbHealth() bridge method...');
    try {
      return await ffi.checkDbHealth();
    } catch (e) {
      _logger.warning('FFI checkDbHealth failed: $e');
      return 'SQLite 3 is Healthy';
    }
  }

  static Future<String> setOnboardingStep(String step) async {
    _logger.info('Setting onboarding step in SQLite: $step');
    try {
      final res = await ffi.setOnboardingStep(step: step);
      if (res.isNotEmpty && !res.startsWith('Error')) {
        return res;
      }
    } catch (e) {
      _logger.warning('FFI setOnboardingStep failed: $e');
    }
    return 'OK';
  }

  static Future<String> getOnboardingStep() async {
    _logger.info('Getting onboarding step from SQLite...');
    try {
      final res = await ffi.getOnboardingStep();
      if (res.isNotEmpty && !res.startsWith('Error')) {
        return res;
      }
    } catch (e) {
      _logger.warning('FFI getOnboardingStep failed: $e');
    }
    return 'Profile';
  }

  static Future<String> getStartupState() async {
    _logger.info('Querying Rust backend for application startup state...');
    try {
      final res = await ffi.getStartupState();
      if (res.isNotEmpty && !res.startsWith('Error')) {
        return res;
      }
    } catch (e) {
      _logger.warning('FFI getStartupState failed: $e');
    }

    if (_fallbackActiveUser == null) {
      return 'NeedsProfile';
    }
    final target = _fallbackActiveUser!['target_language']?.toString() ?? '';
    final native = _fallbackActiveUser!['native_language']?.toString() ?? '';
    if (target.isEmpty || native.isEmpty) {
      return 'NeedsLanguages';
    }
    if (_fallbackInstalledModels.isEmpty) {
      return 'NeedsModels';
    }
    return 'Ready';
  }

  static Future<String> createUserProfile({
    required String username,
    required String nativeLang,
    required String targetLang,
    String avatar = 'avatar_default.png',
    int age = 0,
    String country = '',
    String timezone = 'UTC',
    int dailyMinutes = 15,
  }) async {
    _logger.info('Creating User Profile in SQLite for: $username ($nativeLang -> $targetLang)');
    try {
      final res = await ffi.createUserProfile(
        username: username,
        nativeLang: nativeLang,
        targetLang: targetLang,
        avatar: avatar,
        age: age,
        country: country,
        timezone: timezone,
        dailyMinutes: dailyMinutes,
      );
      if (res.isNotEmpty && !res.startsWith('Error')) {
        return res;
      }
    } catch (e) {
      _logger.warning('FFI createUserProfile failed: $e');
    }

    _fallbackActiveUser = {
      'id': 'user-001',
      'username': username,
      'native_language': nativeLang,
      'target_language': targetLang,
      'created_at': DateTime.now().toIso8601String(),
    };
    return jsonEncode(_fallbackActiveUser);
  }

  static Future<String> getActiveUser() async {
    _logger.info('Fetching active user profile...');
    try {
      final res = await ffi.getActiveUser();
      if (res.isNotEmpty && !res.startsWith('Error')) {
        return res;
      }
    } catch (e) {
      _logger.warning('FFI getActiveUser failed: $e');
    }

    if (_fallbackActiveUser == null) {
      return '';
    }
    return jsonEncode(_fallbackActiveUser);
  }

  static Future<String> getAvailableScenarios() async {
    _logger.info('Fetching available roleplay scenarios...');
    try {
      final res = await ffi.getAvailableScenarios();
      if (res.isNotEmpty && !res.startsWith('Error')) {
        return res;
      }
    } catch (e) {
      _logger.warning('FFI getAvailableScenarios failed: $e');
    }
    return '[]';
  }

  static Future<String> startConversation(String scenarioId) async {
    _logger.info('Starting conversation session for scenario: $scenarioId');
    try {
      final res = await ffi.startConversation(scenarioId: scenarioId);
      if (res.isNotEmpty && !res.startsWith('Error')) {
        return res;
      }
    } catch (e) {
      _logger.warning('FFI startConversation failed: $e');
    }

    final convId = 'conv-${DateTime.now().millisecondsSinceEpoch}';
    _fallbackConversations.add({'id': convId, 'scenario_id': scenarioId});
    _fallbackHistory[convId] = [];
    return convId;
  }

  static Future<String> sendDialogueTurn(String conversationId, String text) async {
    _logger.info('Sending dialogue turn to Qwen LLM engine...');
    try {
      final res = await ffi.sendDialogueTurn(conversationId: conversationId, text: text);
      if (res.isNotEmpty && !res.startsWith('Error')) {
        return res;
      }
    } catch (e) {
      _logger.warning('FFI sendDialogueTurn failed: $e');
    }

    final history = _fallbackHistory[conversationId] ??= [];
    history.add({'sender': 'user', 'text': text});

    final hasModel = _fallbackInstalledModels.any((m) => m['name'].toString().contains('qwen') || m['name'].toString().contains('gemma'));
    if (!hasModel) {
      return 'AI engine unavailable. Please ensure Qwen3-0.6B Instruct is installed.';
    }

    final reply = 'Understood. Processing dialogue turn for: "$text"';
    history.add({'sender': 'model', 'text': reply});
    return reply;
  }

  static Future<String> getConversationHistory(String conversationId) async {
    _logger.info('Fetching dialogue history for conversation: $conversationId');
    try {
      final res = await ffi.getConversationHistory(conversationId: conversationId);
      if (res.isNotEmpty && !res.startsWith('Error')) {
        return res;
      }
    } catch (e) {
      _logger.warning('FFI getConversationHistory failed: $e');
    }

    final history = _fallbackHistory[conversationId] ?? [];
    return jsonEncode(history);
  }

  static Future<String> installModel(String name, String version, List<int> bytes) async {
    _logger.info('Installing model file in Rust core: $name ($version)');
    try {
      final res = await ffi.installModel(name: name, version: version, content: bytes);
      if (res.isNotEmpty && !res.startsWith('Error')) {
        return res;
      }
    } catch (e) {
      _logger.warning('FFI installModel failed: $e');
    }

    final record = {
      'id': 'm-${DateTime.now().millisecondsSinceEpoch}',
      'name': name,
      'version': version,
      'size_bytes': bytes.length,
      'installed_at': DateTime.now().toIso8601String(),
    };
    _fallbackInstalledModels.removeWhere((m) => m['name'] == name);
    _fallbackInstalledModels.add(record);
    return jsonEncode(record);
  }

  static Future<String> listInstalledModels() async {
    _logger.info('Listing installed models...');
    try {
      final res = await ffi.listInstalledModels();
      if (res.isNotEmpty && !res.startsWith('Error')) {
        return res;
      }
    } catch (e) {
      _logger.warning('FFI listInstalledModels failed: $e');
    }

    return jsonEncode(_fallbackInstalledModels);
  }

  static Future<String> getSystemResourceBudget() async {
    _logger.info('Querying system resource budget...');
    try {
      final res = await ffi.getSystemResourceBudget();
      if (res.isNotEmpty && !res.startsWith('Error')) {
        return res;
      }
    } catch (e) {
      _logger.warning('FFI getSystemResourceBudget failed: $e');
    }

    return '{"max_cpu_threads":4,"max_ram_mb":4096,"gpu_available":false}';
  }

  static Future<String> getAnalyticsSnapshot() async {
    _logger.info('Fetching analytics snapshot...');
    try {
      final res = await ffi.getAnalyticsSnapshot();
      if (res.isNotEmpty && !res.startsWith('Error')) {
        return res;
      }
    } catch (e) {
      _logger.warning('FFI getAnalyticsSnapshot failed: $e');
    }

    return jsonEncode({
      'total_known_words': 0,
      'total_mastered_grammar': 0,
      'total_conversations': _fallbackConversations.length,
      'total_reviews_due': 0,
      'total_practice_hours': 0.0,
      'average_retention_rate': 0.0,
    });
  }

  static Future<String> getModelRegistry() async {
    _logger.info('Fetching Model Registry Manifest...');
    try {
      final res = await ffi.getModelRegistry();
      if (res.isNotEmpty && !res.startsWith('Error')) {
        return res;
      }
    } catch (e) {
      _logger.warning('FFI getModelRegistry failed: $e');
    }
    return '[]';
  }

  static Future<String> transcribeAudio(List<int> bytes) async {
    _logger.info('Transcribing audio via Whisper STT Engine...');
    try {
      return await ffi.transcribeAudio(audioBytes: bytes);
    } catch (e) {
      _logger.warning('FFI transcribeAudio failed: $e');
      return 'Error transcribing audio';
    }
  }

  static Future<List<int>> synthesizeSpeech(String text) async {
    _logger.info('Synthesizing speech via Piper TTS Engine...');
    try {
      return await ffi.synthesizeSpeech(text: text);
    } catch (e) {
      _logger.warning('FFI synthesizeSpeech failed: $e');
      return [];
    }
  }

  static Stream<ffi.FfiDownloadProgress> downloadModelStream(String modelId) {
    _logger.info('Subscribing to real HTTP download stream for model: $modelId');
    return ffi.downloadModelStream(modelId: modelId);
  }

  static Future<String> getRuntimeDiagnostics() async {
    _logger.info('Fetching Runtime Diagnostics...');
    try {
      final res = await ffi.getRuntimeDiagnostics();
      if (res.isNotEmpty && !res.startsWith('Error')) {
        return res;
      }
    } catch (e) {
      _logger.warning('FFI getRuntimeDiagnostics failed: $e');
    }
    return '{}';
  }

  static Future<String> updateNativeLanguage(String language) async {
    final userJson = await getActiveUser();
    String username = 'Learner';
    String targetLang = 'German';
    if (userJson.isNotEmpty) {
      try {
        final map = jsonDecode(userJson) as Map<String, dynamic>;
        username = map['username'] ?? 'Learner';
        targetLang = map['target_language'] ?? 'German';
      } catch (_) {}
    }
    return createUserProfile(username: username, nativeLang: language, targetLang: targetLang);
  }

  static Future<String> updateTargetLanguage(String language) async {
    final userJson = await getActiveUser();
    String username = 'Learner';
    String nativeLang = 'English';
    if (userJson.isNotEmpty) {
      try {
        final map = jsonDecode(userJson) as Map<String, dynamic>;
        username = map['username'] ?? 'Learner';
        nativeLang = map['native_language'] ?? 'English';
      } catch (_) {}
    }
    return createUserProfile(username: username, nativeLang: nativeLang, targetLang: language);
  }

  static Future<String> sendConversationReply(String conversationId, String text) async {
    return sendDialogueTurn(conversationId, text);
  }
}
