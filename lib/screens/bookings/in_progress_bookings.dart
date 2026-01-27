import 'package:choice_app/screens/bookings/booking_details.dart';
import 'package:choice_app/screens/bookings/booking_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bookings_widgets.dart';

class InProgressBookings extends StatefulWidget {
  const InProgressBookings({super.key});

  @override
  State<InProgressBookings> createState() => _InProgressBookingsState();
}

class _InProgressBookingsState extends State<InProgressBookings> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().fetchBookings('inProgress');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.inProgressBookings.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.inProgressBookings.isEmpty) {
          return const Center(child: Text("No in-progress bookings"));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: provider.inProgressBookings.length,
                itemBuilder: (context, index) {
                  final booking = provider.inProgressBookings[index];
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
                    // In progress bookings can't be checked in again, 
                    // but they can be cancelled depending on business logic.
                    // For now, only show details as per original mockup intention if any.
                    onCheckIn: null, 
                    onCancel: null,
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
