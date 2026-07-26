import 'dart:convert';
import 'package:flutter/material.dart';
import '../native_bridge.dart';
import '../theme/theme_extensions.dart';
import '../theme/design_tokens.dart';
import '../theme/di_icons.dart';
import '../components/dilang_card.dart';
import '../components/dilang_input.dart';
import '../components/dilang_button.dart';

class ConversationScreen extends StatefulWidget {
  final String scenarioId;
  final String scenarioTitle;

  const ConversationScreen({
    super.key,
    required this.scenarioId,
    required this.scenarioTitle,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _conversationId;
  List<Map<String, String>> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeDialogueSession();
  }

  void _initializeDialogueSession() {
    final convId = DiLangNativeBridge.startConversation(widget.scenarioId);
    final historyJson = DiLangNativeBridge.getConversationHistory(convId);

    List<Map<String, String>> loadedMsgs = [];
    if (historyJson.isNotEmpty && !historyJson.startsWith('Error')) {
      try {
        final List<dynamic> list = jsonDecode(historyJson);
        for (var item in list) {
          loadedMsgs.add({
            'sender': item['sender']?.toString() ?? 'model',
            'text': item['text']?.toString() ?? '',
          });
        }
      } catch (_) {}
    }

    setState(() {
      _conversationId = convId;
      _messages = loadedMsgs;
      _isLoading = false;
    });
  }

  void _handleSendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty || _conversationId == null) return;

    _inputController.clear();
    setState(() {
      _messages.add({'sender': 'user', 'text': text});
    });
    _scrollToBottom();

    final reply = DiLangNativeBridge.sendDialogueTurn(_conversationId!, text);
    setState(() {
      _messages.add({'sender': 'model', 'text': reply});
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.scenarioTitle),
        actions: [
          IconButton(
            icon: const Icon(DiIcons.brain),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Active Scenario Header Banner
                Padding(
                  padding: const EdgeInsets.all(DesignTokens.space16),
                  child: DiLangCard(
                    isGlass: true,
                    child: Row(
                      children: [
                        const Icon(DiIcons.spark, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Roleplay Engine: Gemma 3 1B',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colors.primary,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Target: ${widget.scenarioTitle}',
                                style: TextStyle(color: colors.textSecondary, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Turn-by-Turn Dialogue Chat List
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: DesignTokens.space16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isUser = msg['sender'] == 'user';
                      return Align(
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isUser ? colors.conversationUser : colors.conversationAI,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            msg['text'] ?? '',
                            style: TextStyle(
                              color: isUser ? Colors.white : colors.textPrimary,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // User Dialogue Input Bar
                Padding(
                  padding: const EdgeInsets.all(DesignTokens.space16),
                  child: Row(
                    children: [
                      Expanded(
                        child: DiLangInput(
                          controller: _inputController,
                          hintText: 'Type your response in target language...',
                          prefixIcon: DiIcons.mic,
                        ),
                      ),
                      const SizedBox(width: 8),
                      DiLangButton(
                        label: 'Send',
                        icon: DiIcons.play,
                        onPressed: _handleSendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
