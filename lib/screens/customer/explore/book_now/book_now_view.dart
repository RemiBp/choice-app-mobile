import 'package:choice_app/res/toasts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../appColors/colors.dart';
import '../../../../customWidgets/common_app_bar.dart';
import '../../../../customWidgets/custom_button.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../l18n.dart';
import '../../../../res/res.dart';
import '../../interested/interestedWidgets/time_slot_widgets.dart';
import 'create_booking_provider.dart';

class BookNowScreen extends StatefulWidget {
  final int eventId;
  final double pricePerPerson;
  const BookNowScreen({
    super.key,
    required this.eventId,
    required this.pricePerPerson,
  });

  @override
  State<BookNowScreen> createState() => _BookNowScreenState();
}

class _BookNowScreenState extends State<BookNowScreen> {
  int persons = 2;
  double get pricePerPerson => widget.pricePerPerson;

  @override
  Widget build(BuildContext context) {
    double totalPrice = persons * pricePerPerson;
    final provider = Provider.of<CreateBookingProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(title: al.bookNow),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: al.numberOfPersons2,
              fontSize: sizes?.fontSize14,
              color: AppColors.blackColor,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: getHeight() * 0.01),
            PersonCounterWidget(
              value: persons,
              onIncrement: () => setState(() => persons++),
              onDecrement: () => setState(() => persons--),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding, vertical: getHeight() * 0.02),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withAlpha(20),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CustomText(
                  text: "$persons ${al.person}",
                  fontSize: sizes?.fontSize12,
                  color: AppColors.primarySlateColor,
                  fontWeight: FontWeight.w500,
                ),
                const Spacer(),
                CustomText(
                  text: "\$${totalPrice.toStringAsFixed(2)}",
                  fontSize: sizes?.fontSize16,
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w600,
                )
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                CustomText(
                  text: "\$${pricePerPerson.toStringAsFixed(2)}",
                  fontSize: sizes?.fontSize16,
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w600,
                ),
                CustomText(
                  text: al.perPerson,
                  fontSize: sizes?.fontSize12,
                  color: AppColors.primarySlateColor,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            SizedBox(height: getHeight() * 0.02),
            CustomButton(
              buttonText: al.continueText,
              onTap: provider.isLoading
                  ? null
                  : () async {
                bool ok = await provider.createEventBooking(
                  eventId: widget.eventId,
                  guestCount: persons,
                );

                if (ok) {
                  // Show toast
                  Toasts.getSuccessToast(text: "Booking confirmed successfully!");

                  // Navigate back
                  Navigator.pop(context, true); // booking successful
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
