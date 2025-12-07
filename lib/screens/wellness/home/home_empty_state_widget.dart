import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../appAssets/app_assets.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../res/res.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Background Circle
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.getPrimaryColorFromContext(context).withValues(alpha: 0.2),
            ),
            child: Center(
              child: SvgPicture.asset(
                Assets.peopleIcon,
                height: 48,
                width: 48,
                colorFilter: ColorFilter.mode(AppColors.getPrimaryColorFromContext(context),BlendMode.srcIn),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Title
          CustomText(
            text: "Nothing here yet",
            fontSize: sizes?.fontSize18,
            fontFamily: Assets.onsetSemiBold,
            fontWeight: FontWeight.w600,
          ),

          const SizedBox(height: 8),

          // Subtitle
          CustomText(
            text:
            "Looks like you haven’t followed anyone. Find people you like and see what they’re up to.",
            fontSize: sizes?.fontSize16,
            fontWeight: FontWeight.w500,
            fontFamily: Assets.onsetMedium,
            textAlign: TextAlign.center,
            giveLinesAsText: true,
          ),
        ],
      ),
    );
  }
}
