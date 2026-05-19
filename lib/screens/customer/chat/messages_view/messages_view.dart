import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import '../../../../res/res.dart';
import '../chat_widgets.dart';

class MessagesView extends StatefulWidget {
  final int chatId;
  final String chatName;
  final String avatarUrl;

  const MessagesView({
    super.key,
    required this.chatId,
    required this.chatName,
    this.avatarUrl = '',
  });

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initSocket();
  }

  Future<void> _initSocket() async {
    await SocketService.connect();

    SocketService.onMessages((data) {
      if (!mounted) return;
      final list = data is List ? data : (data['messages'] as List? ?? []);
      setState(() {
        _messages.clear();
        _messages.addAll(
          List<Map<String, dynamic>>.from(
            list.map((e) => Map<String, dynamic>.from(e as Map)),
          ),
        );
        _isLoading = false;
      });
      _scrollToBottom();
    });

    SocketService.onReceiveMessage((data) {
      if (!mounted) return;
      final msg = Map<String, dynamic>.from(data as Map);
      if (msg['chatId'] == widget.chatId) {
        setState(() => _messages.add(msg));
        _scrollToBottom();
      }
    });

    SocketService.onMessageSent((data) {
      if (!mounted) return;
      final msg = Map<String, dynamic>.from(data as Map);
      setState(() => _messages.add(msg));
      _scrollToBottom();
    });

    SocketService.getMessages(chatId: widget.chatId);

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isLoading) setState(() => _isLoading = false);
    });
  }

  @override
  void dispose() {
    SocketService.off('messages');
    SocketService.off('receiveMessage');
    SocketService.off('messageSent');
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    SocketService.sendMessage(chatId: widget.chatId, content: text);
    _inputController.clear();
  }

  String _formatTime(String? iso) {
    if (iso == null) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(
        title: widget.chatName,
        imageUrl: widget.avatarUrl.isNotEmpty ? widget.avatarUrl : null,
      ),
      backgroundColor: AppColors.whiteColor,
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                    ? Center(
                        child: Text(
                          'No messages yet. Say hello!',
                          style: TextStyle(
                            color: AppColors.primarySlateColor,
                            fontSize: sizes?.fontSize14,
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(
                            vertical: getHeight() * 0.02),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final msg = _messages[index];
                          final isMine = msg['isSentByMe'] as bool? ??
                              msg['isOwn'] as bool? ??
                              false;
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom: getHeightRatio() * 12),
                            child: MessageBubble(
                              message: msg['content'] as String? ??
                                  msg['message'] as String? ??
                                  '',
                              time: _formatTime(
                                  msg['createdAt'] as String? ??
                                      msg['time'] as String?),
                              isSentByMe: isMine,
                              isRead: msg['isRead'] as bool? ?? false,
                            ),
                          );
                        },
                      ),
          ),
          _SocketChatInputField(
            controller: _inputController,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}

class _SocketChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _SocketChatInputField({
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final double fieldHeight = getHeight() * 0.06;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Divider(color: AppColors.greyBordersColor),
        ),
        Row(
          children: [
            SizedBox(width: sizes!.pagePadding),
            Expanded(
              child: SizedBox(
                height: fieldHeight,
                child: TextField(
                  controller: controller,
                  onSubmitted: (_) => onSend(),
                  decoration: InputDecoration(
                    hintText: "Type a message...",
                    filled: true,
                    fillColor: AppColors.getPrimaryColorFromContext(context)
                        .withAlpha(40),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(fieldHeight / 2),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(fieldHeight / 2),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(fieldHeight / 2),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onSend,
              child: Container(
                width: fieldHeight,
                height: fieldHeight,
                decoration: BoxDecoration(
                  color:
                      AppColors.getPrimaryColorFromContext(context),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: fieldHeight * 0.45,
                  ),
                ),
              ),
            ),
            SizedBox(width: sizes!.pagePadding),
          ],
        ),
        SizedBox(height: getHeight() * 0.02),
      ],
    );
  }
}
