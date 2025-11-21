import 'package:choice_app/screens/bookings/upcoming_bookings.dart';
import 'package:flutter/material.dart';
import '../../appColors/colors.dart';
import '../../customWidgets/common_app_bar.dart';
import '../../customWidgets/custom_text.dart';
import '../../l18n.dart';
import '../../res/res.dart';
import 'bookings_widgets.dart';

class BookingDetails extends StatefulWidget {
  final bool? isCancelled;
  final String? cancellationReason;
  final BookingCardData? bookingData;

  const BookingDetails({
    super.key,
    this.isCancelled,
    this.cancellationReason,
    this.bookingData,
  });

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  @override
  Widget build(BuildContext context) {
    final booking = widget.bookingData;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(
        title:
            widget.isCancelled ?? false
                ? 'Booking Cancelled'
                : al.bookingDetails,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: sizes!.pagePadding,
          vertical: getHeight() * 0.02,
        ),
        child: Column(
          children: [
            widget.isCancelled ?? false
                ? Expanded(
                  child: ListView(
                    children: [
                      CustomText(
                        text: al.reason,
                        fontSize: sizes?.fontSize16,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: getHeight() * 0.02),
                      CustomText(
                        text: widget.cancellationReason ?? 'Unknown',
                        fontSize: sizes?.fontSize14,
                        color: AppColors.primarySlateColor,
                        fontWeight: FontWeight.w500,
                        giveLinesAsText: true,
                      ),
                    ],
                  ),
                )
                : Expanded(
                  child: ListView(
                    children: [
                      CustomText(
                        text: al.bookingInformation,
                        fontSize: sizes?.fontSize16,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: getHeight() * 0.02),
                      BookingInfoRow(
                        label: al.bookingId,
                        value: booking?.bookingId ?? 'Unknown',
                      ),
                      SizedBox(height: getHeight() * 0.01),
                      BookingInfoRow(
                        label: al.numberOfPersons,
                        value: "${booking?.guests} ${al.person}(s)",
                      ),
                      SizedBox(height: getHeight() * 0.01),
                      BookingInfoRow(
                        label: al.date,
                        value: formatDisplayDate(booking!.date) ?? 'Unknown',
                      ),
                      SizedBox(height: getHeight() * 0.01),
                      BookingInfoRow(
                        label: al.time,
                        value: "${booking.startTime} - ${booking.endTime}",
                      ),
                      if (booking.totalPrice != null) ...[
                        SizedBox(height: getHeight() * 0.01),
                        BookingInfoRow(
                          label: al.amount,
                          value: "\$${booking.totalPrice}",
                        ),
                      ],
                      Divider(
                        color: AppColors.greyBordersColor,
                        height: getHeight() * 0.03,
                      ),

                      CustomText(
                        text: al.customerInformation,
                        fontSize: sizes?.fontSize16,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: getHeight() * 0.02),
                      if (booking.customerName != null) ...[
                        BookingInfoRow(
                          label: al.customerName,
                          value: booking.customerName ?? 'Unknown',
                        ),
                        SizedBox(height: getHeight() * 0.01),
                      ],
                      BookingInfoRow(
                        label: al.emailLabel1,
                        value: booking.customerEmail ?? 'Unknown',
                      ),
                      SizedBox(height: getHeight() * 0.01),
                      BookingInfoRow(
                        label: al.phoneLabel,
                        value: booking.customerPhone ?? 'Unknown',
                      ),
                      Divider(
                        color: AppColors.greyBordersColor,
                        height: getHeight() * 0.03,
                      ),

                      CustomText(
                        text: al.internalNotes,
                        fontSize: sizes?.fontSize16,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: getHeight() * 0.02),
                      CustomText(
                        text:
                            booking.internalNotes != null
                                ? "\"${booking.internalNotes}\""
                                : 'No internal notes',
                        fontSize: sizes?.fontSize14,
                        color: AppColors.primarySlateColor,
                        fontWeight: FontWeight.w500,
                        giveLinesAsText: true,
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
  String formatDisplayDate(String rawDate) {
    try {
      final date = DateTime.parse(rawDate);

      const months = [
        "Jan","Feb","Mar","Apr","May","Jun",
        "Jul","Aug","Sep","Oct","Nov","Dec"
      ];

      return "${months[date.month - 1]} ${date.day}, ${date.year}";
    } catch (_) {
      return rawDate;
    }
  }
}
