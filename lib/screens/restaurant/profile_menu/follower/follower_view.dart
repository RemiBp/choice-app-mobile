import 'package:choice_app/screens/restaurant/profile_menu/profile_menu_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../appAssets/app_assets.dart';
import '../../../../appColors/colors.dart';
import '../../../../customWidgets/common_app_bar.dart';
import '../../../../customWidgets/custom_textfield.dart';
import '../../../../res/res.dart';

class FollowerView extends StatefulWidget {
  const FollowerView({super.key});

  @override
  State<FollowerView> createState() => _FollowerViewState();
}

class _FollowerViewState extends State<FollowerView> {
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
      appBar: CommonAppBar(title: "Follower"),
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
                separatorBuilder: (_, __) => Divider(height: getHeight() * 0.025,),
                itemBuilder: (context, index) {
                  final user = users[index];
                  return UserTile(
                    name: user['name']!,
                    username: user['username']!,
                    imageUrl: user['image']!,
                  );
                },
              ),
            )
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
  ];
}
