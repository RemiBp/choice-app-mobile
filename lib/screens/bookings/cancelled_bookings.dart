import 'package:choice_app/customWidgets/no_item_found.dart';
import 'package:choice_app/models/get_user_bookings_response.dart';
import 'package:choice_app/screens/bookings/bookings_provider.dart';
import 'package:choice_app/screens/bookings/cancelled_booking_details.dart';
import 'package:choice_app/screens/bookings/upcoming_bookings.dart';
import 'package:choice_app/userRole/role_provider.dart';
import 'package:choice_app/userRole/user_role.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bookings_widgets.dart';

class CancelledBookings extends StatefulWidget {
  const CancelledBookings({super.key});

  @override
  State<CancelledBookings> createState() => _CancelledBookingsState();
}

class _CancelledBookingsState extends State<CancelledBookings> {
  BookingsProvider provider = BookingsProvider();

  @override
  void initState() {
    provider = Provider.of<BookingsProvider>(context, listen: false);
    provider.init(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getBookings(status: BookingStatus.cancelled);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bookingsProvider = Provider.of<BookingsProvider>(context);

    final role = context.watch<RoleProvider>().role;
    final bookingItems = _buildBookingItems(
      bookingsProvider.getCancelledBookingsResponse?.data,
      role,
    );

    return Column(
      children: [
        Expanded(
          child:
              bookingItems.isEmpty
                  ? NoItemFound(
                    title: 'No Cancelled Bookings',
                    subTitle: 'You have no cancelled bookings',
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: bookingItems.length,
                    itemBuilder: (context, index) {
                      final booking = bookingItems[index];

                      return BookingCard(
                        name: booking.name,
                        imageUrl: booking.imageUrl,
                        bookingType: booking.type ?? "Unknown", // for chips
                        date: booking.date,
                        startTime: booking.startTime,
                        endTime: booking.endTime,
                        guests: booking.guests,
                        totalPrice: booking.totalPrice,
                        isEvent: booking.isEvent,
                        bookingId: booking.bookingId,
                        onCancel: () {},
                        onDetails: () {
                          if (role == UserRole.user) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>CancelledBookingDetails(
                                      cancelReason: booking.cancelReason!,
                                    ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        CancelledBookingDetails(
                                          cancelReason: booking.cancelReason!,
                                        ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
        ),
      ],
    );
  }

  List<BookingCardData> _buildBookingItems(
    UserBookingsData? data,
    UserRole role,
  ) {
    if (data == null) {
      return [];
    }

    final isUser = role == UserRole.user;
    final bookings = <BookingCardData>[];

    for (final entry in data.eventBookings ?? []) {
      final booking = entry.booking;
      final event = booking?.event;
      final eventImages = event?.eventImages ?? [];
      final eventName = event?.title ?? '';
      final producerName = entry.producer?.name ?? event?.producer?.name ?? '';

      bookings.add(
        BookingCardData(
          name:
              isUser
                  ? eventName
                  : (producerName.isNotEmpty ? producerName : eventName),
          imageUrl: eventImages.isNotEmpty ? eventImages.first : '',
          date: event?.date ?? '',
          startTime: event?.startTime ?? '',
          endTime: event?.endTime ?? '',
          guests: booking?.numberOfPersons ?? 0,
          totalPrice: booking?.totalPrice,
          bookingId: booking?.id?.toString(),
          isEvent: true,
          type: event?.serviceType,
          cancelReason: booking?.internalNotes ?? "No reason provided",
        ),
      );
    }

    for (final entry in data.restaurantBookings ?? []) {
      final booking = entry.booking;
      final restaurant = booking?.restaurant;
      final customer = booking?.customer;

      final restaurantName =
          entry.producer?.name ??
          restaurant?.producer?.name ??
          restaurant?.fullName ??
          restaurant?.userName ??
          '';
      final customerName = customer?.fullName ?? booking?.customerName ?? '';

      bookings.add(
        BookingCardData(
          name:
              isUser
                  ? restaurantName
                  : (customerName.isNotEmpty ? customerName : restaurantName),
          imageUrl: restaurant?.profileImageUrl ?? '',
          date: booking?.bookingDate ?? booking?.date ?? '',
          startTime: booking?.slotStartTime ?? booking?.startDateTime ?? '',
          endTime: booking?.slotEndTime ?? booking?.endDateTime ?? '',
          guests: booking?.guestCount ?? 0,
          totalPrice: null,
          bookingId: booking?.id?.toString(),
          isEvent: false,
          cancelReason: booking?.cancelReason ?? "No reason provided",
          type: entry.producer?.type,
        ),
      );
    }

    return bookings;
  }
}
