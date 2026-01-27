import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../res/res.dart';
import '../../../appAssets/app_assets.dart';
import 'dashboard_provider.dart';

class RatingsByThemeCard extends StatelessWidget {
  const RatingsByThemeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(getHeightRatio() * 16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.greyBordersColor.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withOpacity(0.05),
            blurRadius: 24,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          final ratingsData = provider.ratings?['ratings'] as List<dynamic>? ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Ratings by Experience Theme',
                fontSize: sizes?.fontSize16,
                fontFamily: Assets.onsetSemiBold,
                color: AppColors.blackColor,
              ),
              SizedBox(height: getHeightRatio() * 20),
              if (ratingsData.isEmpty)
                Center(child: CustomText(text: "No rating breakdown available", color: AppColors.textGreyColor))
              else
                ...ratingsData.map((item) {
                  final label = item['criteria'] ?? 'N/A';
                  final value = double.tryParse(item['average']?.toString() ?? '0.0') ?? 0.0;
                  
                  return Padding(
                    padding: EdgeInsets.only(bottom: getHeightRatio() * 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: label,
                              fontWeight: FontWeight.w500,
                              fontSize: sizes?.fontSize12,
                              color: AppColors.blackColor,
                            ),
                            CustomText(
                              text: value.toStringAsFixed(1),
                              fontWeight: FontWeight.w600,
                              fontSize: sizes?.fontSize12,
                              color: AppColors.restaurantPrimaryColor,
                            )
                          ],
                        ),
                        SizedBox(height: 8),
                        Stack(
                          children: [
                            Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: AppColors.greyColor.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: (value / 5.0).clamp(0.0, 1.0),
                              child: Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  color: AppColors.restaurantPrimaryColor,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}
