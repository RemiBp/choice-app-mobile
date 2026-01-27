import 'package:flutter/material.dart';
import '../../appAssets/app_assets.dart';
import '../../appColors/colors.dart';
import '../../common/formatter.dart';
import '../../customWidgets/custom_button.dart';
import '../../customWidgets/custom_text.dart';
import '../../customWidgets/custom_textfield.dart';
import 'package:choice_app/l18n.dart';
import '../../res/res.dart';

class BookingCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String? date;
  final String? startTime;
  final String? endTime;
  final int guests;
  final Function onDetails;
  final Function? onCheckIn;
  final Function? onCancel;

  const BookingCard({
    super.key,
    required this.name,
    required this.imageUrl,
    this.date,
    this.startTime,
    this.endTime,
    required this.guests,
    required this.onDetails,
    this.onCheckIn,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> onDetails(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: getWidthRatio() * 12, vertical: getHeightRatio() * 12),
        margin: EdgeInsets.symmetric(horizontal: sizes!.pagePadding, vertical: getHeight() * 0.01),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withOpacity(0.05),
              blurRadius: 24,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "Booking ID: #3956839",
                  fontSize: sizes?.fontSize14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blackColor,
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.035, vertical: getHeight() * 0.01),
                  decoration: BoxDecoration(
                    color: AppColors.redColor.withAlpha(40),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: CustomText(
                    text: "Event",
                    fontSize: sizes?.fontSize12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.redColor,
                  ),
                ),
                if(onCheckIn == null  && onCancel== null)
                Padding(
                  padding: EdgeInsets.only(left: getWidth() * 0.015),
                  child: Icon(Icons.check_circle, color: AppColors.wellnessPrimaryColor,),
                )
              ],
            ),
            Divider(color: AppColors.greyBordersColor, height:  getHeight() * 0.03,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                imageUrl==""?
                Container(
                  width: getWidthRatio() * 64,
                  height: getHeightRatio() * 64,
                  decoration: BoxDecoration(
                    color: AppColors.getPrimaryColorFromContext(context).withAlpha(40),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 48,
                    color: AppColors.getPrimaryColorFromContext(context),
                  ),
                ):
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                      imageUrl,
                      width: getWidthRatio() * 64,
                      height: getHeightRatio() * 64,
                      fit: BoxFit.cover,
                      // errorBuilder: (context, error, stackTrace) {
                      //   return  CustomShimmerEffect(
                      //     child: Container(
                      //       color: AppColors.whiteColor,
                      //       width: getWidthRatio() * 64,
                      //       height: getHeightRatio() * 64,
                      //     ),
                      //   );
                      // }
                  ),
                ),
                SizedBox(width:getWidthRatio() * 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: name,
                        fontSize: sizes?.fontSize16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blackColor,
                      ),
                      SizedBox(height: getHeightRatio() * 8),
                      Row(
                        children: [
                          Image.asset(
                            Assets.guestsIcon,
                            width: getWidthRatio() * 16,
                            height:getHeightRatio() * 16,
                            color: AppColors.getPrimaryColorFromContext(context),
                          ),
                          SizedBox(width: getWidthRatio() * 4),
                          Expanded(
                            child: CustomText(
                              text: "$guests Guests",
                              fontSize: sizes?.fontSize12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primarySlateColor,
                              lines: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: getHeightRatio() * 8),
                      Row(
                        children: [
                          Image.asset(
                            Assets.calenderIcon,
                            width: getWidthRatio() * 16,
                            height:getHeightRatio() * 12,
                            color: AppColors.getPrimaryColorFromContext(context),
                          ),
                          SizedBox(width: getWidthRatio() * 4),
                          Expanded(
                            child: CustomText(
                              text: formatDateTime(
                                  date: date,
                                  startTime: startTime,
                                  endTime: endTime
                              ),
                              fontSize: sizes?.fontSize12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primarySlateColor,
                              lines: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: getHeightRatio() * 8),
                      Row(
                        children: [
                          Image.asset(
                            Assets.priceIcon,
                            width: getWidthRatio() * 16,
                            height:getHeightRatio() * 16,
                            color: AppColors.getPrimaryColorFromContext(context),
                          ),
                          SizedBox(width: getWidthRatio() * 4),
                          Expanded(
                            child: CustomText(
                              text: "\$90",
                              fontSize: sizes?.fontSize12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primarySlateColor,
                              lines: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if(onCheckIn != null  && onCancel != null)
              SizedBox(height: getHeight() * 0.02),
            if(onCheckIn != null && onCancel != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    buttonText: 'Cancel',
                    onTap: () => onCancel!(),
                    buttonWidth: getWidth() * .38,
                    height: getHeight() * 0.06,
                    backgroundColor: Colors.transparent,
                    borderColor: AppColors.blackColor,
                    textColor: AppColors.blackColor,
                    textFontWeight: FontWeight.w700,
                  ),
                  CustomButton(
                    buttonText: 'Check-In',
                    onTap: () {

                    },
                    buttonWidth: getWidth() * .38,
                    height: getHeight() * 0.06,
                    backgroundColor: AppColors.getPrimaryColorFromContext(context),
                    borderColor: Colors.transparent,
                    textColor: Colors.white,
                    textFontWeight: FontWeight.w700,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }


  String formatDateTime({String? date, String? startTime, String? endTime}) {
    if (date == null || startTime == null || endTime == null) {
      return '';
    }

    try {
      final formattedDate = Formatter.formatDateFromString(
        date,
        newPattern: 'MMM d',
      );

      final formattedStart = Formatter.formatDateFromString(
        startTime,
        newPattern: 'h:mm a',
      );

      final formattedEnd = Formatter.formatDateFromString(
        endTime,
        newPattern: 'h:mm a',
      );

      return '$formattedDate, $formattedStart - $formattedEnd';
    } catch (e) {
      return '';
    }
  }

}

class BookingInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const BookingInfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: label,
          fontSize: sizes?.fontSize14,
          color: AppColors.primarySlateColor,
          fontWeight: FontWeight.w400,
        ),
        CustomText(
          text: value,
          fontSize: sizes?.fontSize14,
          color: AppColors.blackColor,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}


class CancelConfirmationAlert extends StatelessWidget {
  final VoidCallback onConfirm;
  final TextEditingController controller;

  const CancelConfirmationAlert({super.key, required this.onConfirm, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.whiteColor,
      insetPadding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Cancel Booking',
                  fontWeight: FontWeight.w600,
                  fontSize: sizes?.fontSize16,
                  color: AppColors.blackColor,
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close_outlined,
                    color: AppColors.primarySlateColor,
                  ),
                )
              ],
            ),
            SizedBox(
              height: getHeightRatio() * 16,
            ),
            CustomText(
              text: 'Are you sure you would like to cancel your booking?',
              fontWeight: FontWeight.w400,
              fontSize: sizes?.fontSize16,
              color: AppColors.primarySlateColor,
              giveLinesAsText: true,
            ),
            SizedBox(height: getHeightRatio() * 16,),
            CustomField(
              controller: controller, // Pass the controller
              height: getHeight() * .1,
              borderColor: AppColors.greyBordersColor,
              hint: "Share your reason here...",
              label: "Reason",
            ),
            SizedBox(
              height: getHeightRatio() * 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  buttonText: 'No',
                  onTap: () {
                    Navigator.pop(context);
                  },
                  buttonWidth: getWidth() * .38,
                  height: getHeight() * 0.06,
                  backgroundColor: Colors.transparent,
                  borderColor: AppColors.blackColor,
                  textColor: AppColors.blackColor,
                  textFontWeight: FontWeight.w700,
                ),
                CustomButton(
                  buttonText: 'Yes',
                  onTap: () {

                  },
                  buttonWidth: getWidth() * .38,
                  height: getHeight() * 0.06,
                  backgroundColor: AppColors.getPrimaryColorFromContext(context),
                  borderColor: Colors.transparent,
                  textColor: Colors.white,
                  textFontWeight: FontWeight.w700,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
