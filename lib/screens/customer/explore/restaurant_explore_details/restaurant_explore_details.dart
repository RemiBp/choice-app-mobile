import 'package:choice_app/screens/customer/explore/book_now/book_now_view.dart';
import 'package:choice_app/screens/customer/explore/full_menu/full_menu_view.dart';
import 'package:choice_app/screens/customer/explore/participants/participants_screen.dart';
import 'package:choice_app/screens/customer/explore/restaurant_explore_details/restaurant_explore_widgets.dart';
import 'package:choice_app/screens/customer/explore/customer_gallery/customer_gallery_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';
import '../../../../appAssets/app_assets.dart';
import '../../../../appColors/colors.dart';
import '../../../../customWidgets/custom_button.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../customWidgets/shadow_icon.dart';
import '../../../../res/res.dart';
import '../../../onboarding/menu/menu_widgets.dart';
import '../../../restaurant/profile_menu/profile_menu_widgets.dart';

class RestaurantExploreDetails extends StatefulWidget {
  final String tag;
  const RestaurantExploreDetails({super.key, required this.tag});

  @override
  State<RestaurantExploreDetails> createState() => _RestaurantExploreDetailsState();
}

class _RestaurantExploreDetailsState extends State<RestaurantExploreDetails> {

  Color getTagColor() {
    switch (widget.tag.toLowerCase()) {
      case "restaurant":
        return AppColors.restaurantPrimaryColor;
      case "wellness":
        return AppColors.wellnessPrimaryColor;
      case "leisure":
        return AppColors.leisurePrimaryColor;
      default:
        return AppColors.userPrimaryColor;
    }
  }

