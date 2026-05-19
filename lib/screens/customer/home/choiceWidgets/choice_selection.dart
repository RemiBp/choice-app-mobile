import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../appAssets/app_assets.dart';
import '../../../../customWidgets/custom_text.dart';
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
      'label': 'Events',
      'subtitle': 'Lorem ipsum dolor sit amet',
      'icon': Assets.eventIcon,
      'color': Colors.red,
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Choice'),
        // leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                text: 'What would you like to share?',
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
                      text: "Cancel",
                      fontFamily: Assets.onsetSemiBold,
                      fontSize: sizes?.fontSize16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedChoice == "Events") {
                        context.push('/customer_home');
                        return;
                      }
                      context.push(
                        '/sub_choice_selection?selectedChoice=$selectedChoice',
                        extra: selectedChoice == "Restaurant"
                            ? {
                                "title": "Restaurant",
                                "icon": Assets.restaurantIcon,
                                "description": "Which restaurant did you visit?"
                              }
                            : selectedChoice == "Leisure"
                                ? {
                                    "title": "Leisure",
                                    "icon": Assets.leisureIcon,
                                    "description":
                                        "Which leisure event did you attend?"
                                  }
                                : {
                                    "title": "Wellness",
                                    "icon": Assets.wellnessIcon,
                                    "description":
                                        "Which wellness did you visit?"
                                  },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: CustomText(
                      text: "Next",
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
                  CustomText(
                    text: choice['subtitle'],
                    fontSize: sizes?.fontSize12,
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
