import 'package:choice_app/screens/restaurant/profile_menu/profile_menu_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readmore/readmore.dart';
import '../../../../appAssets/app_assets.dart';
import '../../../../appColors/colors.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../l18n.dart';
import '../../../../res/res.dart';
import '../../../customer/explore/customer_gallery/customer_gallery_screen.dart';
import '../../../customer/explore/full_menu/full_menu_view.dart';
import '../../../onboarding/gallery/gallery_widgets.dart';
import '../../../onboarding/menu/menu_widgets.dart';

class RestaurantAboutView extends StatefulWidget {
  const RestaurantAboutView({super.key});

  @override
  State<RestaurantAboutView> createState() => _RestaurantAboutViewState();
}

class _RestaurantAboutViewState extends State<RestaurantAboutView> {

  final List<Map<String, String>> operatingHours = [
    {'day': 'Monday', 'time': '09:00 AM - 05:00 PM'},
    {'day': 'Tuesday', 'time': '10:00 AM - 06:00 PM'},
    {'day': 'Wednesday', 'time': '11:00 AM - 07:00 PM'},
    {'day': 'Thursday', 'time': '09:30 AM - 05:30 PM'},
    {'day': 'Friday', 'time': '09:00 AM - 04:00 PM'},
    {'day': 'Saturday', 'time': 'Closed'},
    {'day': 'Sunday', 'time': 'Closed'},
  ];

  final List<MenuGroup> menuGroups = [
    MenuGroup(
      title: 'Brochettes',
      dishes: List.generate(3, (_) => Dish(name: 'Al Salmone', description: 'Sauce blanche, saumon fume', price: 20)),
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getHeight() * .02),
            CustomText(
              text: al.about,
              fontSize: sizes?.fontSize16,
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
            ),
            SizedBox(height: getHeight() * .01),
            ReadMoreText(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nisi viverra mauris sagittis dis. Sed quis enim nulla arcu turpis in.",
              trimMode: TrimMode.Line,
              trimLines: 2,
              colorClickableText: Colors.pink,
              trimCollapsedText: al.readMore,
              trimExpandedText: al.seeLess,
              style: TextStyle(
                fontSize: sizes?.fontSize16,
                color: AppColors.blackColor,
              ),
              moreStyle: TextStyle(
                fontSize: sizes?.fontSize14,
                color: AppColors.getPrimaryColorFromContext(context),
                fontFamily: Assets.onsetMedium,
              ),
            ),
            Divider(color: AppColors.greyBordersColor,height: getHeight() * .03),

            MenuGroupWidget(
              menuGroup: menuGroups[0],
              header: al.menu,
              optionText: al.seeFullMenu,
              onAddDish: (){
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => FullMenuView()),
                // );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: al.gallery,
                  fontSize: sizes?.fontSize16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ImageGalleryScreen(restaurantId: "3",)),
                    );
                  },
                  child: CustomText(
                    text: al.seeFullGallery,
                    fontSize: sizes?.fontSize14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.getPrimaryColorFromContext(context),
                  ),
                ),
              ],
            ),
            SizedBox(height: getHeight() * .01),
            SizedBox(
              height: getHeight() * 0.12,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: getWidth() * 0.02),
                    child: Container(
                        height: getHeight() * 0.12,
                        width: getWidth() * 0.26,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Image.asset(
                          Assets.galleryImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: AppColors.getPrimaryColorFromContext(context),
                          ),
                        )
                    ),
                  );
                },
              ),
            ),

            Divider(color: AppColors.greyBordersColor,height: getHeight() * .03),
            CustomText(
              text: al.location,
              fontSize: sizes?.fontSize16,
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
            ),
            SizedBox(height: getHeight() * .01),
            CustomText(
              text: " Av. Gustave Eiffel, 75007 Paris, France",
              fontSize: sizes?.fontSize12,
            ),
            Image.asset(Assets.mapImage, height: getHeight() * .2),
            SizedBox(height: getHeight() * .01),
            Divider(color: AppColors.greyColor),
            SizedBox(height: getHeight() * .02),
            CustomText(
              text: al.businessHours,
              fontSize: sizes?.fontSize16,
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
            ),
            // SizedBox(height: getHeight() * .01),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: operatingHours.length,
              itemBuilder: (context, index) {
                return OperatingHourItem(
                  day: operatingHours[index]["day"]??"",
                  time: operatingHours[index]["time"]??"",
                );
              },
            ),
            SizedBox(height: getHeight() * .02),
            CustomText(
              text: al.socialLinks,
              fontSize: sizes?.fontSize16,
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
            ),
            SizedBox(height: getHeight() * .01),
            Row(
              children: [
                CircleAvatar(
                    radius: getHeight() * .03,
                    backgroundColor: AppColors.getPrimaryColorFromContext(context).withAlpha(20),
                    child: SvgPicture.asset(
                      Assets.websiteIcon,
                      height: getHeight() * .03,
                      color: AppColors.getPrimaryColorFromContext(context),
                    )
                  // : null,
                ),
                SizedBox(width: getWidth() * 0.015),
                CircleAvatar(
                    radius: getHeight() * .03,
                    backgroundColor: AppColors.getPrimaryColorFromContext(context).withAlpha(20),
                    child: SvgPicture.asset(
                      Assets.instagramIcon,
                      height: getHeight() * .03,
                      color: AppColors.getPrimaryColorFromContext(context),
                    )
                  // : null,
                ),
                SizedBox(width: getWidth() * 0.015),
                CircleAvatar(
                    radius: getHeight() * .03,
                    backgroundColor: AppColors.getPrimaryColorFromContext(context).withAlpha(20),
                    child: SvgPicture.asset(
                      Assets.xIcon,
                      height: getHeight() * .03,
                      color: AppColors.getPrimaryColorFromContext(context),
                    )
                  // : null,
                ),
                SizedBox(width: getWidth() * 0.015),
                CircleAvatar(
                    radius: getHeight() * .03,
                    backgroundColor: AppColors.getPrimaryColorFromContext(context).withAlpha(20),
                    child: SvgPicture.asset(
                      Assets.facebookIcon,
                      height: getHeight() * .03,
                      color: AppColors.getPrimaryColorFromContext(context),
                    )
                  // : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
