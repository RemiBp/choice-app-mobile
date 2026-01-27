import 'dart:io';

import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../appAssets/app_assets.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_button.dart';
import '../../../customWidgets/custom_textfield.dart';
import '../../../res/res.dart';
import '../../onboarding/onboarding_provider.dart';
import '../../../userRole/role_provider.dart';
import '../dashboard/dashboard_provider.dart';
import '../../../userRole/user_role.dart';
import 'event_provider.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final _formKey = GlobalKey<FormState>();

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

  List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  int? _selectedEventTypeId; 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final role = context.read<RoleProvider>().role;
      if (role == UserRole.leisure) {
        context.read<EventProvider>().fetchEventTypes();
      }
    });
  }

  // Function to pick images
  Future<void> _pickImages() async {
    if (_images.length >= 5) return;
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images.add(pickedFile);
      });
    }
  }

  // Remove image
  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  // Date picker
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  // Time picker
  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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

  Future<void> _submit(bool isDraft) async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null || _startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select date and times")),
      );
      return;
    }
    
    final role = context.read<RoleProvider>().role;
    final serviceType = role == UserRole.leisure ? 'Leisure' : 'Restaurant';

    if (role == UserRole.leisure && _selectedEventTypeId == null) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an event type")),
      );
      return;
    }

    // Format Start/End time DateTime strings as ISO or HH:mm?
    // Backend schema z.string() for startTime/endTime. Usually expects "HH:mm" or ISO.
    // Let's send "HH:mm".
    final startStr = _startTime!.format(context); // This might be localized "5:00 PM". 
    // Backend likely needs 24h format "17:00".
    // Better to manually format TimeOfDay to "HH:mm" 24h.
    final start24 = '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}';
    final end24 = '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}';
    
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate!);

    final success = await context.read<EventProvider>().createEvent(
      title: _eventNameController.text,
      description: _descriptionController.text,
      venueName: _venueController.text,
      location: _addressController.text,
      pricePerGuest: double.tryParse(_priceController.text) ?? 0.0,
      maxCapacity: int.tryParse(_capacityController.text) ?? 0,
      date: dateStr,
      startTime: start24,
      endTime: end24,
      eventImages: _images.map((e) => File(e.path)).toList(),
      eventTypeId: _selectedEventTypeId,
      serviceType: serviceType,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Event created successfully")),
      );
      Navigator.pop(context);
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: CustomText(
        text: title,
        fontSize: sizes?.fontSize16,
        fontFamily: Assets.onsetSemiBold,
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final role = context.watch<RoleProvider>().role;
    final eventProvider = context.watch<EventProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: const Text("Create Event", style: TextStyle(color: Colors.black)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Event Details
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle("Event Details"),
                    SizedBox(height: getHeight() * .02),
                    CustomField(
                      controller: _eventNameController,
                      borderColor: AppColors.greyBordersColor,
                      hint: "E.g: Brochette boeuf...",
                      label: "Event Name",
                      validate: (v) => v!.isEmpty ? "Required" : null,
                    ),
                    SizedBox(height: getHeight() * .02),
                    CustomField(
                      controller: _descriptionController,
                      height: getHeight() * .1,
                      borderColor: AppColors.greyBordersColor,
                      hint: "Describe your event...",
                      label: "Description",
                       maxLines: 4,
                    ),
                    if (role == UserRole.leisure) ...[
                      SizedBox(height: getHeight() * .02),
                       DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: "Event Type",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        ),
                        value: _selectedEventTypeId,
                        items: eventProvider.eventTypes.map((e) {
                          return DropdownMenuItem<int>(
                            value: e['id'],
                            child: Text(e['name'] ?? "Unknown"),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() => _selectedEventTypeId = val);
                        },
                      ),
                    ],
                  ],
                ),
              ),

              // Event Gallery
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle("Event Gallery"),
                    CustomText(
                      text: "Upload Event Images*",
                      fontSize: sizes?.fontSize14,
                      fontFamily: Assets.onsetMedium,
                    ),
                    CustomText(
                      text: "Upload up to 5 images",
                      fontSize: sizes?.fontSize12,
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _pickImages,
                      child: DottedBorderContainer(),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(_images.length, (index) {
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(_images[index].path),
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

              // Location
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle("Location"),
                    SizedBox(height: getHeight() * .02),
                    CustomField(
                      controller: _venueController,
                      borderColor: AppColors.greyBordersColor,
                      hint: "Restaurant name or venue",
                      label: "Venue Name",
                    ),
                    SizedBox(height: getHeight() * .02),
                    CustomField(
                      controller: _addressController,
                      borderColor: AppColors.greyBordersColor,
                      hint: "Address of venue",
                      label: "Address",
                      validate: (v) => v!.isEmpty ? "Required" : null,
                    ),
                  ],
                ),
              ),

              // Capacity & Pricing
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle("Capacity & Pricing"),
                    SizedBox(height: getHeight() * .02),
                    CustomField(
                      controller: _capacityController,
                      borderColor: AppColors.greyBordersColor,
                      hint: "Maximum number of persons",
                      label: "Maximum Capacity",
                      textInputType: TextInputType.number,
                      validate: (v) => v!.isEmpty ? "Required" : null,
                    ),
                    SizedBox(height: getHeight() * .02),
                    CustomField(
                      controller: _priceController,
                      borderColor: AppColors.greyBordersColor,
                      hint: "\$ 0.00",
                      label: "Price per person",
                      textInputType: TextInputType.number,
                      validate: (v) => v!.isEmpty ? "Required" : null,
                    ),
                  ],
                ),
              ),

              // Schedule
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle("Schedule"),
                    SizedBox(height: getHeight() * .02),
                    InkWell(
                      onTap: _pickDate,
                      child: AbsorbPointer(
                        child: CustomField(
                          borderColor: AppColors.greyBordersColor,
                          hint: "Select date",
                          label: "Event Date",
                          suffixIcon: Icons.calendar_month_rounded,
                          obscure: false, // Fix obscure
                          controller: TextEditingController(
                            text:
                                _selectedDate == null
                                    ? ""
                                    : DateFormat('yyyy-MM-dd').format(
                                      _selectedDate!,
                                    ),
                          ),
                          validate: (v) => v!.isEmpty ? "Required" : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pickTime(true),
                            child: AbsorbPointer(
                              child: CustomField(
                                borderColor: AppColors.greyBordersColor,
                                hint: "",
                                label: "Start Time",
                                suffixIconSvg: Assets.clockSvg,
                                controller: TextEditingController(
                                  text: _startTime?.format(context) ?? "",
                                ),
                                validate: (v) => v!.isEmpty ? "Required" : null,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pickTime(false),
                            child: AbsorbPointer(
                              child: CustomField(
                                borderColor: AppColors.greyBordersColor,
                                hint: "",
                                label: "End Time",
                                suffixIconSvg: Assets.clockSvg,
                                controller: TextEditingController(
                                  text: _endTime?.format(context) ?? "",
                                ),
                                validate: (v) => v!.isEmpty ? "Required" : null,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action Buttons
              Padding(
                padding:  EdgeInsets.symmetric(vertical: getHeight()*.03),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        backgroundColor: Colors.transparent,
                        buttonText: "Save as Draft",
                        textColor: Colors.black,
                        borderColor: Colors.black,
                        onTap: () {}, // Implement Draft later if API supports it
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        buttonText: "Publish",
                        isLoading: eventProvider.isLoading,
                        onTap: () => _submit(false),
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

// Reusable upload container
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
                const SizedBox(height: 8),
                CustomText(
                  text: "Tap to upload image",
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
