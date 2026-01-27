import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/customWidgets/animations/bouncing_wrapper.dart';
import 'package:choice_app/customWidgets/glass/glass_container.dart'; // Ensure glass_container exists
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
      'subtitle': 'Share your culinary delights',
      'icon': Assets.restaurantIcon,
      'color1': AppColors.restaurantPrimaryColor,
      'color2': Color(0xFFFFA726),
    },
    {
      'label': 'Events',
      'subtitle': 'Concerts, parties, & shows',
      'icon': Assets.eventIcon,
      'color1': AppColors.redColor,
      'color2': Color(0xFFFF5252),
    },
    {
      'label': 'Leisure',
      'subtitle': 'Activities & Fun',
      'icon': Assets.leisureIcon,
      'color1': AppColors.leisurePrimaryColor,
      'color2': Color(0xFFBA68C8),
    },
    {
      'label': 'Wellness',
      'subtitle': 'Spas, gyms, & beauty',
      'icon': Assets.wellnessIcon,
      'color1': AppColors.wellnessPrimaryColor,
      'color2': Color(0xFF66BB6A),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CustomText(
          text: 'What are you sharing?',
          fontFamily: Assets.onsetSemiBold,
          fontSize: sizes?.fontSize18,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: choices.length,
              itemBuilder: (context, index) {
                return _buildChoiceCard(choices[index]);
              },
            ),
          ),
          
          // Bottom Action Bar
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 40),
            child: Row(
              children: [
                Expanded(
                  child: BouncingWrapper(
                    onTap: () {
                       _handleNext();
                    },
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.userPrimaryColor, AppColors.vibrantBlue],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.userPrimaryColor.withOpacity(0.4),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: Center(
                        child: CustomText(
                          text: "Continue",
                          color: Colors.white,
                          fontFamily: Assets.onsetSemiBold,
                          fontSize: sizes?.fontSize16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleNext() {
      if(selectedChoice == "Events"){
        return; // TODO: Implement Events flow
      }
      
      Map<String, dynamic> extraData = {};
      if (selectedChoice == "Restaurant") {
        extraData = {
          "title": "Restaurant",
          "icon": Assets.restaurantIcon,
          "description": "Which restaurant did you visit?"
        };
      } else if (selectedChoice == "Leisure") {
        extraData = {
          "title": "Leisure",
          "icon": Assets.leisureIcon,
          "description": "Which leisure event did you attend?"
        };
      } else {
        extraData = {
          "title": "Wellness",
          "icon": Assets.wellnessIcon,
          "description": "Which wellness did you visit?"
        };
      }

      context.push(
          '/sub_choice_selection?selectedChoice=$selectedChoice',
          extra: extraData
      );
  }

  Widget _buildChoiceCard(Map<String, dynamic> choice) {
    final isSelected = selectedChoice == choice['label'];
    final Color color1 = choice['color1'] as Color;
    final Color color2 = choice['color2'] as Color;

    return BouncingWrapper(
      onTap: () => setState(() => selectedChoice = choice['label']),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: isSelected 
              ? LinearGradient(colors: [color1, color2], begin: Alignment.topLeft, end: Alignment.bottomRight)
              : LinearGradient(colors: [Colors.white, Colors.grey.shade50]),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade200,
            width: 2,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: color1.withOpacity(0.4), blurRadius: 12, offset: Offset(0, 6))]
              : [],
        ),
        child: Stack(
          children: [
            // Background Pattern (Optional circle/decoration)
            if (isSelected)
              Positioned(
                top: -20,
                right: -20,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white.withOpacity(0.1),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white.withOpacity(0.2) : color1.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SvgPicture.asset(
                      choice['icon'], 
                      color: isSelected ? Colors.white : color1,
                      width: 24,
                      height: 24,
                    ),
                  ),
                  Spacer(),
                  CustomText(
                    text: choice['label'],
                    fontSize: sizes?.fontSize18,
                    fontFamily: Assets.onsetBold,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                  SizedBox(height: 4),
                  CustomText(
                    text: choice['subtitle'],
                    fontSize: sizes?.fontSize12,
                    color: isSelected ? Colors.white.withOpacity(0.9) : Colors.grey,
                    giveLinesAsText: true,
                    lines: 2,
                  ),
                ],
              ),
            ),
            
            // Selection Checkmark
            if (isSelected)
              Positioned(
                top: 10,
                right: 10,
                child: Icon(Icons.check_circle, color: Colors.white, size: 24),
              ),
          ],
        ),
      ),
    );
  }
}
