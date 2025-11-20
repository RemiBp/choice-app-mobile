import 'package:choice_app/customWidgets/no_item_found.dart';
import 'package:choice_app/models/get_user_bookings_response.dart';
import 'package:choice_app/res/toasts.dart';
import 'package:choice_app/screens/bookings/booking_details.dart';
import 'package:choice_app/screens/bookings/booking_details_user.dart';
import 'package:choice_app/screens/bookings/bookings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../customWidgets/blurry_back_ground.dart';
import '../../l18n.dart';
import '../../userRole/role_provider.dart';
import '../../userRole/user_role.dart';
import '../../utilities/timezone_helper.dart';
import '../customer/explore/book_now/book_producer_view.dart';
import 'bookings_widgets.dart';

class UpcomingBookings extends StatefulWidget {
  const UpcomingBookings({super.key});

  @override
  State<UpcomingBookings> createState() => _UpcomingBookingsState();
}

class _UpcomingBookingsState extends State<UpcomingBookings> {
  TextEditingController reasonController = TextEditingController();
  BookingsProvider provider = BookingsProvider();

  @override
  void initState() {
    provider = Provider.of<BookingsProvider>(context, listen: false);
    provider.init(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getBookings(status: BookingStatus.scheduled);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final bookingsProvider = context.watch<BookingsProvider>();
    final bookingsProvider = Provider.of<BookingsProvider>(context);

    final role = context.watch<RoleProvider>().role;
    final bookingItems = _buildBookingItems(
      bookingsProvider.getUpcomingBookingsResponse?.data,
      role,
    );

    return Column(
      children: [
        Expanded(
          child:
              bookingItems.isEmpty
                  ? NoItemFound()
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
                        address: booking.address,
                        buttonText: booking.buttonText,
                        onDetails: ({bool isFromModifyButton = false}) {
                          if (role == UserRole.user) {
                            if (isFromModifyButton) {
                              // Only modify button should reach here
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookProducerView(
                                    bookingData: booking,
                                    isModify: true,
                                  ),
                                ),
                              );
                              return;
                            }

                            // Card tap → always go to UserBookingDetails
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserBookingDetails(
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
                        onCheckIn: () async {
                          final bookingIdStr = booking.bookingId;
                          if (bookingIdStr == null || bookingIdStr.isEmpty) {
                            Toasts.getErrorToast(text: "Booking ID not available");
                            return;
                          }

                          final bookingId = int.tryParse(bookingIdStr);
                          if (bookingId == null) {
                            Toasts.getErrorToast(text: "Invalid booking ID");
                            return;
                          }

                          bool success = false;

                          if (booking.isEvent == true) {
                            // Event booking
                            success = await provider.checkInBooking(bookingId: bookingId);
                          } else {
                            // Normal booking
                            success = await provider.checkInSimpleBooking(
                              bookingId: bookingId,
                              timeZone: TimezoneHelper.cachedTimeZone ?? 'UTC', // Success: Uses the cached value
                            );
                          }

                          if (success) {
                            // Refresh bookings after successful check-in
                            await provider.getBookings(status: BookingStatus.scheduled);
                          }
                        },
                        onCancel: () {
                          showCancelConfirmationAlert(
                            context: context,
                            booking: booking,   //  Pass whole booking
                          );
                        },
                      );
                    },
                  ),
        ),
      ],
    );
  }

  void showCancelConfirmationAlert({
    required BuildContext context,
    required BookingCardData booking,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlurryBackground(
          child: CancelConfirmationAlert(
            controller: reasonController,
            onConfirm: () async {
              if (reasonController.text.isEmpty) {
                Toasts.getErrorToast(text: al.provideAReason);
                return;
              }

              final isEvent = booking.isEvent ?? false;
              final id = int.parse(booking.bookingId ?? '0');

              bool success;

              if (isEvent) {
                success = await provider.cancelBooking(
                  bookingId: id,
                  reason: reasonController.text,
                );
              } else {

                success = await provider.cancelBookingForProducer(
                  bookingId: id,
                  reason: reasonController.text,
                  timeZone: TimezoneHelper.cachedTimeZone ?? 'UTC',
                );
              }

              if (success) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingDetails(
                      isCancelled: true,
                      cancellationReason: reasonController.text,
                    ),
                  ),
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
        );
      },
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
          buttonText: isUser ? 'View' : al.checkIn, //  user sees View and producer sees "Check-In"
          address: event?.venueName ?? event?.location,
          customerName: isUser ? null : null,
          customerEmail: isUser ? null : entry.producer?.user?.email,
          customerPhone: isUser ? null : entry.producer?.user?.phoneNumber,
          internalNotes: booking?.internalNotes,
          type: event?.serviceType,
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
          producerId: entry.producer?.id?.toString(),
          producerUserId: entry.producer?.userId?.toString(),
          isEvent: false,
          buttonText: isUser ? al.modify : al.checkIn, //  user sees "Modify", producer sees "Check-In"
          address: entry.producer?.address ?? booking?.location,
          customerName:
              isUser
                  ? customerName
                  : (customerName.isNotEmpty
                      ? customerName
                      : booking?.customerName),
          customerEmail: customer?.email,
          customerPhone: customer?.phoneNumber?.toString(),
          internalNotes: booking?.specialRequest,
          type: entry.producer?.type,
        ),
      );
    }

    return bookings;
  }
}

class BookingCardData {
  final String name;
  final String imageUrl;
  final String? producerUserId;
  final String date;
  final String startTime;
  final String endTime;
  final int guests;
  final String? totalPrice;
  final String? bookingId;
  final bool? isEvent;
  final String? address;
  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;
  final String? internalNotes;
  final String buttonText;
  final String? producerId;
  final String? type;


  const BookingCardData({
    required this.name,
    required this.imageUrl,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.guests,
    this.totalPrice,
    this.bookingId,
    this.isEvent,
    this.address,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    this.internalNotes,
    this.buttonText = '', // default empty
    this.producerId,
    this.producerUserId,
    this.type
  });
}
