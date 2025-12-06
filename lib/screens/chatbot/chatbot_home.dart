import 'package:choice_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../appAssets/app_assets.dart';
import '../../../../appColors/colors.dart';
import '../../../../customWidgets/custom_button.dart';
import '../../../../res/res.dart';
import '../../customWidgets/custom_text.dart';
import '../../l18n.dart';
import '../subscription/subscriber_provider.dart';

class ChatBotHome extends StatefulWidget {
  const ChatBotHome({super.key});

  @override
  State<ChatBotHome> createState() => _ChatBotHomeState();
}

class _ChatBotHomeState extends State<ChatBotHome> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SubscriberProvider>();

      // Set the dialog callback
      provider.onLimitReached = _showUpgradeDialog;

      // Auto-scroll listener only
      provider.addListener(() {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      });
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void sendMessage() {
    final provider = context.read<SubscriberProvider>();

    // Show dialog and block sending when limit reached
    if (provider.limitBlocked) {
      _showUpgradeDialog();
      return;
    }

    final text = messageController.text.trim();
    if (text.isEmpty) return;

    provider.sendQuery(text);
    messageController.clear();
  }
  @override
  Widget build(BuildContext context) {
    final themeColor = AppColors.getPrimaryColorFromContext(context);
    final provider = context.watch<SubscriberProvider>();
    final messages = provider.messages;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Text(
          "AI Copilot",
          style: TextStyle(
            fontSize: sizes?.fontSize18,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
        ),
      ),
      body: Column(
        children: [
          // Chat Area
          Expanded(
            child: messages.isEmpty
                ? _buildWelcomeView(themeColor)
                : ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(
                horizontal: sizes!.pagePadding,
                vertical: getHeight() * 0.02,
              ),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg.isUser;

                return Align(
                  alignment:
                  isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(
                      bottom: getHeight() * 0.015,
                      left: isUser ? getWidth() * 0.15 : 0,
                      right: isUser ? 0 : getWidth() * 0.15,
                    ),
                    child: Column(
                      crossAxisAlignment: isUser
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isUser
                                ? themeColor
                                : AppColors.greyColor.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(14),
                              topRight: const Radius.circular(14),
                              bottomLeft:
                              Radius.circular(isUser ? 14 : 0),
                              bottomRight:
                              Radius.circular(isUser ? 0 : 14),
                            ),
                          ),
                          child: SelectableText(
                            msg.text,
                            style: TextStyle(
                              fontSize: sizes?.fontSize14,
                              color: isUser ? AppColors.whiteColor : AppColors.blackColor,
                            ),
                          )
                        ),

                        // DATA LIST (if exists)
                        if (msg.data != null &&
                            msg.data is List &&
                            msg.data.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 6.0, left: 6, right: 6),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: msg.data.map<Widget>((item) {
                                return _buildDynamicDataItem(item);
                              }).toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Input Bar
          SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(
                  color: AppColors.greyBordersColor,
                  thickness: 1,
                  height: 1,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: sizes!.pagePadding,
                    vertical: getHeight() * 0.012,
                  ),
                  color: AppColors.whiteColor,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          maxLines: null,
                          minLines: 1,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: themeColor.withValues(alpha: 0.08),
                            hintText: al.typeMessage,
                            hintStyle: TextStyle(
                              color: AppColors.inputHintColor,
                              fontSize: sizes?.fontSize14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                  color: AppColors.greyBordersColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                  color: AppColors.greyBordersColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: themeColor,
                                width: 1.5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: getWidth() * 0.02),
                      GestureDetector(
                        onTap: sendMessage, // Always callable - handles blocking internally
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: provider.limitBlocked ? Colors.grey : themeColor,
                          child: Icon(
                            Icons.send,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Welcome empty state
  Widget _buildWelcomeView(Color themeColor) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Assets.copilotIcon,
                  height: 44,
                  width: 44,
                ),
                const SizedBox(width: 10),
                Text(
                  "Copilot",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w600,
                    fontFamily: Assets.onsetSemiBold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              "Your Everyday AI Companion",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: Assets.onsetRegular,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Upgrade Dialog
  void _showUpgradeDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) {
        final themeColor = AppColors.getPrimaryColorFromContext(context);

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: getWidth() * 0.08,
          ),
          child: Container(
            height: getHeight() * 0.35,
            padding: EdgeInsets.all(getWidth() * 0.06),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(getWidth() * 0.05),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: getWidth() * 0.20,
                  height: getWidth() * 0.20,
                  decoration: BoxDecoration(
                    color: AppColors.restaurantPrimaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(getWidth() * 0.15),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      Assets.crownIcon,
                      height: getWidth() * 0.12,
                      width: getWidth() * 0.12,
                    ),
                  ),
                ),
                SizedBox(height: getHeight() * 0.02),
                CustomText(
                  text: al.unlockMoreWithPlus,
                  textAlign: TextAlign.center,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: Assets.onsetSemiBold,
                ),
                SizedBox(height: getHeight() * 0.01),
                CustomText(
                  text: al.getMoreCapableModels,
                  textAlign: TextAlign.center,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: Assets.onsetRegular,
                  giveLinesAsText: true,
                ),
                const Spacer(),
                CustomButton(
                  buttonText: al.upgrade,
                  onTap: () {
                    context.push(Routes.subscribeRoute);
                  },
                  backgroundColor: themeColor,
                  textColor: AppColors.whiteColor,
                  borderColor: Colors.transparent,
                  buttonWidth: double.infinity,
                  height: getHeight() * 0.055,
                  textFontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDynamicDataItem(Map item) {
    final ignoreKeys = {"id", "latitude", "longitude", "distance_km"};

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: item.entries
            .where((e) => !ignoreKeys.contains(e.key) && e.value != null && e.value.toString().trim().isNotEmpty)
            .map((e) {
          return Text(
            "${_formatKey(e.key)}: ${e.value}",
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black,
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatKey(String key) {
    // businessHours → Business Hours
    return key
        .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m.group(1)} ${m.group(2)}')
        .replaceAll("_", " ")
        .replaceFirst(key[0], key[0].toUpperCase());
  }

}
