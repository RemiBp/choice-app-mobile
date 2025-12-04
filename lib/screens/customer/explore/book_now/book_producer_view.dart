import 'package:choice_app/screens/bookings/bookings_provider.dart';
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
import '../../../bookings/bookings_view.dart';
import '../../interested/interestedWidgets/time_slot_widgets.dart';
import '../../../bookings/upcoming_bookings.dart';

class BookProducerView extends StatefulWidget {
  final String? producerId; // for new booking
  final BookingCardData? bookingData; // existing booking for modify
  final bool isModify;

  const BookProducerView({
    super.key,
    this.producerId,
    this.bookingData,
    this.isModify = false,
  });

  @override
  State<BookProducerView> createState() => _BookProducerViewState();
}

class _BookProducerViewState extends State<BookProducerView> {
  late String currentProducerId;
  int persons = 2;
  int selectedDateIndex = -1;
  int selectedTimeIndex = -1;
  DateTime? selectedDate;
  final TextEditingController messageController = TextEditingController();
  late List<Map<String, String>> dates;

  @override
  void initState() {
    super.initState();

    // Determine current producer ID
    currentProducerId =
        widget.isModify
            ? widget.bookingData?.producerUserId ?? ''
            : widget.producerId ?? '';

    // Initialize from existing booking if modifying
    if (widget.isModify && widget.bookingData != null) {
      persons = widget.bookingData!.guests;
      messageController.text = widget.bookingData!.internalNotes ?? '';
      selectedDate = DateTime.tryParse(widget.bookingData!.date);
    }

    _generateDates(selectedDate ?? DateTime.now());

    // Fetch initial slots for the selected date
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (selectedDate != null && currentProducerId.isNotEmpty) {
        final formattedDate =
            "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";

        await context.read<CreateBookingProvider>().getRestaurantSlots(
          userId: currentProducerId,
          date: formattedDate,
        );
      }
    });
  }

  void _generateDates(DateTime month) {
    final today = DateTime.now();
    int startDay =
        (month.year == today.year && month.month == today.month)
            ? today.day
            : 1;

    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0).day;

    dates = List.generate(lastDayOfMonth - startDay + 1, (index) {
      final date = startDay + index;
      final dayName = _weekdayName(
        DateTime(month.year, month.month, date).weekday,
      );
      return {"day": dayName, "date": date.toString()};
    });
  }

  String _weekdayName(int weekday) {
    const names = [
      "Monday",
      "Tuesday",
      " Wednesday ",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];
    return names[weekday - 1];
  }

  String _monthAbbreviation(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<CreateBookingProvider>();
    final slotsResponse = bookingProvider.slotsResponse;

    String? selectedDayName =
        selectedDateIndex != -1 ? dates[selectedDateIndex]["day"] : null;

    List<Slot> slotsForSelectedDay =
        selectedDayName != null
            ? (slotsResponse?.slots[selectedDayName] ?? [])
            : [];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(
        title: widget.isModify ? 'Modify Reservation' : 'Book A Reservation',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: sizes!.pagePadding,
          vertical: getHeight() * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Select Date
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
                  month:
                      selectedDate != null
                          ? _monthAbbreviation(selectedDate!.month)
                          : _monthAbbreviation(DateTime.now().month),
                  onTap: () async {
                    final now = DateTime.now();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? now,
                      firstDate: now,
                      lastDate: DateTime(now.year + 5, 12, 31),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                        selectedDateIndex = -1;
                        selectedTimeIndex = -1;
                        _generateDates(picked);
                      });

                      Toasts.getSuccessToast(
                        text:
                            "${al.selected}: ${picked.day}/${picked.month}/${picked.year}",
                      );
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: getHeight() * 0.025),

            // Date Chips
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

                      final formattedDate =
                          "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
                      debugPrint("Modify Producer user id: ${currentProducerId}");

                      if (currentProducerId.isNotEmpty) {
                        await context
                            .read<CreateBookingProvider>()
                            .getRestaurantSlots(
                              userId: currentProducerId,
                              date: formattedDate,
                            );
                      }
                    },
                  );
                },
              ),
            ),
            SizedBox(height: getHeight() * 0.04),

            // Time Slots
            CustomText(
              text: al.selectTime,
              fontSize: sizes!.fontSize16,
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
            ),
            SizedBox(height: getHeight() * 0.02),
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
                  children: List.generate(slotsForSelectedDay.length, (index) {
                    final slot = slotsForSelectedDay[index];
                    final bool isSelected = selectedTimeIndex == index;

                    return TimeChip(
                      label: "${slot.startTime}-${slot.endTime}",
                      isSelected: isSelected,
                      onTap: () => setState(() => selectedTimeIndex = index),
                    );
                  }),
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

            // Special Requests
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

      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(height: 1, color: AppColors.greyBordersColor),
          Padding(
            padding: const EdgeInsets.all(20),
            child: CustomButton(
              buttonText:
                  widget.isModify
                      ? "Modify Your Reservation"
                      : "Book A Reservation",
              onTap: () async {
                if (selectedDateIndex == -1) {
                  Toasts.getErrorToast(text: "Please select a date");
                  return;
                }
                if (selectedTimeIndex == -1) {
                  Toasts.getErrorToast(text: "Please select a time slot");
                  return;
                }

                final slot = slotsForSelectedDay[selectedTimeIndex];
                final year = selectedDate?.year ?? DateTime.now().year;
                final month = selectedDate?.month ?? DateTime.now().month;
                final day = int.parse(dates[selectedDateIndex]["date"]!);
                final formattedDate =
                    "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";

                if (widget.isModify) {
                  final bookingIdString = widget.bookingData?.bookingId;
                  final bookingId = int.tryParse(bookingIdString.toString());

                  if (bookingId == null) {
                    Toasts.getErrorToast(text: "Invalid booking ID");
                    return;
                  }

                  final success = await context.read<BookingsProvider>().updateBooking(
                    bookingId: bookingId,
                    slotId: slot.id,
                    guestCount: persons,
                    date: formattedDate,
                    specialRequest: messageController.text,
                    timeZone: "Asia/Karachi",
                  );

                  if (success) {
                    Toasts.getSuccessToast(text: "Reservation updated!");

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => BookingsView()),
                          (route) => route.isFirst,
                    );
                  }

                  return;
                }

                //CREATE BOOKING FLOW

                final success = await context.read<CreateBookingProvider>().createNonEventBooking(
                  restaurantId: int.parse(currentProducerId),
                  slotId: slot.id,
                  date: formattedDate,
                  guestCount: persons,
                  specialRequest: messageController.text,
                );

                if (success) {
                  Toasts.getSuccessToast(text: "Reservation created!");

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => BookingsView()),
                        (route) => route.isFirst,
                  );
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
