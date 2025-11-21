import 'package:choice_app/customWidgets/no_item_found.dart';
import 'package:choice_app/models/get_user_bookings_response.dart';
import 'package:choice_app/screens/bookings/bookings_provider.dart';
import 'package:choice_app/screens/bookings/upcoming_bookings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../userRole/role_provider.dart';
import '../../userRole/user_role.dart';
import 'booking_details.dart';
import 'booking_details_user.dart';
import 'bookings_widgets.dart';

class CompletedBookings extends StatefulWidget {
  const CompletedBookings({super.key});

  @override
  State<CompletedBookings> createState() => _CompletedBookingsState();
}

class _CompletedBookingsState extends State<CompletedBookings> {
  BookingsProvider provider = BookingsProvider();

  @override
  void initState() {
    provider = Provider.of<BookingsProvider>(context, listen: false);
    provider.init(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getBookings(status: BookingStatus.completed);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bookingsProvider = Provider.of<BookingsProvider>(context);

    final role = context.watch<RoleProvider>().role;
    final bookingItems = _buildBookingItems(
      bookingsProvider.getCompletedBookingsResponse?.data,
      role,
    );

    return Column(
      children: [
        Expanded(
          child:
              bookingItems.isEmpty
                  ? NoItemFound(
                    title: 'No Completed Bookings',
                    subTitle: 'You have no completed bookings',
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: bookingItems.length,
                    itemBuilder: (context, index) {
                      final booking = bookingItems[index];

                      return BookingCard(
                        name: booking.name,
                        imageUrl: booking.imageUrl,
                        date: booking.date,
                        startTime: booking.startTime,
                        endTime: booking.endTime,
                        guests: booking.guests,
                        totalPrice: booking.totalPrice,
                        isEvent: booking.isEvent,
                        bookingId: booking.bookingId,
                        onDetails: () {
                          if (role == UserRole.user) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>  UserBookingDetails(
                                      bookingId: booking.bookingId!,
                                      isEvent: booking.isEvent ?? false,
                                    ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingDetails(bookingData: booking),
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
        ),
      );
    }

    return bookings;
  }
}
