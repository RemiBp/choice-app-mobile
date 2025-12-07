import 'package:choice_app/models/get_producer_slots_response.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/screens/onboarding/slot_management/slot_management_widgets.dart';
import 'package:choice_app/screens/restaurant/profile/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/common_app_bar.dart';
import '../../../customWidgets/custom_button.dart';
import '../../../customWidgets/custom_drop_down.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../customWidgets/text_field_label.dart';
import '../../../l18n.dart';
import '../../../res/res.dart';
import '../../../res/toasts.dart';
import '../../../userRole/role_provider.dart';
import '../../../userRole/user_role.dart';


class SlotManagementView extends StatefulWidget {
  final bool? isHomeFlow;
  final bool isEdit;
  const SlotManagementView({super.key, this.isHomeFlow, this.isEdit = false});

  @override
  State<SlotManagementView> createState() => _SlotManagementViewState();
}

class _SlotManagementViewState extends State<SlotManagementView> {
  List<int> hoursList = [1, 2, 3, 4];
  int? selectedHour;
  bool monday = false;
  bool tuesday = false;
  bool wednesday = false;
  bool thursday = false;
  bool friday = false;
  bool saturday = false;
  bool sunday = false;
  bool isEdit = true;
  bool isDurationChanged = false; // NEW: Track if duration was changed in edit mode

  Map<String, List<int>> selectedDayWiseSlots = {};
  List<Map<String, dynamic>> slotsData = [];

  List<Map<String, dynamic>> _generateSlotsForDuration(int duration) {
    List<Map<String, dynamic>> generatedSlots = [];
    List<String> days = [
      al.monday,
      al.tuesday,
      al.wednesday,
      al.thursday,
      al.friday,
      al.saturday,
      al.sunday
    ];

    for (String day in days) {
      List<Slots> daySlots = [];
      int slotId = 1;

      // Generate slots from 9:00 AM to 6:00 PM (9 hours)
      for (int hour = 9; hour < 18; hour += duration) {
        String startTime = "${hour.toString().padLeft(2, '0')}:00";
        int endHour = hour + duration;
        String endTime = "${endHour.toString().padLeft(2, '0')}:00";

        daySlots.add(Slots(
          id: slotId,
          startTime: startTime,
          endTime: endTime,
        ));
        slotId++;
      }

      generatedSlots.add({
        "day": day,
        "slots": daySlots,
      });
    }

    return generatedSlots;
  }

