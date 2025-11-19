import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../appAssets/app_assets.dart';
import '../../appColors/colors.dart';
import '../../customWidgets/common_app_bar.dart';
import '../../customWidgets/custom_text.dart';
import '../../l18n.dart';
import '../../models/get_event_booking_details_response.dart';
import '../../res/res.dart';
import 'bookings_provider.dart';
import 'bookings_widgets.dart';
import '../../userRole/role_provider.dart';
import '../../userRole/user_role.dart';

class UserBookingDetails extends StatefulWidget {
  final bool? isCancelled;
  final String bookingId;
  final bool isEvent;

  const UserBookingDetails({
    super.key,
    this.isCancelled,
    required this.bookingId,
    required this.isEvent,
  });

  @override
  State<UserBookingDetails> createState() => _UserBookingDetailsState();
}

class _UserBookingDetailsState extends State<UserBookingDetails> {

  @override
  void initState() {
    super.initState();

    // Fetch event booking details if it's an event
    if (widget.isEvent) {
      Future.microtask(() {
        context.read<BookingsProvider>().fetchEventBookingDetails(
          context,
          int.parse(widget.bookingId),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingsProvider>();
    final role = context.watch<RoleProvider>().role;
    final isWellness = role == UserRole.wellness;

    // Show loader while event booking data is being fetched
    if (widget.isEvent && provider.eventBookingDetails == null) {
      return Scaffold(
        appBar: CommonAppBar(title: al.bookingDetails),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final booking = widget.isEvent ? provider.eventBookingDetails!.data : null;
    final event = widget.isEvent ? booking!.event : null;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(title: al.bookingDetails),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: sizes!.pagePadding,
          vertical: getHeight() * 0.02,
        ),
        child: ListView(
          children: [
            // Booking Information Heading
            CustomText(
              text: al.bookingInformation,
              fontSize: sizes?.fontSize16,
              color: AppColors.blackColor,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: getHeight() * 0.02),

            // IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: widget.isEvent
                  ? _buildEventImage(event!)
                  : Image.asset(
                Assets.restaurantImage,
                height: getHeight() * 0.2,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: getHeight() * 0.02),

            // TITLE + LOCATION
            CustomText(
              text: widget.isEvent ? event!.title : "N/A",
              fontSize: sizes?.fontSize16,
              color: AppColors.blackColor,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 4),
            CustomText(
              text: widget.isEvent ? event!.location : "",
              fontSize: sizes?.fontSize14,
              color: AppColors.primarySlateColor,
            ),
            SizedBox(height: getHeight() * 0.02),

            // BOOKING DETAILS
            BookingInfoRow(
              label: al.bookingId,
              value: widget.isEvent ? "#${booking!.id}" : "-",
            ),
            SizedBox(height: getHeight() * 0.01),
            BookingInfoRow(
              label: al.numberOfPersons,
              value: widget.isEvent
                  ? "${booking!.numberOfPersons} ${al.person}(s)"
                  : "-",
            ),
            SizedBox(height: getHeight() * 0.01),
            BookingInfoRow(
              label: al.date,
              value: widget.isEvent ? event!.date : "-",
            ),
            SizedBox(height: getHeight() * 0.01),
            BookingInfoRow(
              label: al.time,
              value: widget.isEvent
                  ? "${event!.startTime} - ${event!.endTime}"
                  : "-",
            ),
            SizedBox(height: getHeight() * 0.01),

            // AMOUNT (for events)
            BookingInfoRow(
              label: al.amount,
              value: widget.isEvent ? "\$${booking!.totalPrice}" : "-",
            ),

            // INTERNAL NOTES (only for non-event bookings if present)
            if (!widget.isEvent && booking?.internalNotes != null && booking!.internalNotes!.isNotEmpty) ...[
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
                text: booking!.internalNotes!,
                fontSize: sizes?.fontSize14,
                color: AppColors.primarySlateColor,
                giveLinesAsText: true,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEventImage(EventData event) {
    if (event.eventImages.isEmpty) {
      return Image.asset(
        Assets.restaurantImage,
        height: getHeight() * 0.2,
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      getImagePath(event.eventImages.first),
      height: getHeight() * 0.2,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.asset(
        Assets.restaurantImage,
        height: getHeight() * 0.2,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  String getImagePath(String? relativePath) {
    if (relativePath == null || relativePath.isEmpty) return "";

    const String baseUrl =
        "https://elasticbeanstalk-eu-west-3-838155148197.s3.eu-west-3.amazonaws.com/";

    if (relativePath.startsWith("http")) return relativePath;

    return baseUrl + relativePath;
  }
}