  final List<MenuGroup> menuGroups = [
    MenuGroup(
      title: 'Brochettes',
      dishes: List.generate(3, (_) => Dish(name: 'Al Salmone', description: 'Sauce blanche, saumon fume', price: 20)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                context.push('/customer_gallery', extra: '3');
              },
              child: ExploreEventHeader(),
            ),
            SizedBox(height: getHeight() * 0.02),

            Row(
              children: [
                EventTag(
                  margin: EdgeInsets.only(left: sizes!.pagePadding, right: getWidth() * 0.02),
                ),
                EventTag(
                  text: widget.tag,
                  color: getTagColor(),
                ),
              ],
            ),
            SizedBox(height: getHeight() * 0.02),


            Padding(
              padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
              child: CustomText(
                text: "Flavors of the Season",
                fontSize: sizes?.fontSize20,
                fontFamily: Assets.onsetSemiBold,
              ),
            ),
            SizedBox(height: getHeight() * 0.02),
            IconTextWidget(
              text: "Monday, June 28, 2025 ",
              icon: Assets.calender,
              subText: "08:00 PM - 11:00 PM",
              color: getTagColor(),
            ),
            SizedBox(height: getHeight() * 0.01),
            IconTextWidget(
              text: "Gustave Eiffel, Paris, France",
              icon: Assets.restaurantLocationIcon,
              subText: " Av. Gustave Eiffel, 75007 Paris, France",
              color: getTagColor(),
            ),

            SizedBox(height: getHeight() * 0.01),
            IconTextWidget(
              text: "Gustave Eiffel, Paris, France",
              icon: Assets.ticketIcon,
              subText: " Av. Gustave Eiffel, 75007 Paris, France",
              color: getTagColor(),
            ),

            Divider(color: AppColors.greyColor,),
            SizedBox(height: getHeight() * 0.01),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Participants",
                    fontSize: sizes?.fontSize16,
                    fontFamily: Assets.onsetSemiBold,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push('/participants');
                    },
                    child: CustomText(
                      text: "Show All",
                      fontSize: sizes?.fontSize14,
                      fontFamily: Assets.onsetMedium,
                      color: getTagColor(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: getHeight() * 0.01),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
              child: Row(
                children: [
                  Stack(
                    children: [
                      const SizedBox(width: 100),
                      CircleAvatar(backgroundColor: Colors.transparent),
                      Positioned(
                        right: 60,
                        child: _buildAvatar(
                          'https://randomuser.me/api/portraits/women/65.jpg',
                        ),
                      ),
                      Positioned(
                        right: 60,
                        child: _buildAvatar(
                          'https://randomuser.me/api/portraits/women/65.jpg',
                        ),
                      ),
                      Positioned(
                        right: 40,
                        child: _buildAvatar(
                          'https://randomuser.me/api/portraits/women/60.jpg',
                        ),
                      ),
                      Positioned(
                        right: 20,
                        child: _buildAvatar(
                          'https://randomuser.me/api/portraits/men/62.jpg',
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: _buildAvatarCircle('+10'),
                      ),
                    ],
                  ),
                  Spacer(),
                  SvgPicture.asset(Assets.peopleIcon),
                  CustomText(text: " 10/120", fontSize: sizes?.fontSize12),
                ],
              ),
            ),
            if(widget.tag == "restaurant")
            Divider(color: AppColors.greyColor,),
            if(widget.tag == "restaurant")
            SizedBox(height: getHeight() * 0.01),
            if(widget.tag == "restaurant")
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
              child: MenuGroupWidget(
                menuGroup: menuGroups[0],
                header: "Menu",
                optionText: "See Full Menu",
                hideBorder: true,
                onAddDish: () {
                context.push('/full_menu');
              },
              ),
            ),
            Divider(color: AppColors.greyColor,),
            SizedBox(height: getHeight() * 0.01),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
              child: CustomText(
                text: "About Event",
                fontSize: sizes?.fontSize16,
                fontFamily: Assets.onsetSemiBold,
              ),
            ),
            SizedBox(height: getHeight() * 0.01),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
              child: ReadMoreText(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nisi viverra mauris sagittis dis. Sed quis enim nulla arcu turpis in.",
                trimMode: TrimMode.Line,
                trimLines: 2,
                colorClickableText: Colors.pink,
                trimCollapsedText: 'Read More',
                trimExpandedText: 'See Less',
                style: TextStyle(
                  fontSize: sizes?.fontSize16,
                  color: AppColors.blackColor,
                ),
                moreStyle: TextStyle(
                  fontSize: sizes?.fontSize14,
                  color: getTagColor(),
                  fontFamily: Assets.onsetMedium,
                ),
              ),
            ),


            SizedBox(height: getHeight() * 0.01),
            Divider(color: AppColors.greyColor),
            SizedBox(height: getHeight() * 0.01),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
              child: CustomText(
                text: "Location",
                fontSize: sizes?.fontSize16,
                fontFamily: Assets.onsetSemiBold,
              ),
            ),
            SizedBox(height: getHeight() * 0.01),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
              child: CustomText(
                text: " Av. Gustave Eiffel, 75007 Paris, France",
                fontSize: sizes?.fontSize12,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
              child: Image.asset(Assets.mapImage, height: getHeight() * .2),
            ),


            SizedBox(height: getHeight() * 0.01),
            Divider(color: AppColors.greyColor),
            SizedBox(height: getHeight() * 0.01),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
              child: CustomText(
                text: "Socia Links",
                fontSize: sizes?.fontSize16,
                fontFamily: Assets.onsetSemiBold,
              ),
            ),
            SizedBox(height: getHeight() * 0.01),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
              child: Row(
                children: [
                  ShadowIcon(
                    icon: Assets.websiteIcon,
                    color: getTagColor(),
                  ),
                  SizedBox(width: getWidth() * 0.02),
                  ShadowIcon(
                    icon: Assets.instagramIcon,
                    color: getTagColor(),
                  ),
                  SizedBox(width: getWidth() * 0.02),
                  ShadowIcon(
                    icon: Assets.xIcon,
                    color: getTagColor(),
                  ),
                  SizedBox(width: getWidth() * 0.02),
                  ShadowIcon(
                    icon: Assets.facebookIcon,
                    color: getTagColor(),
                  ),
                ],
              ),
            ),

            SizedBox(height: getHeight() * 0.01),
            Divider(color: AppColors.greyColor),
            SizedBox(height: getHeight() * 0.01),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
              child: CustomText(
                text: "Organizer",
                fontSize: sizes?.fontSize16,
                fontFamily: Assets.onsetSemiBold,
              ),
            ),
            SizedBox(height: getHeight() * 0.01),
            OrganizerTile(color: getTagColor()),
            SizedBox(height: getHeight() * 0.01),
            Divider(color: AppColors.greyColor),
            SizedBox(height: getHeight() * 0.01),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "More Events Like This",
                    fontSize: sizes?.fontSize16,
                    fontFamily: Assets.onsetSemiBold,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: CustomText(
                      text: "Show All",
                      fontSize: sizes?.fontSize14,
                      fontFamily: Assets.onsetMedium,
                      color: getTagColor(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: getHeightRatio() * 230,
              child: ListView.builder(
                padding: EdgeInsets.only(left: getWidth() * 0.06, right: getWidth() * 0.03),
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: getWidthRatio() * 280,
                    child: FavouriteRestaurantCard(
                      imageUrl: "https://images.unsplash.com/photo-1528605248644-14dd04022da1",
                      restaurantName: "Restaurant ${index + 1}",
                      address: "123 Main Street, City",
                      isFavourite: index % 2 == 0,
                      margin: EdgeInsets.only(top: getHeightRatio() * 8, bottom: getHeightRatio() * 8, right: getWidth() * 0.03),
                      onFavouriteTap: () {},
                      onRestaurantTap: () {},
                    ),
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06, vertical: getHeight() * 0.02),
              color: AppColors.whiteColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Ticket Price",
                        fontSize: sizes?.fontSize12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.inputHintColor,
                      ),
                      Row(
                        children: [
                          CustomText(
                            text: "\$30.00",
                            fontSize: sizes?.fontSize16,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                          CustomText(
                            text: "/per person",
                            fontSize: sizes?.fontSize14,
                            color: AppColors.inputHintColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 160,
                    height: 48,
                    child: CustomButton(
                      buttonText: 'Book Now',
                      onTap: () {
                        context.push('/book_now');
                      },
                      backgroundColor: AppColors.userPrimaryColor,
                      borderColor: Colors.transparent,
                      textColor: Colors.white,
                      textFontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String imageUrl) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.white,
      child: CircleAvatar(radius: 14, backgroundImage: NetworkImage(imageUrl)),
    );
  }

  Widget _buildAvatarCircle(String text) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 14,
        backgroundColor: Colors.grey.shade400,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
