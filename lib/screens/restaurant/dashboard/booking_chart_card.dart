
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../appAssets/app_assets.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../customWidgets/filter_drop_down.dart';
import '../../../l18n.dart';
import '../../../res/res.dart';
import '../../../userRole/role_provider.dart';
import '../../../userRole/user_role.dart';



// class BookingChartCard extends StatefulWidget {
//   const BookingChartCard({super.key});
//
//   @override
//   State<BookingChartCard> createState() => _BookingChartCardState();
// }
//
// class _BookingChartCardState extends State<BookingChartCard> {
//   String selectedRange = 'Last Week';
//   late HomeProvider homeProvider;
//
//   @override
//   void initState() {
//     super.initState();
//     homeProvider = Provider.of<HomeProvider>(context, listen: false);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       homeProvider.getBookingChartAPI(type: "lastWeek");
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<HomeProvider>(builder: (context, provider, child) {
//       final xLabels = provider.bookingChartResponse.chart?.labels ?? [];
//       final yValues = provider.bookingChartResponse.chart?.values ?? [];
//
//       return Container(
//         padding: EdgeInsets.symmetric(
//           horizontal: getWidthRatio() * 12,
//           vertical: getHeightRatio() * 12,
//         ),
//         decoration: BoxDecoration(
//           color: AppColors.textFieldColor,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Column(
//           children: [
//             Align(
//               alignment: Alignment.centerRight,
//               child: SizedBox(
//                 width: getWidth() * 0.3,
//                 height: getHeightRatio() * 36,
//                 child: FilterDropDown(
//                   items: const ['Last Week', 'Last Month'],
//                   hintText: 'Select Date Range',
//                   selectedValue: selectedRange,
//                   bfColor: AppColors.appColor,
//                   onChanged: (value) {
//                     if (value != null) {
//                       setState(() => selectedRange = value);
//                       final type = selectedRange == 'Last Week' ? 'lastWeek' : 'lastMonth';
//                       provider.getBookingChartAPI(type: type);
//                     }
//                   },
//                   validator: (value) => value == null ? 'Please select a date range' : null,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               height: getHeight() * 0.3,
//               child: provider.isBookingFetched
//                   ? Stack(
//                     children: [
//                       BarChart(
//                                       BarChartData(
//                       borderData: FlBorderData(
//                         show: true,
//                         border: const Border(
//                           bottom: BorderSide(color: AppColors.whiteColor),
//                           left: BorderSide(color: AppColors.whiteColor),
//                         ),
//                       ),
//                       gridData: const FlGridData(show: false),
//                       titlesData: FlTitlesData(
//                         leftTitles: AxisTitles(
//                           sideTitles: SideTitles(
//                             showTitles: true,
//                             reservedSize: getWidth() * 0.08,
//                             getTitlesWidget: (value, _) => CustomText(
//                               text: value.toInt().toString(),
//                               fontSize: sizes.fontSize12,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ),
//                         bottomTitles: AxisTitles(
//                           sideTitles: SideTitles(
//                             showTitles: true,
//                             reservedSize: getHeight() * 0.05,
//                             getTitlesWidget: (value, _) {
//                               int index = value.toInt();
//                               if (index >= 0 && index < xLabels.length) {
//                                 return Padding(
//                                   padding: EdgeInsets.only(top: getHeight() * 0.02),
//                                   child: CustomText(
//                                     text: xLabels[index],
//                                     fontSize: sizes.fontSize12,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 );
//                               }
//                               return const SizedBox.shrink();
//                             },
//                           ),
//                         ),
//                         topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                         rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                       ),
//                       barGroups: yValues.asMap().entries.map((entry) {
//                         final index = entry.key;
//                         final value = entry.value.toDouble();
//                         return BarChartGroupData(
//                           x: index,
//                           barRods: [
//                             BarChartRodData(
//                               toY: value,
//                               color: AppColors.ratingIconColor,
//                               width: getWidthRatio() * 18,
//                               borderRadius: BorderRadius.circular(2),
//                             ),
//                           ],
//                         );
//                       }).toList(),
//                       barTouchData: BarTouchData(
//                         touchTooltipData: BarTouchTooltipData(
//                           tooltipBgColor: AppColors.appColor,
//                         ),
//                       ),
//                       maxY: yValues.isNotEmpty ? yValues.reduce((a, b) => a > b ? a : b).toDouble() + 10 : 100,
//                       minY: 0,
//                                       ),
//                                     ),
//                       if (yValues.every((value) => value == 0))
//                         const NoChartDataWidget(),
//                     ],
//                   )
//                   : const Center(child: CircularProgressIndicator()),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }




class BookingChartCard extends StatefulWidget {
  const BookingChartCard({super.key});

  @override
  State<BookingChartCard> createState() => _BookingChartCardState();
}

class _BookingChartCardState extends State<BookingChartCard> {
  String selectedRange = al.category;


  List<String> xLabels = [];
  List<double> barData = [];
  late UserRole role;

  @override
  void initState() {
    super.initState();
    role = context.read<RoleProvider>().role;
    fetchChartData(selectedRange);
  }

  void fetchChartData(String range) {
    if (role == UserRole.restaurant) {
      _fetchRestaurantChartData(range);
    } else if (role == UserRole.leisure) {
      _fetchLeisureChartData(range);
    }
  }

  void _fetchRestaurantChartData(String range) {
    if (range == al.category) {
      xLabels = ['Bowl', 'Lasagna', 'Sushi', 'Burger', 'Ramen'];
      barData = [3.2, 3.5, 3.0, 3.3, 5.0];
    } else if (range == al.lastMonth) {
      xLabels = [al.week1, al.week2, al.week3, al.week4];
      barData = [2.5, 3.8, 4.1, 3.6];
    }
    setState(() {});
  }

  void _fetchLeisureChartData(String range) {
    if (range == al.category) {
      xLabels = ['Free', 'Discount', 'Full Price'];
      barData = [3.2, 3.5, 3.0];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getHeight() * 0.35,
      width: double.infinity,
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
            offset: const Offset(0, 0),
            blurRadius: 24,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: role == UserRole.restaurant
                    ? al.dishRating
                    : al.interestSplitByPriceType,
                fontSize: sizes?.fontSize14,
                fontFamily: Assets.onsetMedium,
                fontWeight: FontWeight.w500,
                color: AppColors.primarySlateColor,
              ),

              if (role == UserRole.restaurant)
                Container(
                  height: getHeight() * 0.042,
                  padding: EdgeInsets.symmetric(
                    horizontal: getWidthRatio() * 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.greyBordersColor, width: 0.8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedRange,
                          icon: const SizedBox.shrink(),
                          items: [al.category, al.lastMonth].map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: CustomText(
                                text: e,
                                fontSize: sizes?.fontSize12,
                                fontFamily: Assets.onsetMedium,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primarySlateColor,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => selectedRange = value);
                              fetchChartData(value);
                            }
                          },
                        ),
                      ),
                      SizedBox(width: getWidthRatio() * 4),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: AppColors.primarySlateColor,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: getHeightRatio() * 16),

          /// Chart
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                height: getHeight() * 0.3, // chart height stays consistent
                width: barData.length * getWidthRatio() * 70,
                child: BarChart(
                  BarChartData(
                    backgroundColor: AppColors.whiteColor,
                    borderData: FlBorderData(
                      show: true,
                      border: const Border(
                        bottom: BorderSide(color: AppColors.greyBordersColor),
                        left: BorderSide(color: AppColors.greyBordersColor),
                      ),
                    ),
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            if (value >= 0 && value <= 5) {
                              return CustomText(
                                text: value.toStringAsFixed(1),
                                fontSize: sizes?.fontSize12,
                                fontWeight: FontWeight.w400,
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() >= 0 &&
                                value.toInt() < xLabels.length) {
                              return Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: CustomText(
                                  text: xLabels[value.toInt()],
                                  fontSize: sizes?.fontSize12,
                                  fontWeight: FontWeight.w400,
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                      topTitles:
                      const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles:
                      const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    barGroups: barData.asMap().entries.map((entry) {
                      final index = entry.key;
                      final value = entry.value;
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: value,
                            color: AppColors.restaurantPrimaryColor,
                            width: getWidthRatio() * 18,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ],
                      );
                    }).toList(),
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (touchedSpot) => AppColors.greyColor,
                      ),
                      handleBuiltInTouches: true,
                    ),
                    maxY: 5.2,
                    minY: 0,
                    alignment: BarChartAlignment.spaceAround,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}







// class BookingChartCard extends StatefulWidget {
//   const BookingChartCard({super.key});
//
//   @override
//   State<BookingChartCard> createState() => _BookingChartCardState();
// }
//
// class _BookingChartCardState extends State<BookingChartCard> {
//   String? selectedRange = 'Last Week';
//
//   final List<double> barData = [85, 65, 28, 70, 55, 100, 100];
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: getWidthRatio() * 12, vertical: getHeightRatio() * 12),
//       decoration: BoxDecoration(
//         color: AppColors.textFieldColor,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         children: [
//           Align(
//             alignment: Alignment.centerRight,
//             child: SizedBox(
//               width: getWidth() * 0.3,
//               height: getHeightRatio() * 36,
//               child: FilterDropDown(
//                 items: const ['Last Week', 'Last Month'],
//                 hintText: 'Select Date Range',
//                 selectedValue: selectedRange,
//                 bfColor: AppColors.appColor,
//                 onChanged: (value) {
//                   setState(() {
//                     selectedRange = value;
//                   });
//                 },
//                 validator: (value) =>
//                 value == null ? 'Please select a date range' : null,
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           SizedBox(
//             height: getHeight() * 0.3,
//             child: BarChart(
//               BarChartData(
//                 backgroundColor: AppColors.textFieldColor,
//                 borderData: FlBorderData(
//                   show: true,
//                   border: const Border(
//                     bottom: BorderSide(color: AppColors.whiteColor),
//                     left: BorderSide(color: AppColors.whiteColor),
//                   ),
//                 ),
//                 gridData: const FlGridData(show: false),
//                 titlesData: FlTitlesData(
//                   leftTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: getWidth() * 0.08,
//                       getTitlesWidget: (value, meta) {
//                         return CustomText(
//                           text: value.toInt().toString(),
//                           fontSize: sizes.fontSize12,
//                           fontWeight: FontWeight.w400,
//                         );
//                       },
//                     ),
//                   ),
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: getHeight() * 0.05,
//                       getTitlesWidget: (value, meta) {
//                         const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
//                         return Container(
//                           padding: EdgeInsets.only(top: getHeight() * 0.02),
//                           child: CustomText(
//                             text: days[value.toInt()],
//                             fontSize: sizes.fontSize12,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                 ),
//                 barGroups: barData.asMap().entries.map((entry) {
//                   final index = entry.key;
//                   final value = entry.value;
//                   return BarChartGroupData(
//                     x: index,
//                     barRods: [
//                       BarChartRodData(
//                         toY: value,
//                         color: AppColors.ratingIconColor,
//                         width: getWidthRatio() * 18,
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ],
//                   );
//                 }).toList(),
//                 barTouchData: BarTouchData(
//                   touchTooltipData: BarTouchTooltipData(
//                     tooltipBgColor: AppColors.appColor,
//                   ),
//                   touchCallback: (event, response) {},
//                   handleBuiltInTouches: true,
//                 ),
//                 maxY: 100,
//                 minY: 0,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
