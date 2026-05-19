import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_text.dart';
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: getWidthRatio() * 16, vertical: getHeightRatio() * 12,),
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
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: CustomText(
          //     text: 'Menu Coverage',
          //     fontSize: sizes?.fontSize14,
          //     fontWeight: FontWeight.w500,
          //     color: AppColors.primarySlateColor,
          //   ),
          // ),
          // SizedBox(height: getHeightRatio() * 16),
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
                      const SizedBox(width: 8),
                      CustomText(
                        // text: "New Visitors  (${provider.repeatCustomersResponse.newVisitors})",
                        text: "Rated  (12)",
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
                      const SizedBox(width: 8),
                      CustomText(
                        text: "Not Rated  (4)",
                        // text: "Repeat  (${provider.repeatCustomersResponse.repeatCustomers})",
                        fontSize: sizes?.fontSize14,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: getHeight() * 0.13,
                width: 110,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: 40,
                        title: "",
                        color: AppColors.softBlue,
                        radius: 36,
                      ),
                      PieChartSectionData(
                        value: 70,
                        title: "",
                        color: AppColors.vibrantBlue,
                        radius: 36,
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

