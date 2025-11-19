import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../l18n.dart';
import '../../../res/res.dart';
import '../../../userRole/role_provider.dart';
import '../../../userRole/user_role.dart';

class WeeklyRatingsChartCard extends StatelessWidget {
  WeeklyRatingsChartCard({super.key});
  final List<String> xLabels = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  // Example ratings data for each day
  final List<FlSpot> weeklyRatings = [
    FlSpot(0, 3.5),
    FlSpot(1, 4.0),
    FlSpot(2, 2.8),
    FlSpot(3, 4.5),
    FlSpot(4, 3.0),
    FlSpot(5, 4.2),
    FlSpot(6, 3.8),
  ];
  late UserRole role;
  @override
  Widget build(BuildContext context) {
    role = context.read<RoleProvider>().role;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getWidthRatio() * 16,
        vertical: getHeightRatio() * 12,
      ),
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
      child: Column(
        children: [
          /// Title only (no dropdown)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                text:
                    role == UserRole.restaurant
                        ? al.weeklyRatings
                        : al.weeklyEvolution,
                fontSize: sizes?.fontSize14,
                fontWeight: FontWeight.w500,
                color: AppColors.primarySlateColor,
              ),
            ],
          ),
          SizedBox(height: getHeightRatio() * 16),

          SizedBox(
            height: getHeight() * 0.3,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 5,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    bottom: BorderSide(color: AppColors.greyBordersColor),
                    left: BorderSide(color: AppColors.greyBordersColor),
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: getWidth() * 0.08,
                      getTitlesWidget: (value, meta) {
                        if (value < 0 || value > 5) {
                          return const SizedBox.shrink();
                        }
                        return CustomText(
                          text: value.toStringAsFixed(1),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: getHeight() * 0.05,
                      getTitlesWidget: (value, meta) {
                        final labels = [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun',
                        ];
                        final index = value.toInt();

                        if (index < 0 || index >= labels.length) {
                          return const SizedBox.shrink();
                        }

                        return SideTitleWidget(
                          meta: meta,
                          child: Transform.translate(
                            offset: Offset(
                              index == 0
                                  ? 7
                                  : (index == labels.length - 1
                                      ? -7
                                      : 0), // push Mon right, Sun left
                              0,
                            ),
                            child: CustomText(
                              text: labels[index],
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: AppColors.restaurantPrimaryColor,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.orangeWithOpacity,
                          AppColors.orangeTransparent,
                        ],
                      ),
                    ),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: getWidthRatio() * 5,
                          color: AppColors.restaurantPrimaryColor,
                        );
                      },
                    ),
                    spots: weeklyRatings,
                    barWidth: getWidthRatio() * 2,
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => AppColors.greyColor,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((touchedSpot) {
                        return LineTooltipItem(
                          '${touchedSpot.y.toStringAsFixed(1)} ★',
                          const TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        );
                      }).toList();
                    },
                  ),
                  handleBuiltInTouches: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
