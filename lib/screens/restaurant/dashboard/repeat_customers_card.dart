import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../l18n.dart';
import '../../../res/res.dart';

class RepeatCustomersCard extends StatefulWidget {
  const RepeatCustomersCard({super.key});

  @override
  State<RepeatCustomersCard> createState() => _RepeatCustomersCardState();
}

class _RepeatCustomersCardState extends State<RepeatCustomersCard> {

  // late HomeProvider homeProvider;

  // @override
  // void initState() {
  //   super.initState();
  //   homeProvider = Provider.of<HomeProvider>(context, listen: false);
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     homeProvider.getRepeatCustomerAPI();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return
      Container(
      padding: EdgeInsets.symmetric(horizontal: getWidthRatio() * 24, vertical: getHeightRatio() * 12,),
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
          Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              text: al.menuCoverage,
              fontSize: sizes?.fontSize14,
              fontWeight: FontWeight.w500,
              color: AppColors.primarySlateColor,
            ),
          ),
          SizedBox(height: getHeightRatio() * 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 12,
                        width: 12,
                        decoration: const BoxDecoration(
                            color: AppColors.vibrantBlue,
                            shape: BoxShape.circle
                        ),
                      ),
                      SizedBox(width: getWidth() * 0.03),
                      CustomText(
                        // text: "New Visitors  (${provider.repeatCustomersResponse.newVisitors})",
                        text: al.rated + " (12)",
                        fontSize: sizes?.fontSize14,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  SizedBox(height: getHeight() * 0.02),
                  Row(
                    children: [
                      Container(
                        height: 12,
                        width: 12,
                        decoration: const BoxDecoration(
                            color: AppColors.softBlue,
                            shape: BoxShape.circle
                        ),
                      ),
                      SizedBox(width: getWidth() * 0.03),
                      CustomText(
                        text: al.notRated + " (4)",
                        // text: "Repeat  (${provider.repeatCustomersResponse.repeatCustomers})",
                        fontSize: sizes?.fontSize14,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  )
                ],
              ),
              Container(
                height: getHeight() * 0.13,
                width: getWidth() * 0.3,
                margin: EdgeInsets.symmetric(vertical: getHeight() * 0.02, horizontal: getWidth() * 0.02),
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        // value: provider.repeatCustomersResponse.repeatCustomers?.toDouble(),
                        value: 40,
                        title: "",
                        color: AppColors.softBlue,
                        radius: getWidth() * 0.1,
                      ),
                      PieChartSectionData(
                        // value: provider.repeatCustomersResponse.newVisitors?.toDouble(),
                        value: 70,
                        title: "",
                        color: AppColors.vibrantBlue,
                        radius: getWidth() * 0.1,
                      ),
                    ],
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        if (pieTouchResponse != null &&
                            pieTouchResponse.touchedSection != null) {
                          final sectionIndex =
                              pieTouchResponse.touchedSection!.touchedSectionIndex;
                          print('Touched section index: $sectionIndex');
                        }
                      },
                      enabled: true,
                    ),
                    centerSpaceRadius: getHeight() * 0.04,
                    sectionsSpace: 2,
                  ),
                ),
              )
            ],
          ),
        ],
      )
      // Consumer<HomeProvider>(
      //   builder: (context, provider, child) {
      //     return provider.isRepeatCustomerFetched?
      //       :
      //     const Center(
      //       child: CircularProgressIndicator(),
      //     );
      //   },
      // ),
    );
  }
}

