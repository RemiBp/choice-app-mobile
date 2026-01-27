import 'package:choice_app/screens/bookings/booking_details.dart';
import 'package:choice_app/screens/bookings/booking_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../customWidgets/blurry_back_ground.dart';
import 'bookings_widgets.dart';

class UpcomingBookings extends StatefulWidget {
  const UpcomingBookings({super.key});

  @override
  State<UpcomingBookings> createState() => _UpcomingBookingsState();
}

class _UpcomingBookingsState extends State<UpcomingBookings> {
  TextEditingController reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().fetchBookings('scheduled');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.upcomingBookings.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.upcomingBookings.isEmpty) {
          return const Center(child: Text("No upcoming bookings"));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: provider.upcomingBookings.length,
                itemBuilder: (context, index) {
                  final booking = provider.upcomingBookings[index];
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
                    onCheckIn: () {
                      provider.checkIn(booking.id).then((success) {
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Checked in successfully")),
                          );
                        }
                      });
                    },
                    onCancel: () {
                      showCancelConfirmationAlert(context: context, id: booking.id);
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

  void showCancelConfirmationAlert({required BuildContext context, required int id}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlurryBackground(
          child: CancelConfirmationAlert(
            controller: reasonController,
            onConfirm: () async {
              final success = await context.read<BookingProvider>().cancel(id, reasonController.text);
              if (success) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Booking cancelled")),
                );
              }
            },
          ),
        );
      },
    );
  }
}
