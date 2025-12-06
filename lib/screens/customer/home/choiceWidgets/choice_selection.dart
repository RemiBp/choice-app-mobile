import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/customWidgets/common_app_bar.dart';
import 'package:choice_app/screens/customer/home/choice_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../appAssets/app_assets.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../l18n.dart';
import '../../../../res/res.dart';

class ChoiceSelection extends StatefulWidget {
  const ChoiceSelection({super.key});

  @override
  _ChoiceSelectionState createState() => _ChoiceSelectionState();
}

class _ChoiceSelectionState extends State<ChoiceSelection> {
  String selectedChoice = 'Restaurant';

  final choices = [
    {
      'label': 'Restaurant',
      'subtitle': 'Lorem ipsum dolor sit amet',
      'icon': Assets.knifeForkIcon,
      'color': Colors.orange,
    },
    {
      'label': 'Leisure',
      'subtitle': 'Lorem ipsum dolor sit amet',
      'icon': Assets.leisureIcon,
      'color': Colors.purple,
    },
    {
      'label': 'Wellness',
      'subtitle': 'Lorem ipsum dolor sit amet',
      'icon': Assets.wellnessIcon,
      'color': Colors.green,
    },
  ];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<CustomerChoiceProvider>(context, listen: false);
    provider.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(title: al.createChoice),
      body: Padding(

        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                text: al.whatWouldYouLikeToShare,
                fontSize: sizes?.fontSize18,
                fontFamily: Assets.onsetSemiBold,
              ),
            ),
            const SizedBox(height: 20),
            ...choices.map((choice) => _buildChoiceCard(choice)).toList(),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.pop();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: CustomText(
                      text: al.cancel,
                      fontFamily: Assets.onsetSemiBold,
                      fontSize: sizes?.fontSize16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // context.push(Routes.subChoiceSelectionRoute);
                      context.push(
                          '/sub_choice_selection?selectedChoice=$selectedChoice',
                          extra: selectedChoice == "Restaurant" ? {
                            "title": "Restaurant",
                            "icon": Assets.restaurantIcon
                            ,
                            "description": al.whichRestaurantDidYouVisit}
                              : selectedChoice == "Leisure" ? {
                            "title": "Leisure",
                            "icon": Assets.leisureIcon
                            ,
                            "description": al.whichLeisureEventDidYouAttend
                          } : {
                            "title": "Wellness",
                            "icon": Assets.wellnessIcon
                            ,
                            "description": al.whichWellnessDidYouVisit
                          }
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: CustomText(
                      text: al.next,
                      fontFamily: Assets.onsetSemiBold,
                      fontSize: sizes?.fontSize16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceCard(Map<String, dynamic> choice) {
    final isSelected = selectedChoice == choice['label'];
    return GestureDetector(
      onTap: () => setState(() => selectedChoice = choice['label']),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SvgPicture.asset(choice['icon']),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: choice['label'],
                    fontSize: sizes?.fontSize14,
                    fontFamily: Assets.onsetMedium,
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
