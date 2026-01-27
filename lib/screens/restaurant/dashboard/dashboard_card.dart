import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../appAssets/app_assets.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../res/res.dart';
import '../../../userRole/role_provider.dart';
import '../../../userRole/user_role.dart';

class DashboardCard extends StatelessWidget {
  final String? header;
  final String? price;
  final String? duration;
  final bool? hideDetailText;
  final double? width;
  final String? percentage;
  const DashboardCard({super.key, this.price, this.header, this.percentage, this.width, this.duration, this.hideDetailText});

  @override
  Widget build(BuildContext context) {
    final role = context.read<RoleProvider>().role;
    return Container(
      padding: EdgeInsets.all(20),
      width: width,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.greyBordersColor.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withOpacity(0.03), 
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: header??'Profile Views',
            fontSize: sizes?.fontSize14,
            fontWeight: FontWeight.w500,
            color: AppColors.textGreyColor, // Softer color
          ),
          SizedBox(height: 10),
          CustomText(
            text: price??'932',
            fontSize: sizes?.fontSize24, // Bigger number
            fontFamily: Assets.onsetBold,
            color: AppColors.blackColor,
          ),
          if(!(role == UserRole.restaurant))
          SizedBox(height: 10),
          if(!(role == UserRole.restaurant))
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                 padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                 decoration: BoxDecoration(
                   color: AppColors.wellnessPrimaryColor.withOpacity(0.1),
                   borderRadius: BorderRadius.circular(6)
                 ),
                 child: CustomText(
                  text: percentage??'+16%',
                  fontSize: sizes?.fontSize12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.wellnessPrimaryColor,
                ),
              ),
              SizedBox(width: 8),
              CustomText(
                text: 'vs ${duration??"Last Week"}',
                fontSize: sizes?.fontSize12,
                fontWeight: FontWeight.w400,
                color: AppColors.textGreyColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MostChosenDishCard extends StatelessWidget {
  final String? header;
  final String? price;
  final String? duration;
  final String? percentage;
  const MostChosenDishCard({super.key, this.price, this.header, this.percentage, this.duration});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.greyBordersColor.withOpacity(0.5)),
        boxShadow: [
           BoxShadow(
            color: AppColors.blackColor.withOpacity(0.03),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: header??'Most Chosen',
                  fontSize: sizes?.fontSize14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primarySlateColor,
                ),
                SizedBox(height: 8),
                CustomText(
                  text: price??'Crème Brûlée',
                  fontSize: sizes?.fontSize20,
                  fontFamily: Assets.onsetBold, // Bold font
                  color: AppColors.blackColor,
                ),
                SizedBox(height: 8),
                 RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Chosen ',
                        style: TextStyle(
                          fontSize: sizes?.fontSize12,
                          color: AppColors.primarySlateColor,
                          fontFamily: Assets.onsetRegular,
                        ),
                      ),
                      TextSpan(
                        text: percentage ?? '88 ',
                        style: TextStyle(
                          fontSize: sizes?.fontSize12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.wellnessPrimaryColor,
                          fontFamily: Assets.onsetRegular,
                        ),
                      ),
                      TextSpan(
                        text: 'times this week',
                        style: TextStyle(
                          fontSize: sizes?.fontSize12,
                          color: AppColors.primarySlateColor,
                          fontFamily: Assets.onsetRegular,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          
          // Add a decorative icon/badge maybe?
          CircleAvatar(
             radius: 20,
             backgroundColor: AppColors.restaurantPrimaryColor.withOpacity(0.1),
             child: Icon(Icons.restaurant_menu, color: AppColors.restaurantPrimaryColor, size: 20),
          )
        ],
      ),
    );
  }
}
