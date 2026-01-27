import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../appAssets/app_assets.dart';
import '../../../../appColors/colors.dart';
import '../../../../customWidgets/blurry_back_ground.dart';
import '../../../../customWidgets/common_app_bar.dart';
import '../../../../customWidgets/custom_button.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../res/res.dart';
import '../widgets/setup_time_popup.dart';
import '../../onboarding_provider.dart';

class EditOperationalHours extends StatefulWidget {
  final List<dynamic>? operationalHoursList;

  const EditOperationalHours({super.key, this.operationalHoursList});

  @override
  State<EditOperationalHours> createState() => _EditOperationalHoursState();
}

class _EditOperationalHoursState extends State<EditOperationalHours> {
  // late OperationalHoursProvider operationalHoursProvider;
  // late ProfileProvider profileProvider;
  bool isSelectAll = false;
  bool isInfoOpened = false;

  @override
  void initState() {
    super.initState();
    for (var day in days) {
      isActive[day] = false;
      startTimes[day] = const TimeOfDay(hour: 0, minute: 0);
      endTimes[day] = const TimeOfDay(hour: 0, minute: 0);
    }

    for (var item in widget.operationalHoursList??[]) {
      final String day = item.day;
      final bool isClosed = item.isClosed ?? true;
      final start = item.startTime ?? "00:00";
      final end = item.endTime ?? "00:00";

      isActive[day] = !isClosed;
      startTimes[day] = _parseTime(start);
      endTimes[day] = _parseTime(end);
    }
  }

  TimeOfDay _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  final Map<String, bool> isActive = {};
  final Map<String, TimeOfDay> startTimes = {};
  final Map<String, TimeOfDay> endTimes = {};

