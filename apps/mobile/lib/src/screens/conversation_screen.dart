import 'dart:convert';
import 'package:flutter/material.dart';
import '../native_bridge.dart';
import '../theme/theme_extensions.dart';
import '../theme/design_tokens.dart';
import '../theme/di_icons.dart';
import '../components/dilang_input.dart';
import '../components/dilang_button.dart';

class ConversationScreen extends StatefulWidget {
  final String scenarioId;
  final String scenarioTitle;

  const ConversationScreen({
    super.key,
    this.scenarioId = 'default_dialogue',
    this.scenarioTitle = 'Roleplay Dialogue',
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
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _initializeDialogueSession();
  }

  Future<void> _initializeDialogueSession() async {
    final convId = await DiLangNativeBridge.startConversation(widget.scenarioId);
    final historyJson = await DiLangNativeBridge.getConversationHistory(convId);

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

    if (mounted) {
      setState(() {
        _conversationId = convId;
        _messages = loadedMsgs;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleSendMessage() async {
    final text = _inputController.text.trim();
    if (text.isEmpty || _conversationId == null || _isSending) return;

    _inputController.clear();
    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _isSending = true;
    });
    _scrollToBottom();

    final reply = await DiLangNativeBridge.sendDialogueTurn(_conversationId!, text);

    if (mounted) {
      setState(() {
        _messages.add({'sender': 'model', 'text': reply});
        _isSending = false;
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
        title: const Text('Dialogue Practice'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Dialogue Chat List
                Expanded(
                  child: _messages.isEmpty
                      ? Center(
                          child: Text(
                            'No conversation yet.\nType a message to start dialogue.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: colors.textSecondary),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(DesignTokens.space16),
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

                if (_isSending)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: colors.primary),
                    ),
                  ),

                // User Input Bar
                Padding(
                  padding: const EdgeInsets.all(DesignTokens.space16),
                  child: Row(
                    children: [
                      Expanded(
                        child: DiLangInput(
                          controller: _inputController,
                          hintText: 'Type your message...',
                          prefixIcon: DiIcons.mic,
                        ),
                      ),
                      const SizedBox(width: 8),
                      DiLangButton(
                        label: 'Send',
                        icon: DiIcons.play,
                        onPressed: _isSending ? null : _handleSendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
