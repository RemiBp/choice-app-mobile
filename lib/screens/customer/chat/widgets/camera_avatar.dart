import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../appAssets/app_assets.dart';
import '../../../../../appColors/colors.dart';
import '../../../../../res/res.dart';
import '../../../restaurant/profile/profile_widgets.dart';

class CameraAvatar extends StatelessWidget {
  const CameraAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => bottomSheet(context),
      child: Container(
        width: getHeight() * 0.08,
        height: getHeight() * 0.08,
        decoration: const BoxDecoration(
          color: AppColors.greyColor,
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(getHeight() * 0.02),
        child: SvgPicture.asset(Assets.cameraIcon),
      ),
    );
  }
}
