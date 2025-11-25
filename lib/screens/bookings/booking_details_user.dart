import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../appAssets/app_assets.dart';
import '../../appColors/colors.dart';
import '../../customWidgets/common_app_bar.dart';
import '../../customWidgets/custom_text.dart';
import '../../l18n.dart';
import '../../models/get_event_booking_details_response.dart';
import '../../models/get_normal_booking_details_response.dart';
import '../../res/res.dart';
import 'bookings_provider.dart';
import 'bookings_widgets.dart';


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

    Future.microtask(() {
      final provider = context.read<BookingsProvider>();

      if (widget.isEvent) {
        provider.fetchEventBookingDetails(context, int.parse(widget.bookingId));
      } else {
        provider.fetchSimpleBookingDetails(context, int.parse(widget.bookingId));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingsProvider>();

    final eventData = provider.eventBookingDetails?.data;
    final simpleData = provider.simpleBookingDetails?.booking;

    final isLoading = widget.isEvent
        ? provider.eventBookingDetails == null
        : provider.simpleBookingDetails == null;

    if (isLoading) {
      return Scaffold(
        appBar: CommonAppBar(title: al.bookingDetails),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(title: al.bookingDetails),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: sizes!.pagePadding,
          vertical: getHeight() * 0.02,
        ),
        child: widget.isEvent
            ? _buildEventBookingUI(eventData!)
            : _buildSimpleBookingUI(simpleData!),
      ),
    );
  }

  // EVENT BOOKING UI


  Widget _buildEventBookingUI(BookingData booking) {
    final event = booking.event;

    return ListView(
      children: [
        CustomText(
          text: al.bookingInformation,
          fontSize: sizes?.fontSize16,
          color: AppColors.blackColor,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: getHeight() * 0.02),

        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _buildEventImage(event),
        ),
        SizedBox(height: getHeight() * 0.02),

        CustomText(
          text: event.title,
          fontSize: sizes?.fontSize16,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 4),
        CustomText(
          text: event.location,
          fontSize: sizes?.fontSize14,
          color: AppColors.primarySlateColor,
        ),
        SizedBox(height: getHeight() * 0.02),

        BookingInfoRow(label: al.bookingId, value: "#${booking.id}"),
        SizedBox(height: 10),
        BookingInfoRow(
            label: al.numberOfPersons,
            value: "${booking.numberOfPersons} ${al.person}(s)"),
        SizedBox(height: 10),
        BookingInfoRow(label: al.date, value: formatDisplayDate(event.date)),
        SizedBox(height: 10),
        BookingInfoRow(
            label: al.time,
            value: "${event.startTime} - ${event.endTime}"),
        SizedBox(height: 10),
        BookingInfoRow(
            label: al.amount, value: "\$${booking.totalPrice}"),
      ],
    );
  }

  // SIMPLE BOOKING UI

  Widget _buildSimpleBookingUI(SimpleBookingData booking) {
    return ListView(
      children: [
        CustomText(
          text: al.bookingInformation,
          fontSize: sizes?.fontSize16,
          color: AppColors.blackColor,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: getHeight() * 0.02),

        // Image
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            Assets.restaurantImage,
            height: getHeight() * 0.2,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: getHeight() * 0.02),

        // Producer title
        CustomText(
          text: booking.customerName ?? "N/A",
          fontSize: sizes?.fontSize16,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 4),

        // Address
        CustomText(
          text: booking.location ?? "No address",
          fontSize: sizes?.fontSize14,
          color: AppColors.primarySlateColor,
        ),
        SizedBox(height: getHeight() * 0.02),

        // Booking info
        BookingInfoRow(label: al.bookingId, value: "#${booking.id}"),
        SizedBox(height: 10),
        BookingInfoRow(label: al.numberOfPersons, value: "${booking.guestCount}"),
        SizedBox(height: 10),
        BookingInfoRow(
            label: al.date, value: formatDisplayDate(booking.bookingDate)),
        SizedBox(height: 10),
        BookingInfoRow(
          label: al.time,
          value: "${booking.slotStartTime} - ${booking.slotEndTime}",
        ),
        SizedBox(height: getHeight() * 0.03),

        // Divider + Internal Notes
        Divider(color: AppColors.greyBordersColor),
        SizedBox(height: getHeight() * 0.02),

        CustomText(
          text: al.internalNotes,
          fontSize: sizes?.fontSize16,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: getHeight() * 0.01),

        CustomText(
          text: booking.specialRequest ?? "No Internal Notes Added",
          giveLinesAsText: true,
          fontSize: sizes?.fontSize14,
          color: AppColors.primarySlateColor,
        ),
      ],
    );
  }

  // UTILITIES

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

  Widget _buildEventImage(EventData event) {
    if (event.eventImages.isEmpty || event.eventImages.first.isEmpty) {
      return Image.asset(
        Assets.restaurantImage,
        height: getHeight() * 0.2,
        fit: BoxFit.cover,
      );
    }

    final img = getImagePath(event.eventImages.first);

    return Image.network(
      img,
      height: getHeight() * 0.2,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Image.asset(
          Assets.restaurantImage,
          height: getHeight() * 0.2,
          fit: BoxFit.cover,
        );
      },
    );
  }

  String getImagePath(String relative) {
    if (relative.isEmpty) return "";

    const base =
        "https://elasticbeanstalk-eu-west-3-838155148197.s3.eu-west-3.amazonaws.com/";

    // Already a complete URL
    if (relative.startsWith("http")) return relative;

    // Otherwise prepend base URL
    return base + relative;
  }
}
