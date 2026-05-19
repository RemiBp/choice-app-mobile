import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../appAssets/app_assets.dart';
import '../../../../appColors/colors.dart';
import '../../../../customWidgets/common_app_bar.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../res/res.dart';
import '../../../restaurant/profile_menu/profile_menu_widgets.dart';

class UserNewChatView extends StatefulWidget {
  const UserNewChatView({super.key});

  @override
  State<UserNewChatView> createState() => _UserNewChatViewState();
}

class _UserNewChatViewState extends State<UserNewChatView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(title: "New Chat"),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getHeight() * 0.02),
            GestureDetector(
              onTap: () {
                context.push('/new_group');
              },
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: AppColors.getPrimaryColorFromContext(context),
                        shape: BoxShape.circle
                    ),
                    child: Center(
                      child: Image.asset(
                        Assets.addUserIcon,width: 20,
                        height: 20,
                      ),
                      // child: Icon(Icons.person_add_alt, color: AppColors.getPrimaryColorFromContext(context),),
                    ),
                  ),
                  SizedBox(width: getWidth() * 0.02),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "Group Chat",
                          fontSize: sizes?.fontSize16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackColor,
                        ),
                        CustomText(
                          text: "Chat with up to 50 friends",
                          fontSize: sizes?.fontSize12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.inputHintColor,
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: getWidth() * 0.02),
                ],
              ),
            ),
            SizedBox(height: getHeight() * 0.02),
            CustomText(
              text: "Suggested",
              fontWeight: FontWeight.w500,
              fontSize: sizes?.fontSize16,
              color: AppColors.blackColor,
            ),
            SizedBox(height: getHeight() * 0.02),
            Expanded(
              child: ListView.separated(
                itemCount: users.length,
                separatorBuilder: (_, __) => Divider(height: getHeight() * 0.025),
                itemBuilder: (context, index) {
                  final user = users[index];
                  return GestureDetector(
                    onTap: () {
                      context.push('/messages', extra: {
                        'chatId': 0,
                        'chatName': user['name']!,
                        'avatarUrl': user['image']!,
                      });
                    },
                    child: UserTile(
                      name: user['name']!,
                      username: user['username']!,
                      imageUrl: user['image']!,
                      hideButton: true,
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

  final List<Map<String, String>> users = const [
    {
      'name': 'Emelie',
      'username': 'emelie645',
      'image':
      'https://images.unsplash.com/photo-1502685104226-ee32379fefbe?fit=crop&w=200&q=80'
    },
    {
      'name': 'Olivia',
      'username': 'olivia223',
      'image':
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?fit=crop&w=200&q=80'
    },
    {
      'name': 'Sophia',
      'username': 'sophia007',
      'image':
      'https://images.unsplash.com/photo-1544005313-94ddf0286df2?fit=crop&w=200&q=80'
    },
    {
      'name': 'Liam',
      'username': 'liam_88',
      'image':
      'https://images.unsplash.com/photo-1527980965255-d3b416303d12?fit=crop&w=200&q=80'
    },
    {
      'name': 'Noah',
      'username': 'noah_the_one',
      'image':
      'https://images.unsplash.com/photo-1541233349642-6e425fe6190e?fit=crop&w=200&q=80'
    },
    {
      'name': 'Ava',
      'username': 'ava123',
      'image':
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?fit=crop&w=200&q=80'
    },
    {
      'name': 'Isabella',
      'username': 'bella_91',
      'image':
      'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?fit=crop&w=200&q=80'
    },
    {
      'name': 'Mason',
      'username': 'mason_co',
      'image':
      'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?fit=crop&w=200&q=80'
    },
    {
      'name': 'Lucas',
      'username': 'lucas_light',
      'image':
      'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?fit=crop&w=200&q=80'
    },
    {
      'name': 'Mia',
      'username': 'mia_2000',
      'image':
      'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?fit=crop&w=200&q=80'
    },
    {
      'name': 'Ethan',
      'username': 'ethan_the_guy',
      'image':
      'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?fit=crop&w=200&q=80'
    },
  ];
}
