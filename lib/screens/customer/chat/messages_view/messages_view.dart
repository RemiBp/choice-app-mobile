import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/models/chat_model.dart';
import 'package:choice_app/screens/customer/chat/messages_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../res/res.dart';
import '../chat_widgets.dart';

class MessagesView extends StatefulWidget {
  final Chat chat;
  final int currentUserId;

  const MessagesView({
    super.key,
    required this.chat,
    required this.currentUserId,
  });

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final messagesProvider = context.read<MessagesProvider>();
      messagesProvider.init(context, widget.chat.id);
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels <=
        _scrollController.position.minScrollExtent + 100) {
      final messagesProvider = context.read<MessagesProvider>();
      if (!messagesProvider.isLoading && messagesProvider.hasMoreMessages) {
        messagesProvider.loadMoreMessages();
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayName = widget.chat.getDisplayName(widget.currentUserId);
    final avatarUrl = widget.chat.getAvatarUrl(widget.currentUserId);

    return Scaffold(
      appBar: ChatAppBar(title: displayName, imageUrl: avatarUrl),
      backgroundColor: AppColors.whiteColor,
      body: Consumer<MessagesProvider>(
        builder: (context, messagesProvider, child) {
          return Column(
            children: [
              Expanded(
                child:
                    messagesProvider.isLoading &&
                            messagesProvider.messages.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : messagesProvider.error != null &&
                            messagesProvider.messages.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 60,
                                color: Colors.red,
                              ),
                              SizedBox(height: getHeight() * 0.02),
                              Text(messagesProvider.error!),
                              SizedBox(height: getHeight() * 0.02),
                              ElevatedButton(
                                onPressed:
                                    () => messagesProvider.loadMessages(),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                        : messagesProvider.messages.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 80,
                                color: AppColors.greyBordersColor,
                              ),
                              SizedBox(height: getHeight() * 0.02),
                              const Text('No messages yet'),
                              const Text(
                                'Send a message to start the conversation',
                              ),
                            ],
                          ),
                        )
                        : ListView.separated(
                          controller: _scrollController,
                          padding: EdgeInsets.symmetric(
                            vertical: getHeight() * 0.02,
                          ),
                          reverse: true,
                          itemCount: messagesProvider.messages.length,
                          itemBuilder: (context, index) {
                            final reversedIndex =
                                messagesProvider.messages.length - 1 - index;
                            final message =
                                messagesProvider.messages[reversedIndex];
                            final isSentByMe =
                                message.senderId == widget.currentUserId;

                            if (reversedIndex ==
                                messagesProvider.messages.length - 1) {
                              debugPrint(
                                '🔍 Current User ID: ${widget.currentUserId}',
                              );
                            }
                            debugPrint(
                              '🔍 Message ${message.id}: senderId=${message.senderId}, currentUserId=${widget.currentUserId}, isSentByMe=$isSentByMe',
                            );

                            bool showDateDivider = false;
                            if (reversedIndex == 0) {
                              showDateDivider = true;
                            } else {
                              final prevMessage =
                                  messagesProvider.messages[reversedIndex - 1];
                              if (!_isSameDay(
                                message.createdAt,
                                prevMessage.createdAt,
                              )) {
                                showDateDivider = true;
                              }
                            }

                            return Column(
                              children: [
                                if (showDateDivider)
                                  DateDivider(
                                    date: _formatDate(message.createdAt),
                                  ),
                                MessageBubble(
                                  message: message.content,
                                  time: timeago.format(
                                    message.createdAt,
                                    locale: 'en_short',
                                  ),
                                  isSentByMe: isSentByMe,
                                  isRead: message.isRead,
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: getHeightRatio() * 16.0);
                          },
                        ),
              ),

              ChatInputField(
                controller: _messageController,
                isSending: messagesProvider.isSending,
                onSend: (message) {
                  if (message.trim().isNotEmpty) {
                    messagesProvider.sendMessage(content: message);
                    _messageController.clear();
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

      final dayName = days[date.weekday - 1];
      final monthName = months[date.month - 1];

      return '$dayName, ${date.day}/$monthName';
    }
  }
}
