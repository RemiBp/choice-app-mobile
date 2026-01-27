import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../appAssets/app_assets.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../res/res.dart';
import '../../../userRole/role_provider.dart';
import '../../../userRole/user_role.dart';
import '../../../routes/routes.dart';
import 'package:go_router/go_router.dart';

class UserOriginMapCard extends StatelessWidget {
  const UserOriginMapCard({super.key});

  @override
  Widget build(BuildContext context) {
    final role = context.read<RoleProvider>().role;
    return Container(
      padding: EdgeInsets.all(getHeightRatio() * 16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withOpacity(0.05),
            blurRadius: 24,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'User Origin Map',
            fontSize: sizes?.fontSize14,
            fontWeight: FontWeight.w500,
            color: AppColors.primarySlateColor,
          ),
          SizedBox(height: getHeightRatio() * 16),
          GestureDetector(
            onTap: () => context.push(Routes.restaurantProducerMapRoute),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                Assets.originMapImage,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 180,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
