import 'package:choice_app/appAssets/app_assets.dart';
import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:flutter/material.dart';

import '../../customWidgets/common_app_bar.dart';
import '../../l18n.dart';
import '../../res/res.dart';

class CancelledBookingDetails extends StatefulWidget {
  final String cancelReason;

  const CancelledBookingDetails({super.key,required this.cancelReason});

  @override
  State<CancelledBookingDetails> createState() => _CancelledBookingDetailsState();
}

class _CancelledBookingDetailsState extends State<CancelledBookingDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(title: 'Booking Cancelled'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
                text: al.reason,
              fontWeight: FontWeight.w600,
              fontSize: sizes?.fontSize18,
              fontFamily: Assets.onsetSemiBold,
            ),
            const SizedBox(height: 5),
            CustomText(
                text: widget.cancelReason,
              fontSize: sizes?.fontSize16,
              fontWeight: FontWeight.w400,
              fontFamily: Assets.onsetRegular,
              giveLinesAsText: true,
            ),

          ]
        ),
      ),

    );
  }
}
