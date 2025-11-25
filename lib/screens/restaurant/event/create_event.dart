import 'dart:io';

import 'package:choice_app/customWidgets/common_app_bar.dart';
import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/network/network_provider.dart';
import 'package:choice_app/screens/restaurant/event/event_provider.dart';
import 'package:choice_app/screens/restaurant/profile/profile_provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../appAssets/app_assets.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_button.dart';
import '../../../customWidgets/custom_textfield.dart';
import '../../../l18n.dart';
import '../../../models/event_type_model.dart';
import '../../../res/res.dart';
import '../../../res/toasts.dart';
import '../../../userRole/role_provider.dart';
import '../../../userRole/user_role.dart';
import '../../../utilities/timezone_helper.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  String? _selectedEventType;
  final _formKey = GlobalKey<FormState>();
  NetworkProvider networkProvider = NetworkProvider();

  // Form controllers
  final _eventNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _venueController = TextEditingController();
  final _addressController = TextEditingController();
  final _capacityController = TextEditingController();
  final _priceController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  List<XFile> images = [];
  List<String> imageUrls = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    if (images.length >= 5) return;
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        images.add(pickedFile);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      images.removeAt(index);
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime:
          isStart
              ? (_startTime ?? const TimeOfDay(hour: 0, minute: 0))
              : (_endTime ?? const TimeOfDay(hour: 0, minute: 0)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Widget _buildSectionTitle(String title) {
    return CustomText(
      text: title,
      fontSize: sizes?.fontSize16,
      fontFamily: Assets.onsetSemiBold,
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [child, const SizedBox(height: 4)],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    networkProvider = Provider.of<NetworkProvider>(context, listen: false);
    networkProvider.context = context;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<RoleProvider>().role == UserRole.leisure) {
        context.read<EventProvider>().getEventTypes();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _eventNameController.dispose();
    _descriptionController.dispose();
    _venueController.dispose();
    _priceController.dispose();
    _addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final role = context.read<RoleProvider>().role;

    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: CommonAppBar(title: al.createEvent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // EVENT DETAILS
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(al.eventDetails),
                    SizedBox(height: getHeight() * .02),
                    CustomField(
                      textEditingController: _eventNameController,
                      borderColor: AppColors.greyBordersColor,
                      hint: "E.g: Brochette boeuf...",
                      label: al.eventName,
                    ),
                    SizedBox(height: getHeight() * .02),

                    // Event Type only for leisure
                    if (role == UserRole.leisure) ...[
                      Consumer<EventProvider>(
                        builder: (context, provider, _) {
                          final eventTypes = provider.eventTypesList;
                          final items =
                              eventTypes.map((e) => e.name ?? "").toList();

                          return CustomDropdownField(
                            label: al.eventTypeLabel,
                            hint: al.eventTypePlaceholder,
                            items: items,
                            value: _selectedEventType,
                            borderColor: AppColors.inputHintColor,
                            onChanged: (value) {
                              setState(() {
                                _selectedEventType = value;
                              });
                            },
                          );
                        },
                      ),
                      SizedBox(height: getHeight() * .02),
                    ],

                    CustomField(
                      textEditingController: _descriptionController,
                      height: getHeight() * .1,
                      borderColor: AppColors.greyBordersColor,
                      hint: al.eventDescriptionPlaceholder,
                      label: al.description,
                    ),
                  ],
                ),
              ),

              // EVENT GALLERy
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(al.eventGallery),
                    SizedBox(height: getHeight() * .02),
                    CustomText(
                      text: al.uploadEventImages,
                      fontSize: sizes?.fontSize14,
                      fontFamily: Assets.onsetMedium,
                    ),
                    CustomText(
                      text: al.uploadEventImages,
                      fontSize: sizes?.fontSize12,
                    ),
                    SizedBox(height: getHeight() * .02),

                    InkWell(onTap: _pickImages, child: DottedBorderContainer()),

                    SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(images.length, (index) {
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(images[index].path),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () => _removeImage(index),
                                child: CircleAvatar(
                                  radius: getHeight() * .018,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.close,
                                    size: getHeight() * .022,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),

              // LOCATION
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(al.location),
                    SizedBox(height: getHeight() * .02),

                    if (role == UserRole.restaurant) ...[
                      CustomField(
                        textEditingController: _venueController,
                        borderColor: AppColors.greyBordersColor,
                        hint: al.restaurantOrVenue,
                        label: al.venueName,
                      ),
                      SizedBox(height: getHeight() * .02),
                    ],

                    CustomField(
                      textEditingController: _addressController,
                      borderColor: AppColors.greyBordersColor,
                      hint: al.venueAddress,
                      label: al.address,
                    ),
                  ],
                ),
              ),

              // CAPACITY & PRICING
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(al.capacityPricing),
                    SizedBox(height: getHeight() * .02),

                    CustomField(
                      textEditingController: _capacityController,
                      borderColor: AppColors.greyBordersColor,
                      hint: al.maxPersons,
                      label: al.maxCapacity,
                    ),

                    SizedBox(height: getHeight() * .02),

                    CustomField(
                      textEditingController: _priceController,
                      borderColor: AppColors.greyBordersColor,
                      hint: "\$ 0.00",
                      label: al.pricePerPerson,
                    ),
                  ],
                ),
              ),

              // SCHEDULE
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(al.schedule),
                    SizedBox(height: getHeight() * .02),

                    InkWell(
                      onTap: _pickDate,
                      child: AbsorbPointer(
                        child: CustomField(
                          borderColor: AppColors.greyBordersColor,
                          hint: al.selectDate,
                          label: al.eventDate,
                          suffixIcon: Icons.calendar_month_rounded,
                          obscure: true,
                          textEditingController: TextEditingController(
                            // FIX: DISPLAY DATE AS yyyy-MM-dd
                            text:
                                _selectedDate == null
                                    ? ""
                                    : DateFormat(
                                      "yyyy-MM-dd",
                                    ).format(_selectedDate!),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pickTime(true),
                            child: AbsorbPointer(
                              child: CustomField(
                                obscure: true,
                                borderColor: AppColors.greyBordersColor,
                                hint: al.selectTime,
                                label: al.startTime,
                                suffixIcon: Icons.schedule,
                                // suffixIconSvg: Assets.clockSvg,
                                textEditingController: TextEditingController(
                                  text:
                                      _startTime == null
                                          ? ""
                                          : _startTime!.format(context),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 12),

                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pickTime(false),
                            child: AbsorbPointer(
                              child: CustomField(
                                obscure: true,
                                borderColor: AppColors.greyBordersColor,
                                hint: al.selectTime,
                                label: al.endTime,
                                suffixIcon: Icons.schedule,
                                // suffixIconSvg: Assets.clockSvg,
                                textEditingController: TextEditingController(
                                  text:
                                      _endTime == null
                                          ? ""
                                          : _endTime!.format(context),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // BUTTONS
              Padding(
                padding: EdgeInsets.symmetric(vertical: getHeight() * .03),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        backgroundColor: Colors.transparent,
                        buttonText: al.saveAsDraft,
                        textColor: Colors.black,
                        borderColor: Colors.black,
                        onTap: () {},
                      ),
                    ),

                    SizedBox(width: 12),

                    Expanded(
                      child: CustomButton(
                        buttonText: al.publish,
                        onTap: () async {
                          final isLeisure =
                              context.read<RoleProvider>().role ==
                              UserRole.leisure;
                          final isRestaurant =
                              context.read<RoleProvider>().role ==
                              UserRole.restaurant;

                          // Validation
                          if (images.isEmpty) {
                            Toasts.getErrorToast(text: al.errorSelectImage);
                            return;
                          }
                          if (_eventNameController.text.trim().isEmpty) {
                            Toasts.getErrorToast(text: al.enterEventName);
                            return;
                          }
                          if (_descriptionController.text.trim().isEmpty) {
                            Toasts.getErrorToast(
                              text: al.enterEventDescription,
                            );
                            return;
                          }
                          if (isRestaurant &&
                              _venueController.text.trim().isEmpty) {
                            Toasts.getErrorToast(text: al.enterVenue);
                            return;
                          }
                          if (_addressController.text.trim().isEmpty) {
                            Toasts.getErrorToast(text: al.errorEnterAddress);
                            return;
                          }
                          if (_capacityController.text.trim().isEmpty ||
                              int.tryParse(_capacityController.text.trim()) ==
                                  null) {
                            Toasts.getErrorToast(
                              text: al.enterValidCapacityNumber,
                            );
                            return;
                          }
                          if (_priceController.text.trim().isEmpty ||
                              double.tryParse(_priceController.text.trim()) ==
                                  null) {
                            Toasts.getErrorToast(text: al.enterValidPrice);
                            return;
                          }
                          if (isLeisure &&
                              (_selectedEventType == null ||
                                  _selectedEventType!.isEmpty)) {
                            Toasts.getErrorToast(
                              text: "Please select event type",
                            );
                            return;
                          }
                          if (_selectedDate == null) {
                            Toasts.getErrorToast(
                              text: "Please select event date",
                            );
                            return;
                          }
                          if (_startTime == null || _endTime == null) {
                            Toasts.getErrorToast(
                              text: "Please select start and end time",
                            );
                            return;
                          }

                          // Upload images
                          imageUrls.clear();
                          for (var img in images) {
                            final bytes = await img.readAsBytes();
                            final fileUrl = await networkProvider
                                .getUrlForFileUpload(bytes);
                            if (fileUrl != null) {
                              imageUrls.add(
                                NetworkProvider.extractS3Key(fileUrl),
                              );
                            }
                          }

                          if (imageUrls.isEmpty) {
                            Toasts.getErrorToast(
                              text: "Failed to upload images",
                            );
                            return;
                          }

                          // Event type ID
                          final provider = context.read<EventProvider>();
                          final selectedType =
                              isLeisure
                                  ? provider.eventTypesList.firstWhere(
                                    (e) => e.name == _selectedEventType,
                                    orElse:
                                        () => EventTypeModel(
                                          id: -1,
                                          name: '',
                                          createdAt: DateTime.now(),
                                          updatedAt: DateTime.now(),
                                        ),
                                  )
                                  : null;

                          if (isLeisure &&
                              (selectedType == null || selectedType.id <= 0)) {
                            Toasts.getErrorToast(text: "Invalid event type");
                            return;
                          }

                          // FIX: send date in correct format
                          final dateStr = DateFormat(
                            "yyyy-MM-dd",
                          ).format(_selectedDate!);

                          final startTimeStr =
                              "${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}";
                          final endTimeStr =
                              "${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}";

                          final profileProvider =
                              context.read<ProfileProvider>();
                          final producerProfile =
                              profileProvider
                                  .getProducerProfileResponse
                                  ?.producer;

                          final latitude =
                              double.tryParse(
                                producerProfile?.latitude ?? "0.0",
                              ) ??
                              0.0;
                          final longitude =
                              double.tryParse(
                                producerProfile?.longitude ?? "0.0",
                              ) ??
                              0.0;
                          final eventProvider = context.read<EventProvider>();
                          eventProvider
                              .createEventApi(
                                eventName: _eventNameController.text.trim(),
                                description: _descriptionController.text.trim(),
                                venue:
                                    isRestaurant
                                        ? _venueController.text.trim()
                                        : "",
                                address: _addressController.text.trim(),
                                capacity: _capacityController.text.trim(),
                                price: _priceController.text.trim(),
                                images: imageUrls,
                                date: dateStr,
                                startTime: startTimeStr,
                                endTime: endTimeStr,
                                eventTypeId:
                                    isLeisure ? selectedType!.id : null,
                                latitude: latitude,
                                longitude: longitude,
                                timeZone:
                                    TimezoneHelper.cachedTimeZone ??
                                    'UTC', // Success: Uses the cached value
                              )
                              .whenComplete(() {
                                Navigator.pop(context);
                                eventProvider.getAllEvents();
                              });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// DOTTED IMAGE UPLOAD BOX
class DottedBorderContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      child: DottedBorder(
        options: RectDottedBorderOptions(
          padding: EdgeInsets.all(22),
          dashPattern: [10, 10],
          color: AppColors.inputHintColor,
        ),
        child: SizedBox(
          width: getWidth(),
          height: getHeight() * .13,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(Assets.imageIcon),
                SizedBox(height: 8),
                CustomText(
                  text: al.tapToUpload,
                  fontSize: sizes?.fontSize14,
                  fontFamily: Assets.onsetMedium,
                ),
                CustomText(
                  text: "PNG, JPG or JPEG (MAX. 5MB each)",
                  fontSize: sizes?.fontSize12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
