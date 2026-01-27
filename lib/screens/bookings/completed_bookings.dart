import 'package:choice_app/screens/bookings/booking_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'booking_details.dart';
import 'bookings_widgets.dart';

class CompletedBookings extends StatefulWidget {
  const CompletedBookings({super.key});

  @override
  State<CompletedBookings> createState() => _CompletedBookingsState();
}

class _CompletedBookingsState extends State<CompletedBookings> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().fetchBookings('completed');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.completedBookings.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.completedBookings.isEmpty) {
          return const Center(child: Text("No completed bookings"));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: provider.completedBookings.length,
                itemBuilder: (context, index) {
                  final booking = provider.completedBookings[index];
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
                        MaterialPageRoute(builder: (context) => const BookingDetails()),
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
