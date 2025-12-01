import 'package:choice_app/screens/customer/profile/customer_profile/customer_profile_provider.dart';
import 'package:choice_app/userRole/role_provider.dart';
import 'package:choice_app/userRole/user_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../appAssets/app_assets.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../customWidgets/icon_svg.dart';
import '../../../l18n.dart';
import '../../../res/res.dart';
import '../profile_menu/profile_menu_widgets.dart';

class ProfileOptionButton extends StatelessWidget {
  final String title;
  final String leadingAssetPath;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? textColor;
  final Color? arrowColor;
  final bool showTrailingArrow;
  final IconData? trailingIcon;

  final String? trailingText;
  final Color? trailingTextColor;

  const ProfileOptionButton({
    super.key,
    required this.title,
    required this.leadingAssetPath,
    this.onTap,
    this.iconColor,
    this.textColor,
    this.showTrailingArrow = true,
    this.arrowColor,
    this.trailingIcon,

    this.trailingText,
    this.trailingTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: getHeightRatio() * 52,
        padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.025),
        margin: EdgeInsets.only(bottom: getHeightRatio() * 12),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withAlpha(20),
              offset: const Offset(0, 0),
              blurRadius: 24,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- Leading Icon ---
            SvgIcon(
              leadingAssetPath,
              width: getWidthRatio() * 20,
              color: iconColor ?? AppColors.getPrimaryColorFromContext(context),
            ),

            SizedBox(width: getHeightRatio() * 12),

            // --- Title ---
            Expanded(
              child: CustomText(
                text: title,
                lines: 1,
                textOverflow: TextOverflow.ellipsis,
                fontSize: sizes?.fontSize14,
                color: textColor ?? AppColors.blackColor,
                alignment: Alignment.centerLeft,
                fontWeight: FontWeight.w500,
              ),
            ),

            // --- Optional trailing text (e.g. "Free Plan") ---
            if (trailingText != null)
              Padding(
                padding: EdgeInsets.only(right: getWidth() * 0.02),
                child: CustomText(
                  text: trailingText!,
                  fontSize: sizes?.fontSize12,
                  color: trailingTextColor ?? AppColors.inputHintColor,
                  fontWeight: FontWeight.w400,
                ),
              ),

            // --- Optional arrow icon ---
            if (showTrailingArrow)
              Icon(
                trailingIcon ?? Icons.arrow_forward_ios,
                size: getHeightRatio() * 15,
                color: arrowColor ?? AppColors.inputHintColor,
              ),
          ],
        ),
      ),
    );
  }
}

class SettingHeader extends StatelessWidget {
  final String? profileImage;
  const SettingHeader({super.key, this.profileImage});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProfileProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.025, vertical: getHeight() * 0.02),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withAlpha(20),
            blurRadius: 24,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          context
              .read<RoleProvider>()
              .role == UserRole.user ?
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                    provider.user?.profileImageUrl != null
                        ? provider.user!.profileImageUrl!
                        : "https://naushkinskoe-r81.gosweb.gosuslugi.ru/netcat_files/154/1671/image_3_0.jpg"),
              ),
              SizedBox(width: getWidth() * 0.02),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: provider.user?.fullName??"",
                      fontSize: sizes?.fontSize14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blackColor,
                    ),
                    CustomText(
                      text: provider.user?.email??"",
                      fontSize: sizes?.fontSize12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.inputHintColor,
                    )
                  ],
                ),
              ),
              SizedBox(width: getWidth() * 0.02),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return SwitchAccountBottomSheet(context: context);
                    },
                  );
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: AppColors.greyColor,
                      shape: BoxShape.circle
                  ),
                  child: Center(
                    child: Icon(Icons.keyboard_arrow_down_sharp,
                      color: AppColors.primarySlateColor,),
                  ),
                ),
              )
            ],
          ) :
          Row(
            children: [
              CircleAvatar(
                radius: getHeight() * .03,
                backgroundColor: AppColors.greyColor,
                // backgroundImage:
                // provider.profileImage != null
                //     ? FileImage(provider.profileImage!)
                //     : null,
                child:
                // provider.profileImage == null?
                SvgPicture.asset(
                  Assets.userIcon,
                  height: getHeight() * .02,
                  color: Colors.grey.shade600,
                )
                    // : null,
              ),
              SizedBox(width: getWidth() * 0.02),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "The Wholesome Fork",
                        fontSize: sizes?.fontSize14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blackColor,
                      ),
                      CustomText(
                        text: "example@thewholesomefork.com",
                        fontSize: sizes?.fontSize12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.inputHintColor,
                      )
                    ],
                  ),
              ),
              SizedBox(width: getWidth() * 0.02),
              GestureDetector(
                onTap: (){
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return SwitchAccountBottomSheet(context: context);
                    },
                  );
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.greyColor,
                    shape: BoxShape.circle
                  ),
                  child: Center(
                    child: Icon(Icons.keyboard_arrow_down_sharp, color: AppColors.primarySlateColor,),
                  ),
                ),
              )
            ],
          ),
          Divider(color: AppColors.greyBordersColor, height: getHeight() * 0.03),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: AppColors.getPrimaryColorFromContext(context).withAlpha(40),
                    shape: BoxShape.circle
                ),
                child: Center(
                  child: Icon(Icons.add, color: AppColors.getPrimaryColorFromContext(context),),
                ),
              ),
              SizedBox(width: getWidth() * 0.02),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: al.switchAccount,
                      fontSize: sizes?.fontSize14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blackColor,
                    ),
                    CustomText(
                      text: al.switchBetweenProfiles,
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
        ],
      ),
    );
  }
}
