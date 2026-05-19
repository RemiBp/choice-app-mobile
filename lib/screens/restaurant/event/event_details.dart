import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';
import '../../../appAssets/app_assets.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_button.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../res/res.dart';
import 'eventWidgets/delete_event.dart';
import 'eventWidgets/event_info.dart';

class EventDetails extends StatelessWidget {
  const EventDetails({super.key,});

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final isDraft = extra?["isDraft"]??false;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: getHeight() * .33,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://i.pinimg.com/originals/49/7e/e8/497ee84d017ffca00fd23bf78d3ebe39.jpg",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: getHeight() * .06,
                  left: 16,
                  child: IconButton.filled(
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.white30,
                    ),
                    onPressed: () {
                      context.pop();
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "1/5",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            EventInfoSection(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getWidth() * .05,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: getHeight() * .01),
                  Divider(color: AppColors.greyColor),
                  SizedBox(height: getHeight() * .02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "Participants",
                        fontSize: sizes?.fontSize16,
                        fontFamily: Assets.onsetSemiBold,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: CustomText(
                          text: "Show All",
                          fontSize: sizes?.fontSize14,
                          fontFamily: Assets.onsetMedium,
                          color: AppColors.getPrimaryColorFromContext(context),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Stack(
                        children: [
                          const SizedBox(width: 120),
                          const CircleAvatar(backgroundColor: Colors.transparent),
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
                  SizedBox(height: getHeight() * .01),
                  Divider(color: AppColors.greyColor),
                  SizedBox(height: getHeight() * .02),
                  CustomText(
                    text: "About Event",
                    fontSize: sizes?.fontSize16,
                    fontFamily: Assets.onsetSemiBold,
                  ),
                  SizedBox(height: getHeight() * .02),
                  ReadMoreText(
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
                      color: AppColors.getPrimaryColorFromContext(context),
                      fontFamily: Assets.onsetMedium,
                    ),
                  ),
                  SizedBox(height: getHeight() * .01),
                  Divider(color: AppColors.greyColor),
                  SizedBox(height: getHeight() * .02),
                  CustomText(
                    text: "Location",
                    fontSize: sizes?.fontSize16,
                    fontFamily: Assets.onsetSemiBold,
                  ),
                  CustomText(
                    text: " Av. Gustave Eiffel, 75007 Paris, France",
                    fontSize: sizes?.fontSize12,
                  ),
                  Image.asset(Assets.mapImage, height: getHeight() * .2),
                  SizedBox(height: getHeight() * .01),
                  Divider(color: AppColors.greyColor),
                  SizedBox(height: getHeight() * .02),
                  CustomText(
                    text: "Socia Links",
                    fontSize: sizes?.fontSize16,
                    fontFamily: Assets.onsetSemiBold,
                  ),
                  SizedBox(height: getHeight() * .01),
                  Row(
                    children: [
                      SvgPicture.asset(Assets.webCircleIcon),
                      SvgPicture.asset(Assets.instaCircleIcon),
                      SvgPicture.asset(Assets.xCircleIcon),
                      SvgPicture.asset(Assets.facebookCircleIcon),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: getHeight() * .02),
            isDraft
                ? Padding(
              padding: EdgeInsets.symmetric(
                vertical: getHeight() * .02,
                horizontal: getWidth() * .05,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      height: getHeight() * .055,
                      backgroundColor: Colors.transparent,
                      buttonText: "Delete",
                      textColor: Colors.red,
                      borderColor: Colors.red,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return DeleteEventDialog();
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      height: getHeight() * .055,
                      buttonText: "Edit",
                      onTap: () {
                        context.push('/restaurant_create_events', extra: extra);
                      },
                    ),
                  ),
                ],
              ),
            )
                : const SizedBox.shrink(),
            SizedBox(height: getHeight() * .02),
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
