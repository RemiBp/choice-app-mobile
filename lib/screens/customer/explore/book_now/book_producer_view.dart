import 'package:flutter/material.dart';

import '../../../../appColors/colors.dart';
import '../../../../customWidgets/common_app_bar.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../l18n.dart';
import '../../../../res/res.dart';
import '../../../../res/toasts.dart';
import '../../interested/interestedWidgets/time_slot_widgets.dart';


class BookProducerView extends StatefulWidget {
  const BookProducerView({super.key});

  @override
  State<BookProducerView> createState() => _BookProducerViewState();
}

class _BookProducerViewState extends State<BookProducerView> {

  int persons = 2;
  int selectedDateIndex = -1;
  int selectedTimeIndex = -1;
  DateTime? selectedDate;
  final TextEditingController messageController = TextEditingController();

  final List<Map<String, String>> dates = [
    {"day": "Mon", "date": "24"},
    {"day": "Tue", "date": "25"},
    {"day": "Wed", "date": "26"},
    {"day": "Thu", "date": "27"},
    {"day": "Fri", "date": "28"},
    {"day": "Sat", "date": "29"},
    {"day": "Sun", "date": "30"},
  ];

  final List<String> timeSlots = [
    "11AM-12AM",
    "12AM-1PM",
    "1PM-2PM",
    "2PM-3PM",
    "3PM-4PM",
    "5PM-6PM",
    "7PM-8PM",
    "9PM-10PM",
    "10PM-11PM",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(
        title: 'Book A Reservation',
      ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: sizes!.pagePadding,
            vertical: getHeight() * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Header with right-aligned month chip
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
                    : "Jan",
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    setState(() => selectedDate = picked);
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
              itemCount: dates.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final item = dates[index];
                final bool isSelected = selectedDateIndex == index;
                return DateChip(
                  day: item["day"]!,
                  date: item["date"]!,
                  isSelected: isSelected,
                  onTap: () => setState(() => selectedDateIndex = index),
                );
              },
            ),
          ),

          SizedBox(height: getHeight() * 0.04),
              // Select Time
              CustomText(
                text: al.selectTime,
                fontSize: sizes!.fontSize16,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
              ),
              SizedBox(height: getHeight() * 0.02),

              // Time Chips
              Wrap(
                spacing: 17,
                runSpacing: 12,
                children: List.generate(timeSlots.length, (index) {
                  final isSelected = selectedTimeIndex == index;
                  return TimeChip(
                    label: timeSlots[index],
                    isSelected: isSelected,
                    onTap: () => setState(() => selectedTimeIndex = index),
                  );
                }),
              ),

              SizedBox(height: getHeight() * 0.04),

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
              SizedBox(height: getHeight() * 0.04),

              // Message field
              CustomText(
                text: 'Any Special Requests?',
                fontSize: sizes!.fontSize16,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
              ),
              SizedBox(height: getHeight() * 0.01),

              MessageField(controller: messageController),

              SizedBox(height: getHeight() * 0.05),
            ],
          ),
        ),
    );
  }

  String _monthAbbreviation(int month) {
    const months = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
    ];
    return months[month - 1];
  }
}
