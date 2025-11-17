import 'package:choice_app/screens/customer/explore/book_now/create_booking_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../appColors/colors.dart';
import '../../../../customWidgets/common_app_bar.dart';
import '../../../../customWidgets/custom_button.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../l18n.dart';
import '../../../../models/get_producer_booking_slots_response.dart';
import '../../../../res/res.dart';
import '../../../../res/toasts.dart';
import '../../interested/interestedWidgets/time_slot_widgets.dart';

class BookProducerView extends StatefulWidget {
  final String producerId;

  const BookProducerView({super.key, required this.producerId});

  @override
  State<BookProducerView> createState() => _BookProducerViewState();
}

class _BookProducerViewState extends State<BookProducerView> {
  int persons = 2;
  int selectedDateIndex = -1;
  int selectedTimeIndex = -1;
  DateTime? selectedDate;
  final TextEditingController messageController = TextEditingController();

  late List<Map<String, String>> dates;

  @override
  void initState() {
    super.initState();
    _generateDates(DateTime.now());
  }

  // Generate dynamic date chips from today till end of current month
  void _generateDates(DateTime month) {
    final today = DateTime.now();
    int startDay = 1;
    if (month.year == today.year && month.month == today.month) {
      startDay = today.day; // start from today
    }

    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0).day;

    dates = List.generate(lastDayOfMonth - startDay + 1, (index) {
      final date = startDay + index;
      final dayName =
      _weekdayName(DateTime(month.year, month.month, date).weekday);
      return {"day": dayName, "date": date.toString()};
    });
  }

  String _weekdayName(int weekday) {
    const names = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"];
    return names[weekday - 1];
  }

  String _monthAbbreviation(int month) {
    const months = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<CreateBookingProvider>();
    final slotsResponse = bookingProvider.slotsResponse;

    // Determine selected day name
    String? selectedDayName =
    selectedDateIndex != -1 ? dates[selectedDateIndex]["day"] : null;

    // Fetch slots for selected day
    List<Slot> slotsForSelectedDay = selectedDayName != null
        ? (slotsResponse?.slots[selectedDayName] ?? [])
        : [];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(title: 'Book A Reservation'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: sizes!.pagePadding,
          vertical: getHeight() * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Select Date text + calendar button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: al.selectDate,
                  fontSize: sizes!.fontSize16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
                CalendarButton(
                  month: selectedDate != null
                      ? _monthAbbreviation(selectedDate!.month)
                      : _monthAbbreviation(DateTime.now().month),
                  onTap: () async {
                    final now = DateTime.now();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? now,
                      firstDate: now, // today onwards
                      lastDate: DateTime(now.year + 5, 12, 31), // allow next 5 years
                    );

                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                        selectedDateIndex = -1;
                        selectedTimeIndex = -1;
                        _generateDates(picked); // regenerate chips for the picked month
                      });

                      Toasts.getSuccessToast(
                        text: "${al.selected}: ${picked.day}/${picked.month}/${picked.year}",
                      );
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: getHeight() * 0.025),

            // Dynamic Date Chips
            SizedBox(
              height: 54,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemCount: dates.length,
                itemBuilder: (context, index) {
                  final item = dates[index];
                  final bool isSelected = selectedDateIndex == index;

                  return DateChip(
                    day: item["day"]!,
                    date: item["date"]!,
                    isSelected: isSelected,
                      onTap: () async {
                        setState(() {
                          selectedDateIndex = index;
                          selectedTimeIndex = -1;
                        });

                        final year = selectedDate?.year ?? DateTime.now().year;
                        final month = selectedDate?.month ?? DateTime.now().month;
                        final day = int.parse(item["date"]!);

                        final formattedDate = "$year-${month.toString().padLeft(2,'0')}-${day.toString().padLeft(2,'0')}";

                        await context
                            .read<CreateBookingProvider>()
                            .getProducerSlots(
                          producerId: widget.producerId,
                          date: formattedDate,
                        );
                      }
                  );
                },
              ),
            ),
            SizedBox(height: getHeight() * 0.04),

            // Select Time Title
            CustomText(
              text: al.selectTime,
              fontSize: sizes!.fontSize16,
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
            ),
            SizedBox(height: getHeight() * 0.02),

            // Dynamic Time Slots from API
            bookingProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : slotsForSelectedDay.isEmpty
                ? CustomText(
              text: "No slots available for this date",
              color: AppColors.blackColor,
            )
                : Wrap(
              spacing: 17,
              runSpacing: 12,
              children: List.generate(
                slotsForSelectedDay.length,
                    (index) {
                  final slot = slotsForSelectedDay[index];
                  final bool isSelected = selectedTimeIndex == index;

                  return TimeChip(
                    label: "${slot.startTime}-${slot.endTime}",
                    isSelected: isSelected,
                    onTap: () =>
                        setState(() => selectedTimeIndex = index),
                  );
                },
              ),
            ),

            SizedBox(height: getHeight() * 0.04),

            // Number of Persons
            CustomText(
              text: al.numberOfPersons2,
              fontSize: sizes!.fontSize16,
              color: AppColors.blackColor,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: getHeight() * 0.01),

            PersonCounterWidget(
              value: persons,
              onIncrement: () => setState(() => persons++),
              onDecrement: () => persons > 1 ? setState(() => persons--) : null,
            ),

            SizedBox(height: getHeight() * 0.04),

            // Message field
            CustomText(
              text: 'Any Special Requests?',
              fontSize: sizes!.fontSize16,
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
            ),
            SizedBox(height: getHeight() * 0.01),

            InternalNotesField(controller: messageController),

            SizedBox(height: getHeight() * 0.05),
          ],
        ),
      ),

      // Bottom Button
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(height: 1, color: AppColors.greyBordersColor),
          Padding(
            padding: const EdgeInsets.all(20),
            child: CustomButton(
              buttonText: "Book A Reservation",
              onTap: () async {
                if (selectedDateIndex == -1) {
                  Toasts.getErrorToast(text: "Please select a date");
                  return;
                }
                if (selectedTimeIndex == -1) {
                  Toasts.getErrorToast(text: "Please select a time slot");
                  return;
                }

                // Get slot info from the selected chip
                final slot = slotsForSelectedDay[selectedTimeIndex];

                // Format date for API (yyyy-MM-dd)
                final year = selectedDate?.year ?? DateTime.now().year;
                final month = selectedDate?.month ?? DateTime.now().month;
                final day = int.parse(dates[selectedDateIndex]["date"]!);
                final formattedDate =
                    "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";

                // Call non-event booking API
                final success = await context.read<CreateBookingProvider>().createNonEventBooking(
                  restaurantId: int.parse(widget.producerId),
                  slotId: slot.id,
                  date: formattedDate,
                  guestCount: persons,
                  specialRequest: messageController.text,
                );

                if (success) {
                  Toasts.getSuccessToast(text: "Reservation created!");
                  Navigator.pop(context);
                }
              },
              backgroundColor: AppColors.userPrimaryColor,
              textColor: AppColors.whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}
