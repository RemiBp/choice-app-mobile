import 'package:flutter/material.dart';
import 'package:another_xlider/another_xlider.dart';

import '../../../../appColors/colors.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../res/res.dart';


class CustomSectionTitle extends StatelessWidget {
  final String title;
  const CustomSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: getHeight() * 0.01),
      child: CustomText(
        text: title,
        color: AppColors.blackColor,
        fontSize: sizes?.fontSize16,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class CustomMultiSelectOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const CustomMultiSelectOption({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            selected ? Icons.check_circle : Icons.radio_button_unchecked,
            color: selected ? AppColors.userPrimaryColor : AppColors.inputHintColor,
          ),
          const SizedBox(width: 8),
          CustomText(
            text: label,
            color: AppColors.blackColor,
            fontSize: sizes?.fontSize14,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}

