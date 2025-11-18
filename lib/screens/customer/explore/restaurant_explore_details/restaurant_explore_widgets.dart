import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../appAssets/app_assets.dart';
import '../../../../appColors/colors.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../customWidgets/shadow_icon.dart';
import '../../../../l18n.dart';
import '../../../../res/res.dart';


class ExploreEventHeader extends StatelessWidget {
  const ExploreEventHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
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
    );
  }
}

class EventTag extends StatelessWidget {
  final Color? color;
  final String? text;
  final EdgeInsetsGeometry? margin;
  const EventTag({super.key, this.color, this.text, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin??EdgeInsets.zero,
      padding: EdgeInsets.symmetric(
        horizontal: getWidth() * 0.035,
        vertical: getHeight() * 0.01,
      ),
      decoration: BoxDecoration(
        color: (color??AppColors.redColor).withAlpha(40),
        borderRadius: BorderRadius.circular(40),
      ),
      child: CustomText(
        text: text??al.event,
        fontSize: sizes?.fontSize12,
        fontWeight: FontWeight.w500,
        color: color??AppColors.redColor,
      ),
    );
  }
}



class IconTextWidget extends StatelessWidget {
  const IconTextWidget({
    super.key,
    required this.text,
    required this.icon,
    required this.subText,
    this.color
  });

  final String text;
  final String subText;
  final String icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
      child: Row(
        children: [
          ShadowIcon(
            icon: icon,
            color: color,
          ),
          SizedBox(width: getWidth() * 0.02),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: text,
                fontSize: sizes?.fontSize14,
                fontFamily: Assets.onsetMedium,
              ),
              CustomText(text: subText, fontSize: sizes?.fontSize12),
            ],
          ),
        ],
      ),
    );
  }
}


class OrganizerTile extends StatelessWidget {
  final Color color;
  const OrganizerTile({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
      child: Row(
        children: [
          CircleAvatar(
            radius: getHeight() * 0.03,
            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1502685104226-ee32379fefbe?fit=crop&w=200&q=80'),
          ),
          SizedBox(width: getWidth() * 0.02),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'The Wholesome Fork',
                  fontWeight: FontWeight.w500,
                  fontSize: sizes?.fontSize14,
                  color: AppColors.blackColor,
                ),
                CustomText(
                  text: 'Organize Team',
                  fontWeight: FontWeight.w400,
                  fontSize: sizes?.fontSize14,
                  color: AppColors.primarySlateColor,
                ),
              ],
            ),
          ),
          ShadowIcon(
            icon: Assets.phoneIcon,
            color: color,
          ),
          SizedBox(width: getWidth() * 0.02),
          ShadowIcon(
            icon: Assets.messagesIcon,
            color: color,
          ),
        ],
      ),
    );
  }
}

class WellnessServiceTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;

  const WellnessServiceTile({
    super.key,
    required this.title,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.greyColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            // SERVICE NAME
            Expanded(
              child: CustomText(
                text: title,
                fontSize: 14,
                fontFamily: Assets.onsetMedium,
              ),
            ),

            SizedBox(width: 12),

            // RIGHT SIDE CIRCLE ICON (MATCHES YOUR SCREENSHOT)
            Container(
              height: 22,
              width: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColors.getPrimaryColorFromContext(context)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppColors.getPrimaryColorFromContext(context)
                      : AppColors.greyColor,
                  width: 2,
                ),
              ),

              child: isSelected
                  ? Icon(
                Icons.check,
                size: 14,
                color: Colors.white,
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
