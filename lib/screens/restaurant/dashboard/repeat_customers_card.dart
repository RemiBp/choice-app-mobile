import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../res/res.dart';
import 'dashboard_provider.dart';

class RepeatCustomersCard extends StatefulWidget {
  const RepeatCustomersCard({super.key});

  @override
  State<RepeatCustomersCard> createState() => _RepeatCustomersCardState();
}

class _RepeatCustomersCardState extends State<RepeatCustomersCard> {
  String _selectedMetric = 'Ratings'; // 'Ratings' or 'Loyalty'

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        final insights = provider.userInsights;
        
        if (provider.isLoading && insights == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (insights == null) {
          return const SizedBox.shrink();
        }

        final bool isRatings = _selectedMetric == 'Ratings';
        
        final double val1 = isRatings 
            ? (insights['ratedBookings']?.toDouble() ?? 0)
            : (insights['newCustomers']?.toDouble() ?? 0);
            
        final double val2 = isRatings 
            ? (insights['unratedBookings']?.toDouble() ?? 0)
            : (insights['repeatCustomers']?.toDouble() ?? 0);

        final String label1 = isRatings ? "Rated" : "New";
        final String label2 = isRatings ? "Unrated" : "Repeat";

        final total = val1 + val2;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: getWidthRatio() * 16, vertical: getHeightRatio() * 12),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.greyBordersColor.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
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
                    text: isRatings ? 'Booking Ratings' : 'Visitor Loyalty',
                    fontSize: sizes?.fontSize16,
                    fontWeight: FontWeight.w600,
                  ),
                  DropdownButton<String>(
                    value: _selectedMetric,
                    underline: const SizedBox(),
                    icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                    items: ['Ratings', 'Loyalty'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: CustomText(text: value, fontSize: sizes?.fontSize12),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedMetric = newValue!;
                      });
                    },
                  ),
                ],
              ),
              const Divider(),
              SizedBox(height: getHeightRatio() * 10),
              Row(
                children: [
                   Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLegendItem(label1, val1.toInt(), AppColors.getPrimaryColorFromContext(context)),
                        SizedBox(height: getHeight() * 0.015),
                        _buildLegendItem(label2, val2.toInt(), AppColors.getPrimaryColorFromContext(context).withOpacity(0.4)),
                        if (total > 0) ...[
                          SizedBox(height: getHeight() * 0.02),
                          CustomText(
                            text: "${((val1/total)*100).toStringAsFixed(1)}% $label1",
                            fontSize: sizes?.fontSize12,
                            color: AppColors.textGreyColor,
                          ),
                        ]
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 100,
                      child: total == 0 
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.pie_chart_outline, size: 32, color: AppColors.textGreyColor.withOpacity(0.5)),
                              SizedBox(height: 4),
                              CustomText(text: "No data", fontSize: 10, color: AppColors.textGreyColor),
                            ],
                          ),
                        )
                      : PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              value: val1,
                              title: "",
                              color: AppColors.getPrimaryColorFromContext(context),
                              radius: 18,
                            ),
                            PieChartSectionData(
                              value: val2,
                              title: "",
                              color: AppColors.getPrimaryColorFromContext(context).withOpacity(0.4),
                              radius: 18,
                            ),
                          ],
                          centerSpaceRadius: 30,
                          sectionsSpace: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegendItem(String label, int value, Color color) {
    return Row(
      children: [
        Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 8),
        Expanded(
          child: CustomText(
            text: "$label ($value)",
            fontSize: sizes?.fontSize14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

