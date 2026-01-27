import 'package:choice_app/screens/bookings/booking_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'booking_details.dart';
import 'bookings_widgets.dart';

class CancelledBookings extends StatefulWidget {
  const CancelledBookings({super.key});

  @override
  State<CancelledBookings> createState() => _CancelledBookingsState();
}

class _CancelledBookingsState extends State<CancelledBookings> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().fetchBookings('cancelled');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.cancelledBookings.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.cancelledBookings.isEmpty) {
          return const Center(child: Text("No cancelled bookings"));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: provider.cancelledBookings.length,
                itemBuilder: (context, index) {
                  final booking = provider.cancelledBookings[index];
                  return BookingCard(
                    name: booking.customerName,
                    imageUrl: booking.customerImage,
                    date: booking.startDateTime,
                    startTime: booking.startDateTime,
                    endTime: booking.endDateTime,
                    guests: booking.guestCount,
                    onDetails: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BookingDetails(isCancelled: true)),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
