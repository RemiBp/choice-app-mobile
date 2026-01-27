import 'package:choice_app/screens/restaurant/dashboard/home_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../onboarding_provider.dart';
import 'package:intl/intl.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/common_app_bar.dart';
import '../../../customWidgets/custom_button.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../customWidgets/text_field_label.dart';
import '../../../res/res.dart';
import '../slot_management/slot_management_view.dart';
import '../slot_management/slot_management_widgets.dart';
import 'days_off_widgets.dart';


class DaysOffView extends StatefulWidget {
  const DaysOffView({super.key});

  @override
  State<DaysOffView> createState() => _DaysOffViewState();
}

class _DaysOffViewState extends State<DaysOffView> {
  TextEditingController leaveDateController = TextEditingController(
    text: DateFormat('MM/dd/yyyy').format(DateTime.now()),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _fetchSlotsForCurrentDate();
    });
  }

  void _fetchSlotsForCurrentDate() {
    DateTime parsedDate = DateFormat('MM/dd/yyyy').parse(leaveDateController.text);
    String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
    context.read<OnboardingProvider>().fetchSlotsByDate(formattedDate);
  }

  List<int> selectedSlotIds = [];
  bool isSelectAllChecked = false;

  @override
  void dispose() {
    leaveDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateFormat('MM/dd/yyyy').parse(leaveDateController.text),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.getPrimaryColorFromContext(context),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.blackColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        leaveDateController.text = DateFormat('MM/dd/yyyy').format(picked);
        selectedSlotIds.clear();
        isSelectAllChecked = false;
      });
      _fetchSlotsForCurrentDate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: const CommonAppBar(title: "Unavailability"),
      body: Consumer<OnboardingProvider>(
        builder: (context, provider, _) {
          final List<Slots> allSlots = provider.slotsByDate.map((s) => Slots.fromJson(s)).toList();

          return Container(
            padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      SizedBox(height: getHeightRatio() * 16),
                      const TextFieldLabel(
                        label: "Date",
                      ),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: DatePickerTile(
                            hintText: "Select Date",
                            controller: leaveDateController,
                          ),
                        ),
                      ),
                      SizedBox(height: getHeight() * 0.02),
                      if (allSlots.isNotEmpty)
                        EditDaysTile(
                          label: "Select Time Slots",
                          isChecked: isSelectAllChecked,
                          isEdit: true,
                          onSelectAll: () {
                            setState(() {
                              if (isSelectAllChecked) {
                                selectedSlotIds.clear();
                                isSelectAllChecked = false;
                              } else {
                                selectedSlotIds = allSlots.map((slot) => slot.id).toList();
                                isSelectAllChecked = true;
                              }
                            });
                          },
                        ),
                      SizedBox(height: getHeightRatio() * 6),
                      if (provider.isLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (allSlots.isNotEmpty)
                        ChipGroupMultiSelect(
                          options: allSlots,
                          initialSelection: allSlots.where((slot) => selectedSlotIds.contains(slot.id)).toList(),
                          onSelectionChanged: (selectedSlots) {
                            setState(() {
                              selectedSlotIds = selectedSlots.map((slot) => slot.id).toList();
                              isSelectAllChecked = selectedSlotIds.length == allSlots.length;
                            });
                          },
                          chipPadding: const EdgeInsets.all(8),
                        )
                      else
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 18.0),
                            child: CustomText(
                              text: "No Time Slots found for this date",
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (provider.errorMessage != null) ...[
                  CustomText(
                    text: provider.errorMessage!,
                    color: Colors.red,
                    fontSize: sizes?.fontSize12,
                  ),
                  const SizedBox(height: 8),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      buttonText: 'Cancel',
                      onTap: () {
                        Navigator.pop(context);
                      },
                      buttonWidth: getWidth() * .42,
                      backgroundColor: Colors.transparent,
                      borderColor: AppColors.blackColor,
                      textColor: AppColors.blackColor,
                      textFontWeight: FontWeight.w700,
                    ),
                    CustomButton(
                      buttonText: provider.isLoading ? 'Saving...' : 'Save Changes',
                      onTap: provider.isLoading || selectedSlotIds.isEmpty
                          ? null
                          : () async {
                              DateTime parsedDate = DateFormat('MM/dd/yyyy').parse(leaveDateController.text);
                              String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
                              final success = await provider.addUnavailableSlot(formattedDate, selectedSlotIds);
                              if (success && mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Unavailability marked successfully')),
                                );
                                Navigator.pop(context);
                              }
                            },
                      buttonWidth: getWidth() * .42,
                      backgroundColor: provider.isLoading || selectedSlotIds.isEmpty
                          ? AppColors.textGreyColor
                          : AppColors.getPrimaryColorFromContext(context),
                      borderColor: Colors.transparent,
                      textColor: Colors.white,
                      textFontWeight: FontWeight.w700,
                    ),
                  ],
                ),
                SizedBox(height: getHeightRatio() * 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