  Future<void> pickTime(String day, bool isStart) async {
    final initialTime = isStart ? startTimes[day]! : endTimes[day]!;
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startTimes[day] = picked;
        } else {
          endTimes[day] = picked;
        }
      });
    }
  }


  String formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: const CommonAppBar(title: "Business hours"),
      body: Consumer<OnboardingProvider>(
        builder: (context, provider, child) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding, vertical: getHeight() * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: getHeightRatio() * 16),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      isInfoOpened = true;
                    });
                  },
                  child: Row(
                    children: [
                      CustomText(
                        text: "Set weekly Availability",
                        fontSize: sizes?.fontSize18,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(width: getWidth() * 0.02),
                      Image.asset(
                        Assets.infoIcon,
                        height: getHeight() * 0.02,
                        color: AppColors.getPrimaryColorFromContext(context),
                      )
                    ],
                  ),
                ),
                SizedBox(height: getHeight() * 0.01),
                if(isInfoOpened)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding, vertical: getHeight() * 0.02),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.getPrimaryColorFromContext(context)
                  ),
                  child: CustomText(
                    text: "Select the days and times your business operates. This schedule will repeat weekly for the entire year. To mark specific days off, use the unavailability tab.",
                    fontSize: sizes?.fontSize12,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w400,
                    giveLinesAsText: true,
                  ),
                ),
                SizedBox(height: getHeightRatio() * 16),
                Row(
                  children: [
                    Transform.translate(
                      offset: Offset(-getWidth() * 0.02, 0),
                      child: Transform.scale(
                        scale: 0.8,
                        child: Switch(
                          value: isSelectAll,
                          onChanged: (val) {
                            if (val) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return BlurryBackground(
                                    child: SetupTimePopup(
                                      onConfirm: (TimeOfDay start, TimeOfDay end) {
                                        setState(() {
                                          isSelectAll = true;
                                          for (final day in days) {
                                            isActive[day] = true;
                                            startTimes[day] = start;
                                            endTimes[day] = end;
                                          }
                                        });
                                      },
                                    ),
                                  );
                                },
                              );
                            } else {
                              setState(() {
                                isSelectAll = false;
                              });
                            }
                          },
                          activeColor: AppColors.whiteColor,
                          activeTrackColor: AppColors.getPrimaryColorFromContext(context),
                          inactiveThumbColor: AppColors.whiteColor,
                          inactiveTrackColor: AppColors.greyColor,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
                    CustomText(
                      text: "Select for All day",
                      fontSize: sizes?.fontSize14,
                      fontWeight: FontWeight.w500,
                    )
                  ],
                ),
                SizedBox(height: getHeightRatio() * 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        text: "Day On/Off",
                        fontSize: sizes?.fontSize12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blackColor,
                        lines: 1,
                      ),
                    ),
                    SizedBox(width: getWidth() * 0.009),
                      Row(
                        children: [
                          SizedBox(
                            width: getWidth() * 0.22,
                            child: CustomText(
                              text: "Start Time",
                              fontSize: sizes?.fontSize12,
                              fontWeight: FontWeight.w500,
                              color:AppColors.blackColor,
                            ),
                          ),
                          SizedBox(width: getWidth() * 0.02),
                          SizedBox(
                            width: getWidth() * 0.22,
                            child: CustomText(
                              text: "End Time",
                              fontSize: sizes?.fontSize12,
                              fontWeight: FontWeight.w500,
                              color:AppColors.blackColor,
                            ),
                          ),
                        ],
                      )
                  ],
                ),
                SizedBox(height: getHeightRatio() * 16),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      ...days.map((day) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Row(
                            children: [
                              Transform.translate(
                                offset: Offset(-getWidth() * 0.02, 0),
                                child: Transform.scale(
                                  scale: 0.8,
                                  child: Switch(
                                    value: isActive[day]!,
                                    onChanged: (val) {
                                      setState(() {
                                        isActive[day] = val;
                                      });
                                    },
                                    activeColor: AppColors.whiteColor,
                                    activeTrackColor: AppColors.getPrimaryColorFromContext(context),
                                    inactiveThumbColor: AppColors.whiteColor,
                                    inactiveTrackColor: AppColors.greyColor,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: CustomText(
                                  text: day.substring(0, 3),
                                  fontSize: sizes?.fontSize14,
                                  fontWeight: FontWeight.w500,
                                  color:AppColors.blackColor,
                                ),
                              ),
                              SizedBox(width: getWidth() * 0.009),
                              if (isActive[day]!)
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () => pickTime(day, true),
                                      child: Container(
                                        width: getWidth() * 0.22,
                                        padding: EdgeInsets.only(top: getHeight() * 0.015, bottom: getHeight() * 0.015, left: getWidth() * 0.025),
                                        decoration: BoxDecoration(
                                          color:AppColors.greyColor,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: CustomText(
                                          text: formatTime(startTimes[day]!),
                                          fontSize: sizes?.fontSize14,
                                          fontWeight: FontWeight.w500,
                                          color:AppColors.blackColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: getWidth() * 0.02),
                                    InkWell(
                                      onTap: () => pickTime(day, false),
                                      child: Container(
                                        width: getWidth() * 0.22,
                                        padding: EdgeInsets.only(top: getHeight() * 0.015, bottom: getHeight() * 0.015, left: getWidth() * 0.025),
                                        decoration: BoxDecoration(
                                          color:AppColors.greyColor,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: CustomText(
                                          text: formatTime(endTimes[day]!),
                                          fontSize: sizes?.fontSize14,
                                          fontWeight: FontWeight.w500,
                                          color:AppColors.blackColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Container(
                                  width: getWidth() * 0.46,
                                  padding: EdgeInsets.only(top: getHeight() * 0.015, bottom: getHeight() * 0.015, left: getWidth() * 0.025),
                                  decoration: BoxDecoration(
                                    color:AppColors.greyColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: CustomText(
                                    text: "Closed",
                                    fontSize: sizes?.fontSize14,
                                    fontWeight: FontWeight.w500,
                                    color:AppColors.primarySlateColor,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),
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
                SizedBox(height: getHeight() * 0.02),
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
                      onTap: provider.isLoading ? null : () async {
                        final List<Map<String, dynamic>> hours = days.map((day) {
                          return {
                            'day': day,
                            'startTime': _formatTo24Hour(startTimes[day]!),
                            'endTime': _formatTo24Hour(endTimes[day]!),
                            'isClosed': !isActive[day]!,
                          };
                        }).toList();

                        final success = await provider.saveOperationalHours(hours);
                        if (success && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Business hours saved successfully')),
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
                SizedBox(height: getHeightRatio() * 16)
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatTo24Hour(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm').format(dt);
  }
}