import 'package:choice_app/providers/producer_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../appAssets/app_assets.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../customWidgets/icon_svg.dart';
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
              offset: Offset(0, 0),
              blurRadius: 24,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: getHeightRatio() * 20,   // fixed visual size for ALL icons
              height: getHeightRatio() * 20,
              child: Center(
                child: SvgIcon(
                  leadingAssetPath,
                  width: getHeightRatio() * 16,   // actual drawing size
                  height: getHeightRatio() * 16,
                  color: AppColors.getPrimaryColorFromContext(context),
                ),
              ),
            ),
            // SvgIcon(
            //   leadingAssetPath,
            //   width: getWidthRatio() * 16,
            //   height: getHeightRatio() * 16,
            //   color: AppColors.getPrimaryColorFromContext(context),
            // ),
            SizedBox(
              width: getHeightRatio() * 12,
            ),
            Expanded(
                child: CustomText(
                  text: title,
                  lines: 1,
                  textOverflow: TextOverflow.ellipsis,
                  fontSize: sizes?.fontSize14,
                  color: textColor ?? AppColors.blackColor,
                  alignment: Alignment.centerLeft,
                  fontWeight: FontWeight.w500,
                )),
            if (showTrailingArrow)
              Icon(
                trailingIcon ?? Icons.arrow_forward_ios,
                size: getHeightRatio() * 15,
                color: arrowColor ?? AppColors.inputHintColor,
              )
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
    final profile = context.watch<ProducerProvider>().profile;
    final name = profile?['businessName'] as String? ??
        profile?['fullName'] as String? ??
        'My Profile';
    final email = profile?['email'] as String? ?? '';
    final avatarUrl = profile?['profileImage'] as String?;

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
          Row(
            children: [
              CircleAvatar(
                radius: getHeight() * .03,
                backgroundColor: AppColors.greyColor,
                backgroundImage:
                    avatarUrl != null ? NetworkImage(avatarUrl) : null,
                child: avatarUrl == null
                    ? SvgPicture.asset(
                        Assets.userIcon,
                        height: getHeight() * .02,
                        color: Colors.grey.shade600,
                      )
                    : null,
              ),
              SizedBox(width: getWidth() * 0.02),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: name,
                        fontSize: sizes?.fontSize14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blackColor,
                      ),
                      CustomText(
                        text: email,
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
                      text: "Create New Profile",
                      fontSize: sizes?.fontSize14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blackColor,
                    ),
                    CustomText(
                      text: "Switch between profile with one login",
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