  @override
  void initState() {
    super.initState();
    isEdit = widget.isEdit;
    isDurationChanged = false; // Start with false

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(widget.isEdit) {
        _loadProducerSlots();
      }
    });
  }

  void _loadProducerSlots() async {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    provider.init(context);
    await provider.getProducerSlots();
    _initializeSlotsDataFromApi(provider);
  }

  void _initializeSlotsData() {
    // Initialize with default 1-hour slots
    slotsData = _generateSlotsForDuration(1);
    _initializeSelectedSlots();
  }

  void _initializeSlotsDataFromApi(ProfileProvider provider) {
    if (provider.getProducerSlotsResponse != null) {
      slotsData = _convertApiDataToSlotsData(provider.getProducerSlotsResponse!);

      // Always load previously selected slots from API when opening from profile
      if (widget.isEdit) {
        _loadPreviouslySelectedSlots(provider.getProducerSlotsResponse!);
      } else {
        _initializeSelectedSlots();
      }
    } else {
      // Fallback to default data if API data is not available
      slotsData = _generateSlotsForDuration(1);
      _initializeSelectedSlots();
    }

    if (mounted) {
      setState(() {});
    }
  }

  List<Map<String, dynamic>> _convertApiDataToSlotsData(GetProducerSlotsResponse apiResponse) {
    List<Map<String, dynamic>> convertedData = [];

    for (var daySlot in apiResponse.data) {
      List<Slots> convertedSlots = [];

      for (var apiSlot in daySlot.slots) {
        convertedSlots.add(Slots(
          id: apiSlot.id,
          startTime: apiSlot.startTime,
          endTime: apiSlot.endTime,
        ));
      }

      convertedData.add({
        "day": daySlot.day,
        "slots": convertedSlots,
      });
    }

    return convertedData;
  }

  void _initializeSelectedSlots() {
    selectedDayWiseSlots.clear();

    // Only auto-select in onboarding flow (widget.isEdit=false)
    if (!widget.isEdit) {
      // Onboarding flow - Auto-select ALL slots
      for (var item in slotsData) {
        final day = item['day'] as String;
        final allSlots = item['slots'] as List<Slots>;
        selectedDayWiseSlots[day] = allSlots.map((slot) => slot.id).toList();
      }
      debugPrint('✅ Auto-selected all slots for onboarding (widget.isEdit=false)');
    } else {
      // Profile flow - Start empty (will be loaded from API)
      for (var item in slotsData) {
        final day = item['day'] as String;
        selectedDayWiseSlots[day] = [];
      }
      debugPrint('✅ Slots initialized empty for profile mode (widget.isEdit=true)');
    }

    selectedDayWiseSlots.forEach((day, ids) {
      debugPrint('$day => ${ids.length} slots');
    });
  }

  void _loadPreviouslySelectedSlots(GetProducerSlotsResponse apiResponse) {
    selectedDayWiseSlots.clear();

    for (var daySlot in apiResponse.data) {
      // Load the slots that are in the API response (these are the selected ones)
      List<int> selectedIds = daySlot.slots.map((slot) => slot.id).toList();
      selectedDayWiseSlots[daySlot.day] = selectedIds;
    }

    debugPrint('✅ Loaded previously selected slots from API');
    selectedDayWiseSlots.forEach((day, ids) {
      debugPrint('$day => ${ids.length} slots loaded');
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: CommonAppBar(
          title: al.slotManagement,
          showEditButton: isEdit,
          onEdit: (){
            setState(() {
              isEdit = false;
              isDurationChanged = false; // Reset when entering edit mode
            });
          },
        ),
        body: Container(
          child:
          Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: getHeightRatio() * 16),
                if(!isEdit)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.05),
                    child: TextFieldLabel(
                      label: al.slotDuration,
                    ),
                  ),
                if(!isEdit)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.05),
                    child: CustomDropdown(
                      items: hoursList.map((hour) {
                        return DropdownMenuItem<int>(
                          value: hour,
                          child: CustomText(
                            text: "$hour  " + al.hour,
                            fontWeight: FontWeight.w400,
                            fontSize: sizes?.fontSize16,
                            lines: 1,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      selectedValue: selectedHour,
                      hintText: al.selectDuration,
                      onChanged: (id) async {
                        setState(() {
                          selectedHour = id!;
                          // Regenerate slots based on selected duration
                          slotsData = _generateSlotsForDuration(id!);

                          // FIXED: Check if we're in profile edit mode or onboarding
                          if (widget.isEdit) {
                            // Profile edit mode - Keep selections empty & mark duration as changed
                            isDurationChanged = true;
                            for (var item in slotsData) {
                              final day = item['day'] as String;
                              selectedDayWiseSlots[day] = [];
                            }
                            debugPrint('✅ Profile edit mode - Duration changed, showing Select All');
                          } else {
                            // Onboarding mode - Auto-select all
                            for (var item in slotsData) {
                              final day = item['day'] as String;
                              final allSlots = item['slots'] as List<Slots>;
                              selectedDayWiseSlots[day] = allSlots.map((slot) => slot.id).toList();
                            }
                            debugPrint('✅ Onboarding mode - auto-selected all slots');
                          }
                        });

                        // Call API to set slot duration
                        final provider = Provider.of<ProfileProvider>(context, listen: false);
                        provider.init(context);
                        await provider.setSlotDuration(slotDuration: id!);
                        await provider.getProducerSlots();

                        // Reload slots from API
                        if (provider.getProducerSlotsResponse != null) {
                          setState(() {
                            slotsData = _convertApiDataToSlotsData(provider.getProducerSlotsResponse!);

                            // Maintain correct selection behavior after API call
                            if (widget.isEdit) {
                              // Profile edit mode - Keep selections empty
                              for (var item in slotsData) {
                                final day = item['day'] as String;
                                selectedDayWiseSlots[day] = [];
                              }
                            } else {
                              // Onboarding mode - Auto-select all
                              for (var item in slotsData) {
                                final day = item['day'] as String;
                                final allSlots = item['slots'] as List<Slots>;
                                selectedDayWiseSlots[day] = allSlots.map((slot) => slot.id).toList();
                              }
                            }
                          });
                        }
                      },
                      validator: (id) => id == null ? al.pleaseSelectDuration : null,
                    ),
                  ),
                SizedBox(height: getHeightRatio() * 16),
                if(isEdit && !widget.isEdit)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.05),
                    child: CustomText(
                      text: al.markUnavailableSlots,
                      fontSize: sizes?.fontSize18,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if(isEdit && !widget.isEdit)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.05),
                    child: CustomText(
                      text: al.unavailableSlotsDescription,
                      fontSize: sizes?.fontSize14,
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                SizedBox(height: getHeightRatio() * 16),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: slotsData.length,
                    itemBuilder: (context, index) {
                      final currentDay = slotsData[index]["day"] as String;
                      final allSlotsOfDay = slotsData[index]["slots"] as List<Slots>;
                      final selectedIds = selectedDayWiseSlots[currentDay] ?? [];

                      final isChecked = selectedIds.length == allSlotsOfDay.length &&
                          allSlotsOfDay.every((slot) => selectedIds.contains(slot.id));

                      // Show "Select All" ONLY when:
                      // 1. In profile mode (widget.isEdit=true) AND
                      // 2. Edit button clicked (isEdit=false) AND
                      // 3. Duration was changed (isDurationChanged=true)
                      bool shouldShowSelectAll = widget.isEdit && !isEdit && isDurationChanged;

                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.05),
                            child: EditDaysTile(
                              label: currentDay,
                              isChecked: isChecked,
                              showSelectAll: shouldShowSelectAll,
                              isEdit: isEdit,
                              onSelectAll: () {
                                setState(() {
                                  if (isChecked) {
                                    // Deselect all slots of this day
                                    selectedDayWiseSlots[currentDay] = [];
                                  } else {
                                    // Select all slots of this day
                                    selectedDayWiseSlots[currentDay] =
                                        allSlotsOfDay.map((slot) => slot.id).toList();
                                  }
                                });
                              },
                            ),
                          ),
                          SizedBox(height: getHeightRatio() * 6),
                          MultiSlotSelection(
                            key: ValueKey('${currentDay}_${selectedHour ?? 1}'),
                            options: allSlotsOfDay,
                            // Individual slot selection always disabled
                            isEdit: false,
                            initialSelection: selectedIds.isEmpty
                                ? <Slots>[]
                                : allSlotsOfDay.where((slot) => selectedIds.contains(slot.id)).toList(),
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
                SizedBox(height: getHeight() * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        buttonText: al.cancel,
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
                        buttonText: al.saveChanges,
                        onTap: () async {
                          final roleProvider = Provider.of<RoleProvider>(context, listen: false);
                          final isRestaurant = roleProvider.role == UserRole.restaurant;

                          // Collect all selected slot IDs from all days
                          List<int> allSelectedSlotIds = [];
                          for (String day in selectedDayWiseSlots.keys) {
                            List<int> daySlots = selectedDayWiseSlots[day] ?? [];
                            if (daySlots.isNotEmpty) {
                              allSelectedSlotIds.addAll(daySlots);
                            }
                          }

                          if (isRestaurant) {
                            final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
                            profileProvider.init(context);
                            final success = await profileProvider.updateRestaurantSlots(slotIds: allSelectedSlotIds);

                            if (success) {
                              _saveSlotSelections();
                              if(widget.isEdit) {
                                context.pop();
                              } else {
                                context.go(Routes.restaurantBottomTabRoute);
                              }
                            }
                          } else {
                            _saveSlotSelections();
                            if(widget.isEdit) {
                              context.pop();
                            } else {
                              context.go(Routes.restaurantBottomTabRoute);
                            }
                          }
                        },
                        buttonWidth: getWidth() * .42,
                        backgroundColor: AppColors.getPrimaryColorFromContext(context),
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
          ),
        )
    );
  }


  void _toggleDayValue(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        monday = !monday;
        break;
      case 'tuesday':
        tuesday = !tuesday;
        break;
      case 'wednesday':
        wednesday = !wednesday;
        break;
      case 'thursday':
        thursday = !thursday;
        break;
      case 'friday':
        friday = !friday;
        break;
      case 'saturday':
        saturday = !saturday;
        break;
      case 'sunday':
        sunday = !sunday;
        break;
    }
  }

  void _saveSlotSelections() {
    debugPrint('=== SLOT SELECTIONS SAVED ===');
    debugPrint('Selected Duration: ${selectedHour ?? 'Not selected'} hours');
    debugPrint('Selected Slots:');

    int totalSelectedSlots = 0;
    for (String day in selectedDayWiseSlots.keys) {
      List<int> selectedSlots = selectedDayWiseSlots[day] ?? [];
      if (selectedSlots.isNotEmpty) {
        debugPrint('$day: ${selectedSlots.length} slots selected');
        totalSelectedSlots += selectedSlots.length;

        // Get the actual slot details
        var dayData = slotsData.firstWhere((item) => item['day'] == day);
        List<Slots> allSlots = dayData['slots'] as List<Slots>;

        for (int slotId in selectedSlots) {
          var slot = allSlots.firstWhere((s) => s.id == slotId);
          debugPrint('  - ${slot.startTime} to ${slot.endTime}');
        }
      } else {
        debugPrint('$day: ❌ No slots selected (DAY OFF)');
      }
    }

    debugPrint('Total slots across all days: $totalSelectedSlots');
    debugPrint('=============================');
  }

}



class Slots {
  final int id;
  final String startTime;
  final String endTime;

  Slots({required this.id, required this.startTime, required this.endTime});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Slots && other.id == id && other.startTime == startTime && other.endTime == endTime;
  }

  @override
  int get hashCode => id.hashCode ^ startTime.hashCode ^ endTime.hashCode;
}