import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../appColors/colors.dart';
import '../../../common/utils.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l18n.dart';
import '../../../res/res.dart';
import '../../../userRole/role_provider.dart';
import '../../../userRole/user_role.dart';
import 'home_view.dart';

class RatingsByThemeCard extends StatelessWidget {
  const RatingsByThemeCard({super.key});

  List<Map<String, dynamic>> _getChartData(UserRole role, AppLocalizations al) {
    if (role == UserRole.restaurant) {
      return [
        {al.label: al.service, al.value: 4.2},
        {al.label: al.place, al.value: 3.5},
        {al.label: al.ambiance, al.value: 3.8},
      ];
    } else if (role == UserRole.leisure) {
      return [
        {al.label: al.sound, al.value: 4.2},
        {al.label: al.length, al.value: 3.5},
        {al.label: al.welcome, al.value: 3.8},
      ];
    } else if (role == UserRole.wellness) {
      return [
        {al.label: al.cleanliness, al.value: 4.2},
        {al.label: al.staffExpertise, al.value: 3.5},
        {al.label: al.ambiance, al.value: 3.8},
      ];
    } else {
      // Default fallback for any unknown roles
      return [
        {al.label: al.service, al.value: 4.0},
        {al.label: al.value, al.value: 3.6},
      ];
    }
  }
  @override
  Widget build(BuildContext context) {
    final al = AppLocalizations.of(context)!;
    final role = context.read<RoleProvider>().role;
    final data = _getChartData(role, al);

    return Container(
      padding: EdgeInsets.all(getHeightRatio() * 16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.05),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              text: role == UserRole.restaurant
                  ? al.ratingsByExperienceTheme
                  : role == UserRole.leisure
                  ? al.ratingsByTheme
                  : al.criteriaRatings,
              fontSize: sizes?.fontSize14,
              fontWeight: FontWeight.w500,
              color: AppColors.primarySlateColor,
            ),
          ),
          SizedBox(height: getHeightRatio() * 16),
          ...data.map((item) {
            return Padding(
              padding: EdgeInsets.only(bottom: getHeightRatio() * 12),
              child: Row(
                children: [
                  SizedBox(
                    width: getWidthRatio() * 80,
                    child: CustomText(
                      text: item[al.label],
                      fontWeight: FontWeight.w500,
                      fontSize: sizes?.fontSize12,
                      color: AppColors.blackColor,
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          height: getHeight() * 0.02,
                          decoration: BoxDecoration(
                            color: AppColors.greyColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: (item[al.value] ?? 0) / 5.0,
                          child: Container(
                            height: getHeight() * 0.02,
                            decoration: BoxDecoration(
                              color: AppColors.vibrantBlue,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: getWidthRatio() * 12),
                  CustomText(
                    text: item[al.value].toString(),
                    fontWeight: FontWeight.w500,
                    fontSize: sizes?.fontSize12,
                    color: AppColors.blackColor,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}