import 'package:choice_app/common/utils.dart';
import 'package:choice_app/screens/customer/chat/chat_provider.dart';
import 'package:choice_app/screens/customer/chat/user_new_chat/user_new_chat_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../appAssets/app_assets.dart';
import '../../../../appColors/colors.dart';
import '../../../../customWidgets/common_app_bar.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../customWidgets/custom_textfield.dart';
import '../../../../res/res.dart';
import '../../../restaurant/profile_menu/profile_menu_widgets.dart';
import '../custom_category_tabs.dart';

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
       // Initialize socket if token exists (Assumes token is available)
       final token = PreferenceUtils.token;
       if (token != null) {
          context.read<ChatProvider>().init(token);
       }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(
        title: "Chat",
        showBackArrow: true,
        hideBottomBorder: true,
      ),
      body: Consumer<ChatProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.chats.isEmpty) {
             return const Center(child: CircularProgressIndicator());
          }
          
          if (provider.chats.isEmpty) {
             return Center(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Icon(Icons.chat_bubble_outline, size: 48, color: Colors.grey),
                   SizedBox(height: 16),
                   Text("No chats yet. Start a new conversation!"),
                 ],
               ),
             );
          }

          return ListView.separated(
                  itemCount: provider.chats.length,
                  padding:  EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
                  separatorBuilder: (_, __) => Divider(height: getHeight() * 0.025),
                  itemBuilder: (context, index) {
                    final chat = provider.chats[index];
                    // Map backend chat object to UI
                    // Assuming chat structure from backend: { id, chatName, latestMessage, ... }
                    return ChatTile(
                      name: chat['chatName'] ?? "Unknown",
                      username: "", // Customize based on data
                      imageUrl: "https://placehold.co/200", // Placeholder or from data
                      // onTap: () => Navigate to chat details
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100)
          ),
          backgroundColor: AppColors.userPrimaryColor,
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserNewChatView()),
            );
          }, label: Row(
        children: [
          Icon(Icons.add, color: Colors.white,),
          CustomText(
            text: "New Chat",
            fontSize: sizes?.fontSize12,
            fontFamily: Assets.onsetMedium,
            color: Colors.white,
          ),
        ],
      )),
    );
  }
}
