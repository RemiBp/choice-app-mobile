import 'package:choice_app/utilities/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../appAssets/app_assets.dart';
import '../../../../appColors/colors.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../l18n.dart';
import '../../../../res/res.dart';
import 'package:choice_app/models/get_all_events_response.dart';

class EventInfoSection extends StatelessWidget {
  const EventInfoSection({super.key, this.event});

  final Data? event;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Chip(
            backgroundColor: AppColors.eventChipBackgroundColor, // remove background fill
            side: BorderSide.none,               // remove border
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            label: CustomText(
              text: al.event,
              fontSize: sizes?.fontSize12,
              fontFamily: Assets.onsetMedium,
              color: HexColor.fromHex("#FF5655"),
            ),
          ),
          SizedBox(height: 8),
          CustomText(
            text: event?.title ?? "Unknown",
            fontSize: sizes?.fontSize20,
            fontFamily: Assets.onsetSemiBold,
          ),
          SizedBox(height: 12),
          IconTextRow(
            text: DateFormat('EEEE, MMMM d, yyyy').format(DateTime.tryParse(event?.date ?? "")?? DateTime.now()),
            svgString: Assets.calenderCircleSvg,
            subText: "${event?.startTime} - ${event?.endTime}",
          ),
          SizedBox(height: getHeight() * .02),
          IconTextRow(
            text: event?.location ?? "Unknown Location",
            svgString: Assets.locationCircleSvg,
            subText: event?.location ?? "Unknown Location",
          ),
          SizedBox(height: getHeight() * .02),
          IconTextRow(
            text: "\$${event?.pricePerGuest}/per person",
            svgString: Assets.ticketCircleSvg,
            subText: al.ticketPrice,
          ),

        ],
      ),
    );
  }
}

class IconTextRow extends StatelessWidget {
  const IconTextRow({
    super.key,
    required this.text,
    required this.svgString,
    required this.subText,
  });

  final String text;
  final String subText;
  final String svgString;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(svgString),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: text,
              fontSize: sizes?.fontSize14,
              fontFamily: Assets.onsetMedium,
            ),
            CustomText(text: subText, fontSize: sizes?.fontSize12),
          ],
        ),
      ],
    );
  }
}
