import 'package:choice_app/screens/onboarding/slot_management/slot_management_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../onboarding_provider.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/common_app_bar.dart';
import '../../../customWidgets/custom_button.dart';
import '../../../customWidgets/custom_drop_down.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../customWidgets/text_field_label.dart';
import '../../../res/res.dart';
import '../day_off/days_off_view.dart';


class SlotManagementView extends StatefulWidget {
  final bool? isHomeFlow;
  final bool? isEdit;
  const SlotManagementView({super.key, this.isHomeFlow, this.isEdit});

  @override
  State<SlotManagementView> createState() => _SlotManagementViewState();
}

class _SlotManagementViewState extends State<SlotManagementView> {
  List<int> hoursList = [1, 2, 3, 4];
  int? selectedHour;
  bool isEdit = false;

  Map<String, List<int>> selectedDayWiseSlots = {};

  @override
  void initState() {
    super.initState();
    isEdit = widget.isEdit ?? false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<OnboardingProvider>();
      provider.fetchSlotDuration();
      provider.fetchProducerSlots();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(
        title: "Slot Management",
        showEditButton: isEdit,
        onEdit: () {
          setState(() {
            isEdit = false;
          });
        },
      ),
      body: Consumer<OnboardingProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.producerSlots.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Initialize selected slots from provider data if not already edited locally
          if (selectedDayWiseSlots.isEmpty && provider.producerSlots.isNotEmpty) {
            for (var item in provider.producerSlots) {
              final day = item['day'] as String;
              final slots = item['slots'] as List<dynamic>;
              selectedDayWiseSlots[day] = slots
                  .where((s) => s['isActive'] == false) // active=false means unavailable
                  .map((s) => s['id'] as int)
                  .toList();
            }
          }

          final currentDuration = provider.slotDuration ?? selectedHour;

          return Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: getHeightRatio() * 16),
                if (!isEdit)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.05),
                    child: const TextFieldLabel(
                      label: "Slot Duration",
                    ),
                  ),
                if (!isEdit)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.05),
                    child: CustomDropdown(
                      items: hoursList.map((hour) {
                        return DropdownMenuItem<int>(
                          value: hour,
                          child: CustomText(
                            text: "$hour hour ",
                            fontWeight: FontWeight.w400,
                            fontSize: sizes?.fontSize16,
                            lines: 1,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      selectedValue: currentDuration,
                      hintText: 'Select duration',
                      onChanged: (id) async {
                        if (id != null) {
                          final success = await provider.saveSlotDuration(id);
                          if (success && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Slot duration updated successfully')),
                            );
                          }
                        }
                      },
                      validator: (id) => id == null ? 'Please select duration' : null,
                    ),
                  ),
                SizedBox(height: getHeightRatio() * 16),
                if (isEdit)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.05),
                    child: CustomText(
                      text: "Mark Your Unavailable Time Slots",
                      fontSize: sizes?.fontSize18,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (isEdit)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.05),
                    child: CustomText(
                      text: "Select the time slots when you're not available each day. You can choose individual slots or use Select All to mark the entire day as unavailable. Tap Save Changes to apply your preferences.",
                      fontSize: sizes?.fontSize14,
                      color: AppColors.textGreyColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                SizedBox(height: getHeightRatio() * 16),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: provider.producerSlots.length,
                    itemBuilder: (context, index) {
                      final item = provider.producerSlots[index];
                      final currentDay = item["day"] as String;
                      final rawSlots = item["slots"] as List<dynamic>;
                      final allSlotsOfDay = rawSlots.map((s) => Slots.fromJson(s)).toList();
                      final selectedIds = selectedDayWiseSlots[currentDay] ?? [];

                      final isChecked = allSlotsOfDay.isNotEmpty &&
                          allSlotsOfDay.every((slot) => selectedIds.contains(slot.id));

                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.05),
                            child: EditDaysTile(
                              label: currentDay,
                              isChecked: isChecked,
                              isEdit: isEdit,
                              onSelectAll: () {
                                setState(() {
                                  if (isChecked) {
                                    selectedDayWiseSlots[currentDay] = [];
                                  } else {
                                    selectedDayWiseSlots[currentDay] =
                                        allSlotsOfDay.map((slot) => slot.id).toList();
                                  }
                                });
                              },
                            ),
                          ),
                          SizedBox(height: getHeightRatio() * 6),
                          MultiSlotSelection(
                            options: allSlotsOfDay,
                            isEdit: isEdit,
                            initialSelection: allSlotsOfDay
                                .where((slot) => selectedIds.contains(slot.id))
                                .toList(),
                            onSelectionChanged: (selectedSlots) {
                              setState(() {
                                selectedDayWiseSlots[currentDay] =
                                    selectedSlots.map((slot) => slot.id).toList();
                              });
                            },
                            chipPadding: const EdgeInsets.all(8),
                          ),
                          SizedBox(height: getHeightRatio() * 16),
                        ],
                      );
                    },
                  ),
                ),
                if (provider.errorMessage != null) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.05),
                    child: CustomText(
                      text: provider.errorMessage!,
                      color: Colors.red,
                      fontSize: sizes?.fontSize12,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                SizedBox(height: getHeight() * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.05),
                  child: Row(
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
                        onTap: provider.isLoading
                            ? null
                            : () async {
                                final List<Map<String, dynamic>> slotsUpdate = [];
                                for (var item in provider.producerSlots) {
                                  final day = item['day'] as String;
                                  final rawSlots = item['slots'] as List<dynamic>;
                                  final selectedIds = selectedDayWiseSlots[day] ?? [];

                                  for (var s in rawSlots) {
                                    final id = s['id'] as int;
                                    final isUnavailable = selectedIds.contains(id);
                                    slotsUpdate.add({
                                      'id': id,
                                      'isActive': !isUnavailable,
                                    });
                                  }
                                }

                                final success = await provider.updateRestaurantSlots(slotsUpdate);
                                if (success && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Slots updated successfully')),
                                  );
                                  Navigator.pop(context);
                                }
                              },
                        buttonWidth: getWidth() * .42,
                        backgroundColor: provider.isLoading
                            ? AppColors.textGreyColor
                            : AppColors.getPrimaryColorFromContext(context),
                        borderColor: Colors.transparent,
                        textColor: Colors.white,
                        textFontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
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

class Slots {
  final int id;
  final String startTime;
  final String endTime;
  final bool isActive;

  Slots({
    required this.id,
    required this.startTime,
    required this.endTime,
    this.isActive = true,
  });

  factory Slots.fromJson(Map<String, dynamic> json) {
    return Slots(
      id: json['id'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      isActive: json['isActive'] ?? true,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Slots && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
