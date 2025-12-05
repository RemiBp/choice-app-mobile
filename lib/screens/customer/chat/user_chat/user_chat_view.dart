import 'package:choice_app/models/chat_model.dart';
import 'package:choice_app/screens/customer/chat/chat_provider.dart';
import 'package:choice_app/screens/customer/chat/user_new_chat/user_new_chat_view.dart';
import 'package:choice_app/screens/customer/chat/widgets/chat_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../appAssets/app_assets.dart';
import '../../../../appColors/colors.dart';
import '../../../../common/utils.dart';
import '../../../../customWidgets/common_app_bar.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../customWidgets/custom_textfield.dart';
import '../../../../l18n.dart';
import '../../../../res/res.dart';
import '../../../../res/strings.dart';
import '../custom_category_tabs.dart';
import '../messages_view/messages_view.dart';

class UserChatView extends StatefulWidget {
  const UserChatView({super.key});

  @override
  State<UserChatView> createState() => _UserChatViewState();
}

class _UserChatViewState extends State<UserChatView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = context.read<ChatProvider>();
      chatProvider.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(
        title: al.chat,
        showBackArrow: true,
        hideBottomBorder: true,
      ),
      body: CustomCategoryTabs(
        categories: [
          {'id': 1, 'label': 'Friends', 'category': 'FRIENDS'},
          {'id': 2, 'label': 'Restaurants', 'category': 'RESTAURANTS'},
          {'id': 3, 'label': 'Leisure', 'category': 'LEISURE'},
          {'id': 4, 'label': 'Wellness', 'category': 'WELLNESS'},
        ],
        builder: (category) {
          return _buildChatList(category['category'] as String);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        backgroundColor: AppColors.userPrimaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UserNewChatView()),
          );
        },
        label: Row(
          children: [
            const Icon(Icons.add, color: Colors.white),
            CustomText(
              text: al.newChat,
              fontSize: sizes?.fontSize12,
              fontFamily: Assets.onsetMedium,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList(String category) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        final chats = _getChatsForCategory(chatProvider, category);

        return Column(
          children: [
            // Search field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
              child: CustomField(
                borderColor: AppColors.greyBordersColor,
                hint: al.searchByName,
                label: "",
                prefixIconSvg: Assets.searchIcon,
                onChanged: (value) {
                  chatProvider.updateSearchQuery(value);
                },
              ),
            ),
            SizedBox(height: getHeight() * 0.02),

            // Loading indicator
            if (chatProvider.isLoading && chats.isEmpty)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            // Error state
            else if (chatProvider.error != null)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 60,
                        color: Colors.red,
                      ),
                      SizedBox(height: getHeight() * 0.02),
                      CustomText(
                        text: chatProvider.error!,
                        fontSize: sizes?.fontSize14,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: getHeight() * 0.02),
                      ElevatedButton(
                        onPressed: () => chatProvider.loadChats(),
                        child: CustomText(text: 'Retry', color: Colors.white),
                      ),
                    ],
                  ),
                ),
              )
            // Empty state
            else if (chats.isEmpty)
              Expanded(
                child: _buildEmptyState(_getCategoryDisplayName(category)),
              )
            // Chat list
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => chatProvider.refreshChats(),
                  child: ListView.separated(
                    itemCount: chats.length,
                    padding: EdgeInsets.symmetric(
                      horizontal: sizes!.pagePadding,
                    ),
                    separatorBuilder:
                        (_, __) => Divider(height: getHeight() * 0.025),
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      final currentUserId = PreferenceUtils.getInt(
                        Strings.userId,
                        0,
                      );

                      return ChatListTile(
                        chat: chat,
                        currentUserId: currentUserId,
                        onTap: () {
                          _navigateToMessages(chat, currentUserId);
                        },
                      );
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  List<Chat> _getChatsForCategory(ChatProvider provider, String category) {
    switch (category) {
      case 'FRIENDS':
        return provider.friendsChats;
      case 'RESTAURANTS':
        return provider.restaurantsChats;
      case 'LEISURE':
        return provider.leisureChats;
      case 'WELLNESS':
        return provider.wellnessChats;
      default:
        return [];
    }
  }

  String _getCategoryDisplayName(String category) {
    switch (category) {
      case 'FRIENDS':
        return 'Friends';
      case 'RESTAURANTS':
        return 'Restaurants';
      case 'LEISURE':
        return 'Leisure';
      case 'WELLNESS':
        return 'Wellness';
      default:
        return category;
    }
  }

  Widget _buildEmptyState(String categoryName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: AppColors.greyBordersColor,
          ),
          SizedBox(height: getHeight() * 0.02),
          CustomText(
            text: 'No $categoryName chats yet',
            fontSize: sizes?.fontSize16,
            fontWeight: FontWeight.w500,
            color: AppColors.blackColor,
          ),
          SizedBox(height: getHeight() * 0.01),
          CustomText(
            text: 'Start a new conversation!',
            fontSize: sizes?.fontSize14,
            color: AppColors.primarySlateColor,
          ),
        ],
      ),
    );
  }

  void _navigateToMessages(Chat chat, int currentUserId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => MessagesView(chat: chat, currentUserId: currentUserId),
      ),
    );
  }
}
