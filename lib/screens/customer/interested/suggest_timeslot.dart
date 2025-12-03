import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/customWidgets/common_app_bar.dart';
import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/customWidgets/custom_button.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/res/toasts.dart';
import '../../../l18n.dart';
import 'interestedWidgets/time_slot_widgets.dart';

class SuggestTimeSlotScreen extends StatefulWidget {
  final TimeSlotMode mode;

  const SuggestTimeSlotScreen({super.key, required this.mode});

  @override
  State<SuggestTimeSlotScreen> createState() => _SuggestTimeSlotScreenState();
}

class _SuggestTimeSlotScreenState extends State<SuggestTimeSlotScreen> {
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
    final isEdit = widget.mode == TimeSlotMode.edit;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(
        title: isEdit ? al.editTimeSlot : al.suggestTimeSlot,
      ),

      bottomNavigationBar: SafeArea(
        minimum: EdgeInsets.all(sizes!.pagePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(
              color: AppColors.greyBordersColor,
              thickness: 1,
              height: 1,
            ),
            SizedBox(height: getHeight() * 0.012),

            CustomButton(
              buttonText: isEdit ? al.confirm : al.continueText,
              onTap: () {
                if (selectedDateIndex == -1 && selectedDate == null) {
                  Toasts.getErrorToast(text: al.pleaseSelectDate);
                  return;
                }
                if (selectedTimeIndex == -1) {
                  Toasts.getErrorToast(text: al.pleaseSelectTime);
                  return;
                }
                context.push(Routes.selectFriendsRoute);
              },
              buttonWidth: double.infinity,
              backgroundColor: AppColors.getPrimaryColorFromContext(context),
              borderColor: Colors.transparent,
              textColor: AppColors.whiteColor,
              textFontWeight: FontWeight.w600,
            ),
          ],
        ),
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
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Number of items per row
                crossAxisSpacing: 12, // Horizontal spacing
                mainAxisSpacing: 12, // Vertical spacing
                childAspectRatio: 2.5, // Width/Height ratio
              ),
              itemCount: timeSlots.length,
              itemBuilder: (context, index) {
                final isSelected = selectedTimeIndex == index;
                return TimeChip(
                  label: timeSlots[index],
                  isSelected: isSelected,
                  onTap: () => setState(() => selectedTimeIndex = index),
                );
              },
            ),

            SizedBox(height: getHeight() * 0.04),

            // Message field
            CustomText(
              text: al.message,
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


// Will Be used to tell the system whether he wants to edit a time slot or suggest a time slot

enum TimeSlotMode { suggest, edit }

