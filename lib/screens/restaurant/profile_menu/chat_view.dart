import 'package:choice_app/screens/restaurant/profile_menu/profile_menu_widgets.dart';
import 'package:flutter/material.dart';
import '../../../appAssets/app_assets.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/common_app_bar.dart';
import '../../../customWidgets/custom_textfield.dart';
import '../../../res/res.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
              controller: _searchController,
              borderColor: AppColors.greyBordersColor,
              hint: "Search by name...",
              label: "",
              prefixIconSvg: Assets.searchIcon,
              // obscure: true,
            ),
            SizedBox(height: getHeight() * 0.02),
            Expanded(
              child: ListView.separated(
                itemCount: users.length,
                separatorBuilder: (_, __) => Divider(height: getHeight() * 0.025),
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ChatTile(
                    name: user['name']!,
                    username: user['username']!,
                    imageUrl: user['image']!,
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
