import 'package:flutter/material.dart';
import '../../../appAssets/app_assets.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../l18n.dart';
import '../../../res/res.dart';

class DateDivider extends StatelessWidget {
  final String date;

  const DateDivider({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.greyBordersColor)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.02),
          child: CustomText(
            text: date,
            color: AppColors.inputHintColor,
            fontSize: sizes?.fontSize12,
          ),
        ),
        const Expanded(child: Divider(color: AppColors.greyBordersColor)),
      ],
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isSentByMe;
  final bool isRead;
  final String? imageUrl;

  const MessageBubble({
    super.key,
    required this.message,
    required this.time,
    this.isSentByMe = false,
    this.isRead = false,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: getWidth() * 0.6),
          child: Container(
            padding:
                imageUrl != null
                    ? const EdgeInsets.all(8)
                    : EdgeInsets.symmetric(
                      horizontal: sizes!.pagePadding,
                      vertical: getHeight() * 0.01,
                    ),
            decoration: BoxDecoration(
              color:
                  isSentByMe
                      ? AppColors.getPrimaryColorFromContext(context)
                      : AppColors.greyColor,
              borderRadius:
                  isSentByMe
                      ? const BorderRadius.only(
                        topRight: Radius.circular(16),
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      )
                      : const BorderRadius.only(
                        topRight: Radius.circular(16),
                        topLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
            ),
            child: Column(
              crossAxisAlignment:
                  isSentByMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
              children: [
                // if (imageUrl != null)
                //   ClipRRect(
                //     borderRadius: BorderRadius.circular(4),
                //     child: Image.asset(
                //       imageUrl!,
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // if (imageUrl != null) const SizedBox(height: 8),
                CustomText(
                  text: message,
                  fontSize: sizes?.fontSize14,
                  giveLinesAsText: true,
                  color:
                      isSentByMe ? AppColors.whiteColor : AppColors.blackColor,
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment:
                      isSentByMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                  children: [
                    CustomText(
                      text: time,
                      giveLinesAsText: true,
                      color:
                          isSentByMe
                              ? AppColors.whiteColor
                              : AppColors.blackColor,
                      fontSize: sizes?.fontSize10,
                    ),
                    if (isSentByMe && isRead) ...[
                      const SizedBox(width: 4),
                      CustomText(
                        text: "· Read",
                        color: AppColors.whiteColor,
                        fontSize: 10,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSend;
  final bool isSending;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
    this.isSending = false,
  });

  @override
  Widget build(BuildContext context) {
    final double fieldHeight = getHeight() * 0.06; // same for both

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Divider(color: AppColors.greyBordersColor),
        ),
        Row(
          children: [
            SizedBox(width: sizes!.pagePadding),

            // Text Field
            Expanded(
              child: SizedBox(
                height: fieldHeight,
                child: TextField(
                  controller: controller,
                  enabled: !isSending,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty && !isSending) {
                      onSend(value);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: al.typeMessage,
                    filled: true,
                    fillColor: AppColors.getPrimaryColorFromContext(
                      context,
                    ).withAlpha(40),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        fieldHeight / 2,
                      ), // pill shape
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(fieldHeight / 2),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(fieldHeight / 2),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Send Button
            GestureDetector(
              onTap:
                  isSending
                      ? null
                      : () {
                        final text = controller.text;
                        if (text.trim().isNotEmpty) {
                          onSend(text);
                        }
                      },
              child: Container(
                width: fieldHeight,
                height: fieldHeight,
                decoration: BoxDecoration(
                  color:
                      isSending
                          ? AppColors.greyBordersColor
                          : AppColors.getPrimaryColorFromContext(context),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child:
                      isSending
                          ? SizedBox(
                            width: fieldHeight * 0.4,
                            height: fieldHeight * 0.4,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : Image.asset(
                            Assets.chatSentIcon,
                            width: fieldHeight * 0.5,
                            height: fieldHeight * 0.5,
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

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? imageUrl;
  final VoidCallback? onNext;
  final bool showNextButton;

  const ChatAppBar({
    super.key,
    required this.title,
    this.imageUrl,
    this.onNext,
    this.showNextButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: 0,
      backgroundColor: AppColors.whiteColor,
      elevation: 0,
      shape: const Border(
        bottom: BorderSide(color: AppColors.greyBordersColor, width: 1),
      ),
      title: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
            onPressed: () => Navigator.pop(context),
          ),
          if (imageUrl != null) ...[
            CircleAvatar(
              radius: getHeight() * 0.02,
              backgroundImage: NetworkImage(imageUrl!),
            ),
            SizedBox(width: getWidth() * 0.02),
          ],
          Expanded(
            child: CustomText(
              text: title,
              fontWeight: FontWeight.w600,
              fontSize: sizes?.fontSize18,
              color: AppColors.blackColor,
            ),
          ),
          if (showNextButton && onNext != null)
            TextButton(
              onPressed: onNext,
              child: CustomText(
                text: al.next,
                fontWeight: FontWeight.w600,
                fontSize: sizes?.fontSize14,
                color: AppColors.getPrimaryColorFromContext(context),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// class ChatSearchAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final TextEditingController searchController;
//   final VoidCallback onNext;
//
//   const ChatSearchAppBar({
//     super.key,
//     required this.searchController,
//     required this.onNext,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       automaticallyImplyLeading: false,
//       backgroundColor: AppColors.whiteColor,
//       elevation: 0,
//       shape: const Border(
//         bottom: BorderSide(color: AppColors.greyBordersColor, width: 1),
//       ),
//       title: Row(
//         children: [
//           IconButton(
//             icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
//             onPressed: () => Navigator.pop(context),
//           ),
//           Expanded(
//             child: TextField(
//               controller: searchController,
//               decoration: InputDecoration(
//                 hintText: "To: Type a username or name",
//                 hintStyle: TextStyle(fontSize: sizes?.fontSize14, color: Colors.grey),
//                 isDense: true,
//                 contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//                 filled: true,
//                 fillColor: Colors.grey[200],
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//           ),
//           TextButton(
//             onPressed: onNext,
//             child: CustomText(
//               text: "Next",
//               fontWeight: FontWeight.w600,
//               fontSize: sizes?.fontSize14,
//               color: AppColors.getPrimaryColorFromContext(context),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }

class ChatGroupTile extends StatelessWidget {
  final String name;
  final String username;
  final String imageUrl;
  final bool isSelected;
  final VoidCallback onTap;

  const ChatGroupTile({
    super.key,
    required this.name,
    required this.username,
    required this.imageUrl,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            radius: getHeight() * 0.03,
            backgroundImage: NetworkImage(imageUrl),
          ),
          SizedBox(width: getWidth() * 0.02),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: name,
                  fontWeight: FontWeight.w500,
                  fontSize: sizes?.fontSize14,
                  color: AppColors.blackColor,
                ),
                CustomText(
                  text: username,
                  fontWeight: FontWeight.w400,
                  fontSize: sizes?.fontSize12,
                  color: AppColors.primarySlateColor,
                ),
              ],
            ),
          ),
          Icon(
            isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
            color:
                isSelected
                    ? AppColors.getPrimaryColorFromContext(context)
                    : Colors.grey,
          ),
        ],
      ),
    );
  }
}

class SelectedMembersRow extends StatelessWidget {
  final List<Map<String, String>> selectedUsers;

  const SelectedMembersRow({super.key, required this.selectedUsers});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: sizes!.pagePadding,
        vertical: getHeight() * 0.015,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "${al.members}: ${selectedUsers.length} out of 50",
            fontWeight: FontWeight.w500,
            fontSize: sizes?.fontSize14,
            color: AppColors.blackColor,
          ),
          SizedBox(height: getHeight() * 0.015),
          SizedBox(
            height: getHeight() * 0.12,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: selectedUsers.length,
              separatorBuilder: (_, __) => SizedBox(width: getWidth() * 0.03),
              itemBuilder: (context, index) {
                final user = selectedUsers[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: getHeight() * 0.03,
                      backgroundImage: NetworkImage(user['image']!),
                    ),
                    SizedBox(height: getHeight() * 0.01),
                    SizedBox(
                      width: getWidth() * 0.2,
                      child: CustomText(
                        text: user['name']!,
                        fontSize: sizes?.fontSize12,
                        textOverflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
