import 'package:choice_app/appAssets/app_assets.dart';
import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/customWidgets/custom_button.dart';
import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/customWidgets/custom_textfield.dart';
import 'package:choice_app/providers/producer_provider.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/screens/customer/home/home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RestaurantHome extends StatefulWidget {
  const RestaurantHome({super.key});

  @override
  State<RestaurantHome> createState() => _RestaurantHomeState();
}

class _RestaurantHomeState extends State<RestaurantHome> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProducerProvider>().loadPosts(refresh: true);
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
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getWidth() * .05,
          vertical: getHeight() * .07,
        ),
        child: Column(
          children: [
            Row(
              children: [
                CustomText(
                  text: "Choice",
                  fontSize: sizes?.fontSize28,
                  fontFamily: Assets.onsetSemiBold,
                ),
                const Spacer(),
                CustomIconButton(svgString: Assets.mapIcon),
                SizedBox(width: getWidth() * .02),
                CustomIconButton(svgString: Assets.chatIcon),
                SizedBox(width: getWidth() * .02),
                CustomIconButton(svgString: Assets.notificationIcon),
              ],
            ),
            SizedBox(height: getHeight() * .02),
            CustomField(
              textEditingController: _searchController,
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
                  if (provider.posts.isEmpty) {
                    return Center(
                      child: CustomText(
                        text: 'No posts yet. Create your first one!',
                        fontSize: sizes?.fontSize14,
                        color: AppColors.primarySlateColor,
                        giveLinesAsText: true,
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () => provider.loadPosts(refresh: true),
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: getHeight() * .03),
                      itemCount: provider.posts.length + (provider.hasMorePosts ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == provider.posts.length) {
                          provider.loadPosts();
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return PostCard(post: provider.posts[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        backgroundColor: AppColors.getPrimaryColorFromContext(context),
        onPressed: () => context.push(Routes.restaurantCreatePostRoute),
        label: Row(
          children: [
            const Icon(Icons.add, color: Colors.white),
            CustomText(
              text: "Create",
              fontSize: sizes?.fontSize12,
              fontFamily: Assets.onsetMedium,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
