import 'package:choice_app/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../appColors/colors.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../res/res.dart';

class ChatListTile extends StatelessWidget {
  final Chat chat;
  final int currentUserId;
  final VoidCallback onTap;

  const ChatListTile({
    super.key,
    required this.chat,
    required this.currentUserId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = chat.getDisplayName(currentUserId);
    final avatarUrl = chat.getAvatarUrl(currentUserId);
    final lastMessageText = chat.lastMessage?.content ?? '';
    final lastMessageTime = chat.lastMessage?.createdAt;

    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: getHeight() * 0.03,
            backgroundImage:
                avatarUrl != null && avatarUrl.isNotEmpty
                    ? NetworkImage(avatarUrl)
                    : null,
            backgroundColor: AppColors.getPrimaryColorFromContext(context),
            child:
                avatarUrl == null || avatarUrl.isEmpty
                    ? Icon(
                      chat.isGroupChat ? Icons.group : Icons.person,
                      color: AppColors.whiteColor,
                      size: getHeight() * 0.03,
                    )
                    : null,
          ),
          SizedBox(width: getWidth() * 0.02),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomText(
                        text: displayName,
                        fontWeight: FontWeight.w500,
                        fontSize: sizes?.fontSize14,
                        color: AppColors.blackColor,
                      ),
                    ),

                    if (lastMessageTime != null)
                      CustomText(
                        text: timeago.format(
                          lastMessageTime,
                          locale: 'en_short',
                        ),
                        fontWeight: FontWeight.w400,
                        fontSize: sizes?.fontSize12,
                        color: AppColors.primarySlateColor,
                      ),
                  ],
                ),
                SizedBox(height: getHeight() * 0.005),

                if (lastMessageText.isNotEmpty)
                  CustomText(
                    text: lastMessageText,
                    fontWeight: FontWeight.w400,
                    fontSize: sizes?.fontSize12,
                    color: AppColors.primarySlateColor,
                    textOverflow: TextOverflow.ellipsis,
                    lines: 1,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
