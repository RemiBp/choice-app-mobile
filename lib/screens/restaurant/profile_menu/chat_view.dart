import 'package:choice_app/screens/customer/chat/messages_view/messages_view.dart';
import 'package:choice_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../appAssets/app_assets.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/common_app_bar.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../customWidgets/custom_textfield.dart';
import '../../../res/res.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  List<Map<String, dynamic>> _chats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initSocket();
  }

  Future<void> _initSocket() async {
    await SocketService.connect();
    SocketService.onChats((data) {
      if (!mounted) return;
      final list = data is List ? data : (data['chats'] as List? ?? []);
      setState(() {
        _chats = List<Map<String, dynamic>>.from(
          list.map((e) => Map<String, dynamic>.from(e as Map)),
        );
        _isLoading = false;
      });
    });
    SocketService.getChats();
    // fallback: stop loading after 3s even if no response
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isLoading) setState(() => _isLoading = false);
    });
  }

  @override
  void dispose() {
    SocketService.off('chats');
    super.dispose();
  }

  String _chatName(Map<String, dynamic> chat) {
    final members = chat['chatMembers'] as List? ?? [];
    if (members.isNotEmpty) {
      final other = members.first as Map?;
      return other?['fullName'] as String? ??
          other?['email'] as String? ??
          'User';
    }
    return chat['name'] as String? ?? 'Chat';
  }

  String _lastMessage(Map<String, dynamic> chat) {
    final msgs = chat['messages'] as List?;
    if (msgs != null && msgs.isNotEmpty) {
      return (msgs.last as Map)['content'] as String? ?? '';
    }
    return chat['lastMessage'] as String? ?? '';
  }

  String _avatar(Map<String, dynamic> chat) {
    final members = chat['chatMembers'] as List? ?? [];
    if (members.isNotEmpty) {
      final other = members.first as Map?;
      return other?['avatarUrl'] as String? ?? '';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(title: "Chat"),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
        child: Column(
          children: [
            CustomField(
              borderColor: AppColors.greyBordersColor,
              hint: "Search by name...",
              label: "",
              prefixIconSvg: Assets.searchIcon,
            ),
            SizedBox(height: getHeight() * 0.02),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _chats.isEmpty
                      ? Center(
                          child: CustomText(
                            text: "No conversations yet.",
                            color: AppColors.primarySlateColor,
                            fontSize: sizes?.fontSize14,
                          ),
                        )
                      : ListView.separated(
                          itemCount: _chats.length,
                          separatorBuilder: (_, __) =>
                              Divider(height: getHeight() * 0.025),
                          itemBuilder: (context, index) {
                            final chat = _chats[index];
                            final chatId = (chat['id'] as num?)?.toInt() ?? 0;
                            return _ChatTile(
                              name: _chatName(chat),
                              lastMessage: _lastMessage(chat),
                              avatarUrl: _avatar(chat),
                              onTap: () => context.push(
                                '/messages',
                                extra: {
                                  'chatId': chatId,
                                  'chatName': _chatName(chat),
                                  'avatarUrl': _avatar(chat),
                                },
                              ),
                            );
                          },
                        ),
            ),
            SizedBox(height: getHeight() * 0.02),
          ],
        ),
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String avatarUrl;
  final VoidCallback onTap;

  const _ChatTile({
    required this.name,
    required this.lastMessage,
    required this.avatarUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: getHeight() * 0.025,
        backgroundImage:
            avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
        backgroundColor: AppColors.greyColor,
        child: avatarUrl.isEmpty
            ? const Icon(Icons.person, color: Colors.grey)
            : null,
      ),
      title: CustomText(
        text: name,
        fontWeight: FontWeight.w600,
        fontSize: sizes?.fontSize14,
      ),
      subtitle: lastMessage.isNotEmpty
          ? CustomText(
              text: lastMessage,
              fontSize: sizes?.fontSize12,
              color: AppColors.primarySlateColor,
              textOverflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: const Icon(Icons.chevron_right, color: AppColors.greyColor),
    );
  }
}
