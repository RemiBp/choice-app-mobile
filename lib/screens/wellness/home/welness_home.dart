import 'package:choice_app/appAssets/app_assets.dart';
import 'package:choice_app/customWidgets/custom_button.dart';
import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/providers/producer_provider.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/screens/customer/home/home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_textfield.dart';

class WellnessHome extends StatefulWidget {
  const WellnessHome({super.key});

  @override
  State<WellnessHome> createState() => _WellnessHomeState();
}

class _WellnessHomeState extends State<WellnessHome> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProducerProvider>().loadPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getWidth() * .05,
          vertical: getHeight() * .07,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Welcome",
                      fontSize: sizes?.fontSize14,
                      fontFamily: Assets.onsetMedium,
                    ),
                    CustomText(
                      text: "Liberty Bite Bistro",
                      fontSize: sizes?.fontSize16,
                      fontFamily: Assets.onsetSemiBold,
                      color: AppColors.wellnessPrimaryColor,
                    ),
                  ],
                ),
                Spacer(),
                CustomIconButton(svgString: Assets.chatIcon),
                SizedBox(width: getWidth() * .02),
                CustomIconButton(svgString: Assets.notificationIcon),
              ],
            ),
            SizedBox(height: getHeight() * .02),
            CustomField(
              borderColor: AppColors.greyBordersColor,
              hint: "Search by username or name...",
              prefixIconSvg: Assets.searchIcon,
            ),
            Expanded(
              child: Consumer<ProducerProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoadingPosts && provider.posts.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final items = provider.posts;
                  return ListView.builder(
                    padding: EdgeInsets.only(top: getHeight() * .03),
                    itemCount: items.isEmpty ? 2 : items.length,
                    itemBuilder: (context, index) {
                      return PostCard(
                          post: items.isEmpty ? null : items[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100)
          ),
          backgroundColor: AppColors.getPrimaryColorFromContext(context),
          onPressed: (){
            context.push(Routes.restaurantCreatePostRoute);
          }, label: Row(
        children: [
          Icon(Icons.add, color: Colors.white,),
          CustomText(text: "Create Posts",
              fontSize: sizes?.fontSize12,
            fontFamily: Assets.onsetMedium,
            color: Colors.white,
          ),
        ],
      )),
    );
  }
}
