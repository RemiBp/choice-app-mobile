import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../appAssets/app_assets.dart';
import '../../../../appColors/colors.dart';
import '../../../../customWidgets/custom_button.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../l18n.dart';
import '../../../../res/res.dart';

class CalendarButton extends StatelessWidget {
  final String month;
  final VoidCallback? onTap;

  const CalendarButton({super.key, required this.month, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.greyColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.greyBordersColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.calendarIcon,
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn),
            ),
            const SizedBox(width: 4),
            CustomText(
              text: month,
              fontSize: sizes!.fontSize12,
              fontWeight: FontWeight.w500,
              color: AppColors.blackColor,
            ),
          ],
        ),
      ),
    );
  }
}


class DeclineReasonDialog extends StatefulWidget {
  final Function(String reason) onSubmit;

  const DeclineReasonDialog({super.key, required this.onSubmit});

  @override
  State<DeclineReasonDialog> createState() => _DeclineReasonDialogState();
}

class _DeclineReasonDialogState extends State<DeclineReasonDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(getWidth() * 0.05),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: al.reasonOfDecline,
              fontSize: sizes?.fontSize16,
              fontWeight: FontWeight.w700,
              color: AppColors.blackColor,
            ),
            SizedBox(height: getHeight() * 0.02),
            TextField(
              controller: _controller,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "e.g. Let’s try this Friday night...",
                hintStyle: TextStyle(
                  fontSize: sizes?.fontSize14,
                  color: AppColors.inputHintColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.greyBordersColor),
                ),
                contentPadding: EdgeInsets.all(getWidth() * 0.035),
              ),
            ),
            SizedBox(height: getHeight() * 0.03),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    buttonText: al.cancel,
                    onTap: () => Navigator.pop(context),
                    backgroundColor: Colors.transparent,
                    borderColor: AppColors.blackColor,
                    textColor: AppColors.blackColor,
                    textFontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: getWidth() * 0.04),
                Expanded(
                  child: CustomButton(
                    buttonText: al.submit,
                    onTap: () {
                      widget.onSubmit(_controller.text.trim());
                      Navigator.pop(context);
                    },
                    backgroundColor: AppColors.getPrimaryColorFromContext(context),
                    borderColor: AppColors.getPrimaryColorFromContext(context),
                    textColor: Colors.white,
                    textFontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class DateChip extends StatelessWidget {
  final String day;
  final String date;
  final bool isSelected;
  final VoidCallback? onTap;

  const DateChip({
    super.key,
    required this.day,
    required this.date,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 65,
        height: 54,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.getPrimaryColorFromContext(context)
              : AppColors.greyColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: day,
              fontSize: sizes!.fontSize11,
              fontWeight: FontWeight.w500,
              color: isSelected ? AppColors.whiteColor : AppColors.blackColor,
            ),
            CustomText(
              text: date,
              fontSize: sizes!.fontSize12,
              fontWeight: FontWeight.w700,
              color: isSelected ? AppColors.whiteColor : AppColors.blackColor,
            ),
          ],
        ),
      ),
    );
  }
}

class TimeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const TimeChip({
    super.key,
    required this.label,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 95, // fits 3 per row
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.getPrimaryColorFromContext(context)
              : AppColors.greyColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomText(
          text: label,
          fontSize: sizes!.fontSize12,
          fontWeight: FontWeight.w500,
          color: isSelected ? AppColors.whiteColor : AppColors.blackColor,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class MessageField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final Color? backgroundColor;
  final Color? borderColor;

  const MessageField({
    super.key,
    this.controller,
    this.hintText = "e.g. Let’s try this Friday night...?",
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.greyColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor ?? AppColors.greyBordersColor),
      ),
      child: TextField(
        controller: controller,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: AppColors.inputHintColor,
            fontSize: sizes!.fontSize14,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(14),
        ),
      ),
    );
  }
}

class PersonCounterWidget extends StatelessWidget {
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const PersonCounterWidget({
    super.key,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyBordersColor),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 20),
            color: AppColors.blackColor,
            onPressed: value > 1 ? onDecrement : null,
          ),

          Expanded(
            child: Center(
              child: CustomText(
                text: value.toString(),
                fontSize: sizes?.fontSize16,
                color: AppColors.blackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          IconButton(
            icon: const Icon(Icons.add, size: 20),
            color: AppColors.blackColor,
            onPressed: onIncrement,
          ),
        ],
      ),
    );
  }
}

