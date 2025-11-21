import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../appAssets/app_assets.dart';
import '../../appColors/colors.dart';
import '../../common/formatter.dart';
import '../../customWidgets/custom_button.dart';
import '../../customWidgets/custom_text.dart';
import '../../customWidgets/custom_textfield.dart';
import '../../l18n.dart';
import '../../res/res.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../userRole/role_provider.dart';
import '../../userRole/user_role.dart';

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
  final String bookingType; // "Restaurant" | "Wellness" | "Leisure"
  final String? address;
  final String? totalPrice;
  final String? bookingId;
  final bool? isEvent;
  final String buttonText;

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
    this.bookingType = "Restaurant",
    this.address,
    this.totalPrice,
    this.bookingId,
    this.isEvent,
    this.buttonText = '',
  });

  @override
  Widget build(BuildContext context) {
    final role = context.watch<RoleProvider>().role;

    // Map of type colors
    final Map<String, Color> typeColors = {
      "Restaurant": const Color(0xFFFFAC12),
      "Wellness": const Color(0xFF6FAF5B),
      "Leisure": const Color(0xFF8F2DA3),
    };

    // Normalize bookingType
    String normalizedType = bookingType.isNotEmpty
        ? bookingType[0].toUpperCase() + bookingType.substring(1).toLowerCase()
        : '';

    return GestureDetector(
      onTap: () => onDetails(),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: getWidthRatio() * 12,
          vertical: getHeightRatio() * 12,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: sizes!.pagePadding,
          vertical: getHeight() * 0.01,
        ),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withValues(alpha: 0.05),
              blurRadius: 24,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top Row (Booking ID + Chips)
            Row(
              children: [
                CustomText(
                  text: "${al.bookingId}: $bookingId",
                  fontSize: sizes?.fontSize12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blackColor,
                ),
                const Spacer(),

                // Chips
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    // Event chip (only for events)
                    if (isEvent ?? false)
                      _buildChip(al.event, AppColors.redColor),

                    // Booking type chip (always shown)
                    if (normalizedType.isNotEmpty)
                      _buildChip(
                        normalizedType,
                        typeColors[normalizedType] ??
                            AppColors.getPrimaryColorFromContext(context),
                      ),
                  ],
                ),

                if (onCheckIn == null && onCancel == null)
                  Padding(
                    padding: EdgeInsets.only(left: getWidth() * 0.011),
                    child: Icon(
                      Icons.check_circle,
                      color: AppColors.wellnessPrimaryColor,
                      size: 18,
                    ),
                  ),
              ],
            ),

            Divider(
              color: AppColors.greyBordersColor,
              height: getHeight() * 0.03,
            ),

            // Booking Info Content
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(context),
                SizedBox(width: getWidthRatio() * 8),
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

                      // Guests
                      _infoRow(
                        Assets.guestsIcon,
                        "$guests ${al.guests}",
                        context,
                      ),
                      SizedBox(height: getHeightRatio() * 8),

                      // Date & Time
                      _infoRow(
                        Assets.calenderIcon,
                        formatDateTime(
                          date: date,
                          startTime: startTime,
                          endTime: endTime,
                        ),
                        context,
                      ),
                      SizedBox(height: getHeightRatio() * 8),

                      // Price or Address
                      role == UserRole.user
                          ? _locationRow(
                        Assets.locationIcon,
                        address ?? "Unknown",
                        context,
                      )
                          : totalPrice != null
                          ? _infoRow(
                        Assets.priceIcon,
                        totalPrice ?? 'Unknown',
                        context,
                      )
                          : SizedBox(),
                    ],
                  ),
                ),
              ],
            ),

            // Buttons (Cancel + Check-In / Modify)
            if (onCheckIn != null && onCancel != null) ...[
              SizedBox(height: getHeight() * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    buttonText: al.cancel,
                    onTap: () => onCancel!(),
                    buttonWidth: getWidth() * .38,
                    height: getHeight() * 0.06,
                    backgroundColor: Colors.transparent,
                    borderColor: AppColors.blackColor,
                    textColor: AppColors.blackColor,
                    textFontWeight: FontWeight.w700,
                  ),
                  CustomButton(
                    buttonText: buttonText,
                    onTap: () {
                      if (buttonText == al.modify) {
                        onDetails(isFromModifyButton: true);
                      } else if (buttonText == 'View') {
                        onDetails();
                      } else {
                        onCheckIn!();
                      }
                    },
                    buttonWidth: getWidth() * .38,
                    height: getHeight() * 0.06,
                    backgroundColor:
                    AppColors.getPrimaryColorFromContext(context),
                    borderColor: Colors.transparent,
                    textColor: Colors.white,
                    textFontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Build Chips
  Widget _buildChip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getWidth() * 0.025,
        vertical: getHeight() * 0.006,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(40),
        borderRadius: BorderRadius.circular(40),
      ),
      child: CustomText(
        text: label,
        fontSize: sizes?.fontSize10,
        fontWeight: FontWeight.w500,
        color: color,
      ),
    );
  }

  // Booking Image
  Widget _buildImage(BuildContext context) {
    if (imageUrl == "") {
      return Container(
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
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl,
          width: getWidthRatio() * 64,
          height: getHeightRatio() * 64,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
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
            );
          },
        ),
      );
    }
  }

  // Info Row (png assets)
  Widget _infoRow(String icon, String text, BuildContext context) {
    return Row(
      children: [
        Image.asset(
          icon,
          width: getWidthRatio() * 16,
          height: getHeightRatio() * 16,
          color: AppColors.getPrimaryColorFromContext(context),
        ),
        SizedBox(width: getWidthRatio() * 4),
        Expanded(
          child: CustomText(
            text: text,
            fontSize: sizes?.fontSize12,
            fontWeight: FontWeight.w500,
            color: AppColors.primarySlateColor,
            lines: 1,
          ),
        ),
      ],
    );
  }

  // Location Row (SVG asset)
  Widget _locationRow(String icon, String text, BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          width: getWidthRatio() * 16,
          height: getHeightRatio() * 16,
          color: AppColors.getPrimaryColorFromContext(context),
        ),
        SizedBox(width: getWidthRatio() * 4),
        Expanded(
          child: CustomText(
            text: text,
            fontSize: sizes?.fontSize12,
            fontWeight: FontWeight.w500,
            color: AppColors.primarySlateColor,
            lines: 1,
          ),
        ),
      ],
    );
  }

  // Date Formatter
  String formatDateTime({String? date, String? startTime, String? endTime}) {
    if (date == null || startTime == null || endTime == null) return '';
    try {
      final formattedDate = Formatter.formatDateFromString(date, newPattern: 'MMM d');
      final formattedStart = Formatter.formatDateFromString(startTime, newPattern: 'h:mm a');
      final formattedEnd = Formatter.formatDateFromString(endTime, newPattern: 'h:mm a');
      return '$formattedDate, $formattedStart - $formattedEnd';
    } catch (e) {
      return '';
    }
  }
}

class BookingInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const BookingInfoRow({super.key, required this.label, required this.value});

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

  const CancelConfirmationAlert({
    super.key,
    required this.onConfirm,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.whiteColor,
      insetPadding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: al.cancelBooking,
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
                ),
              ],
            ),
            SizedBox(height: getHeightRatio() * 16),
            CustomText(
              text: al.cancelBookingConfirmation,
              fontWeight: FontWeight.w400,
              fontSize: sizes?.fontSize16,
              color: AppColors.primarySlateColor,
              giveLinesAsText: true,
            ),
            SizedBox(height: getHeightRatio() * 16),
            CustomField(
              height: getHeight() * .1,
              borderColor: AppColors.greyBordersColor,
              hint: al.shareReason,
              label: al.reason,
              textEditingController: controller,
            ),
            SizedBox(height: getHeightRatio() * 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  buttonText: al.no,
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
                  buttonText: al.yes,
                  onTap: onConfirm,
                  buttonWidth: getWidth() * .38,
                  height: getHeight() * 0.06,
                  backgroundColor: AppColors.getPrimaryColorFromContext(
                    context,
                  ),
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
