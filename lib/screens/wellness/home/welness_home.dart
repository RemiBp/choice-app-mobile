import 'package:choice_app/appAssets/app_assets.dart';
import 'package:choice_app/customWidgets/custom_button.dart';
import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/screens/customer/home/home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:choice_app/screens/restaurant/home/producer_post_provider.dart';

import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_textfield.dart';
import '../../../customWidgets/animations/bouncing_wrapper.dart';
import '../../../customWidgets/glass/glass_container.dart';
import '../../../customWidgets/animations/fade_in_up.dart';

class WellnessHome extends StatefulWidget {
  const WellnessHome({super.key});

  @override
  State<WellnessHome> createState() => _WellnessHomeState();
}

class _WellnessHomeState extends State<WellnessHome> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProducerPostProvider>().fetchMyPosts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 1. Content
          Positioned.fill(
             child: Consumer<ProducerPostProvider>(
               builder: (context, provider, child) {
                 if (provider.isLoading) return Center(child: CircularProgressIndicator());
                 
                 final posts = provider.posts;
                 
                 return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: posts.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                         children: [
                           SizedBox(height: getHeight() * 0.14), // Header buffer
                           
                           // Search Bar
                           Padding(
                             padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                             child: GlassContainer(
                                blur: 10,
                                opacity: 0.1,
                                color: Colors.black.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(30),
                                child: CustomField(
                                  controller: _searchController,
                                  borderColor: Colors.transparent,
                                  hint: "Search wellness posts...",
                                  hintColor: AppColors.textGreyColor,
                                  textColor: Colors.black87,
                                  prefixIconSvg: Assets.searchIcon,
                                  bgColor: Colors.transparent,
                                ),
                             ),
                           ),
                           SizedBox(height: 10),
                           if (posts.isEmpty)
                             Padding(
                               padding: const EdgeInsets.only(top: 20.0),
                               child: Text("No posts found. Create one!"),
                             ),
                         ],
                      );
                    }
                    
                    final post = posts[index - 1];
                    return FadeInUp(
                      delay: Duration(milliseconds: 100 * (index > 3 ? 3 : index)),
                      child: PostCard(post: post),
                    );
                  },
                );
               },
             ),
          ),

          // 2. Glass Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GlassContainer(
              blur: 20,
              opacity: 0.8,
              color: Colors.white.withOpacity(0.8), // Glassy white for Wellness
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  getWidth() * .05,
                  getHeight() * .06,
                  getWidth() * .05,
                  getHeight() * .02,
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                           text: "Wellness",
                           fontSize: sizes?.fontSize28,
                           fontFamily: Assets.onsetSemiBold,
                           color: AppColors.blackColor,
                        ),
                         CustomText(
                           text: "Discover Health & Balance",
                           fontSize: sizes?.fontSize12,
                           color: AppColors.textGreyColor,
                        ),
                      ],
                    ),
                    Spacer(),
                    BouncingWrapper(
                      onTap: () {
                        context.push(Routes.chatRoute);
                      },
                      child: CustomIconButton(svgString: Assets.chatIcon, color: AppColors.blackColor)
                    ),
                    SizedBox(width: getWidth() * .02),
                    BouncingWrapper(
                       onTap: () {
                         context.push(Routes.notificationsRoute);
                       },
                       child: CustomIconButton(svgString: Assets.notificationIcon, color: AppColors.blackColor)
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      
      // Floating Action Button
      floatingActionButton: BouncingWrapper(
        onTap: () {
          context.push(Routes.restaurantCreatePostRoute);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.wellnessPrimaryColor, Color(0xFF66BB6A)]),
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: AppColors.wellnessPrimaryColor.withOpacity(0.5),
                blurRadius: 20,
                offset: Offset(0, 8),
              )
            ]
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.edit, color: Colors.white),
              SizedBox(width: 8),
              CustomText(
                text: "Post",
                fontSize: sizes?.fontSize14,
                fontFamily: Assets.onsetMedium,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
