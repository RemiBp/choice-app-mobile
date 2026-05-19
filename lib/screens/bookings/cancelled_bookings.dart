import 'package:choice_app/customWidgets/no_item_found.dart';
import 'package:choice_app/providers/producer_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'booking_details.dart';
import 'bookings_widgets.dart';

class CancelledBookings extends StatelessWidget {
  const CancelledBookings({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProducerProvider>(
      builder: (context, provider, _) {
        final items = provider.bookings
            .where((b) =>
                (b['status'] as String? ?? '').toLowerCase() == 'cancelled')
            .toList();

        if (provider.isLoadingBookings && items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (items.isEmpty) {
          return NoItemFound(
            title: 'No cancelled bookings',
            subTitle: 'Cancelled bookings will appear here.',
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.loadBookings(),
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final b = items[index];
              final user = b['user'] as Map<String, dynamic>? ?? {};
              return BookingCard(
                booking: b,
                name: user['fullName'] as String? ?? '—',
                imageUrl: user['profileImage'] as String? ?? '',
                date: b['startTime'] as String?,
                startTime: b['startTime'] as String?,
                endTime: b['endTime'] as String?,
                guests: (b['guests'] as num?)?.toInt() ?? 1,
                onDetails: () => context.push(
                  '/booking_details',
                  extra: {'booking': b, 'isCancelled': true},
                ),
              );
            },
          ),
        );
      },
    );
  }
}
