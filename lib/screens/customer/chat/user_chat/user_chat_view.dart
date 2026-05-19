import 'package:choice_app/screens/customer/chat/messages_view/messages_view.dart';
import 'package:choice_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../appAssets/app_assets.dart';
import '../../../../appColors/colors.dart';
import '../../../../customWidgets/common_app_bar.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../customWidgets/custom_textfield.dart';
import '../../../../res/res.dart';
import '../custom_category_tabs.dart';

class UserChatView extends StatefulWidget {
  const UserChatView({super.key});

  @override
  State<UserChatView> createState() => _UserChatViewState();
}

class _UserChatViewState extends State<UserChatView> {
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
          other?['businessName'] as String? ??
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
      return (members.first as Map?)?['avatarUrl'] as String? ?? '';
    }
    return '';
  }

  Widget _chatList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_chats.isEmpty) {
      return Center(
        child: CustomText(
          text: "No conversations yet.\nStart a new chat!",
          color: AppColors.primarySlateColor,
          fontSize: sizes?.fontSize14,
          giveLinesAsText: true,
          textAlign: TextAlign.center,
        ),
      );
    }
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
      itemCount: _chats.length,
      separatorBuilder: (_, __) => Divider(height: getHeight() * 0.025),
      itemBuilder: (context, index) {
        final chat = _chats[index];
        final chatId = (chat['id'] as num?)?.toInt() ?? 0;
        return ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: () => context.push(
            '/messages',
            extra: {
              'chatId': chatId,
              'chatName': _chatName(chat),
              'avatarUrl': _avatar(chat),
            },
          ),
          leading: CircleAvatar(
            radius: getHeight() * 0.025,
            backgroundImage: _avatar(chat).isNotEmpty
                ? NetworkImage(_avatar(chat))
                : null,
            backgroundColor: AppColors.greyColor,
            child: _avatar(chat).isEmpty
                ? const Icon(Icons.person, color: Colors.grey)
                : null,
          ),
          title: CustomText(
            text: _chatName(chat),
            fontWeight: FontWeight.w600,
            fontSize: sizes?.fontSize14,
          ),
          subtitle: _lastMessage(chat).isNotEmpty
              ? CustomText(
                  text: _lastMessage(chat),
                  fontSize: sizes?.fontSize12,
                  color: AppColors.primarySlateColor,
                  textOverflow: TextOverflow.ellipsis,
                )
              : null,
          trailing: const Icon(Icons.chevron_right, color: AppColors.greyColor),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(
        title: "Chat",
        showBackArrow: false,
        hideBottomBorder: true,
      ),
      body: CustomCategoryTabs(
        categories: const [
          {'id': 1, 'label': 'All'},
          {'id': 2, 'label': 'Restaurants'},
          {'id': 3, 'label': 'Leisure'},
          {'id': 4, 'label': 'Wellness'},
        ],
        builder: (category) {
          return Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
                child: CustomField(
                  borderColor: AppColors.greyBordersColor,
                  hint: "Search by name...",
                  label: "",
                  prefixIconSvg: Assets.searchIcon,
                ),
              ),
              SizedBox(height: getHeight() * 0.02),
              Expanded(child: _chatList()),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        backgroundColor: AppColors.userPrimaryColor,
        onPressed: () => context.push('/new_chat'),
        label: Row(
          children: [
            const Icon(Icons.add, color: Colors.white),
            CustomText(
              text: "New Chat",
              fontSize: sizes?.fontSize12,
              fontFamily: Assets.onsetMedium,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
