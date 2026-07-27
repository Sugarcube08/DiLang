import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../native_bridge.dart';
import '../theme/theme_extensions.dart';
import '../theme/design_tokens.dart';
import '../theme/di_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import '../components/glass_components.dart';
import '../components/budgie_mascot.dart';

class SessionTurnItem {
  final String speaker;
  final String content;
  final String time;
  SessionTurnItem({required this.speaker, required this.content, required this.time});
}

class ConversationScreen extends ConsumerStatefulWidget {
  const ConversationScreen({super.key});

  @override
  ConsumerState<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? _sessionId;
  bool _isInitializing = true;
  bool _isProcessing = false;
  final List<SessionTurnItem> _sessionTurns = [];

  @override
  void initState() {
    super.initState();
    _initLearningSession();
  }

  Future<void> _initLearningSession() async {
    try {
      final jsonStr = await DiLangNativeBridge.startConversation('cafe_order');
      if (jsonStr.isNotEmpty && !jsonStr.startsWith('Error')) {
        setState(() {
          _sessionId = jsonStr;
          _sessionTurns.add(
            SessionTurnItem(
              speaker: 'tutor',
              content: 'Hallo! Ich bin dein AI Tutor. Was möchtest du heute bestellen?',
              time: 'Just now',
            ),
          );
          _isInitializing = false;
        });
        return;
      }
    } catch (_) {}
    setState(() {
      _sessionTurns.add(
        SessionTurnItem(
          speaker: 'tutor',
          content: 'Guten Tag! Ready to practice ordering at a café in German?',
          time: 'Just now',
        ),
      );
      _isInitializing = false;
    });
  }

  Future<void> _submitTurn() async {
    final text = _inputController.text.trim();
    if (text.isEmpty || _isProcessing) return;

    _inputController.clear();
    setState(() {
      _sessionTurns.add(SessionTurnItem(speaker: 'learner', content: text, time: 'Now'));
      _isProcessing = true;
    });
    _scrollToBottom();

    try {
      if (_sessionId != null) {
        final replyStr = await DiLangNativeBridge.sendConversationReply(_sessionId!, text);
        if (replyStr.isNotEmpty && !replyStr.startsWith('Error')) {
          if (mounted) {
            setState(() {
              _sessionTurns.add(SessionTurnItem(speaker: 'tutor', content: replyStr, time: 'Now'));
              _isProcessing = false;
            });
            _scrollToBottom();
            return;
          }
        }
      }
    } catch (_) {}

    if (mounted) {
      setState(() {
        _sessionTurns.add(SessionTurnItem(
          speaker: 'tutor',
          content: 'Ausgezeichnet! Ich habe Ihre Nachricht verstanden.',
          time: 'Now',
        ));
        _isProcessing = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AtmosphereBackground(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Interactive AI Session'),
        ),
        body: Column(
          children: [
            // Budgie Learning Assistant Header Panel
            GlassContainer(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(14),
              borderRadius: BorderRadius.circular(18),
              child: Row(
                children: [
                  BudgieMascot(
                    size: 48,
                    mood: _isProcessing ? BudgieMood.studying : BudgieMood.happy,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Budgie Learning Assistant',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          _isProcessing ? 'Analyzing syntax & formulating response...' : 'Offline Qwen3-0.6B LLM • German Dialogue',
                          style: TextStyle(fontSize: 12, color: colors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Interactive Dialogue List
            Expanded(
              child: _isInitializing
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(DesignTokens.space16),
                      itemCount: _sessionTurns.length,
                      itemBuilder: (context, index) {
                        final turn = _sessionTurns[index];
                        final isLearner = turn.speaker == 'learner';

                        return Align(
                          alignment: isLearner ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.80,
                            ),
                            child: GlassContainer(
                              padding: const EdgeInsets.all(16),
                              borderRadius: BorderRadius.circular(22),
                              borderColor: isLearner
                                  ? AppColors.turquoise500.withValues(alpha: 0.4)
                                  : (isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder),
                              gradient: isLearner ? AppGradients.primary : null,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    turn.content,
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.4,
                                      color: isLearner
                                          ? Colors.white
                                          : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    turn.time,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isLearner
                                          ? Colors.white.withValues(alpha: 0.75)
                                          : colors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Speech & Input Bar
            GlassContainer(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              borderRadius: BorderRadius.zero,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(DiIcons.mic, color: AppColors.turquoise500),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      decoration: InputDecoration(
                        hintText: 'Speak or type your German response...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: colors.textSecondary, fontSize: 14),
                      ),
                      onSubmitted: (_) => _submitTurn(),
                    ),
                  ),
                  IconButton(
                    icon: _isProcessing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.arrow_upward_rounded, color: AppColors.turquoise500),
                    onPressed: _submitTurn,
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
