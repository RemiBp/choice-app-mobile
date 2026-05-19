import 'dart:io';

import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/providers/producer_provider.dart';
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

class CreateEvent extends StatefulWidget {
  /// Pass an existing event map to pre-fill the form for editing.
  final Map<String, dynamic>? existingEvent;
  const CreateEvent({super.key, this.existingEvent});

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
  bool _isSubmitting = false;
  String? _errorMessage;

  bool get _isEditing => widget.existingEvent != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existingEvent;
    if (e != null) {
      _eventNameController.text = e['title'] as String? ?? '';
      _descriptionController.text = e['description'] as String? ?? '';
      _venueController.text = e['venue'] as String? ?? '';
      _addressController.text = e['address'] as String? ?? '';
      _capacityController.text = (e['capacity'] ?? '').toString();
      _priceController.text = (e['price'] ?? '').toString();
      final start = e['startTime'] as String?;
      if (start != null) {
        try {
          final dt = DateTime.parse(start);
          _selectedDate = DateTime(dt.year, dt.month, dt.day);
          _startTime = TimeOfDay(hour: dt.hour, minute: dt.minute);
        } catch (_) {}
      }
      final end = e['endTime'] as String?;
      if (end != null) {
        try {
          final dt = DateTime.parse(end);
          _endTime = TimeOfDay(hour: dt.hour, minute: dt.minute);
        } catch (_) {}
      }
    }
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
      firstDate: DateTime.now().subtract(Duration(days: 1)),
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

  Future<void> _submit({required bool isDraft}) async {
    if (_eventNameController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Event name is required');
      return;
    }
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    String? startIso;
    String? endIso;
    if (_selectedDate != null && _startTime != null) {
      final s = DateTime(
        _selectedDate!.year, _selectedDate!.month, _selectedDate!.day,
        _startTime!.hour, _startTime!.minute,
      );
      startIso = s.toIso8601String();
    }
    if (_selectedDate != null && _endTime != null) {
      final e = DateTime(
        _selectedDate!.year, _selectedDate!.month, _selectedDate!.day,
        _endTime!.hour, _endTime!.minute,
      );
      endIso = e.toIso8601String();
    }

    final body = {
      'title': _eventNameController.text.trim(),
      'description': _descriptionController.text.trim(),
      'venue': _venueController.text.trim(),
      'address': _addressController.text.trim(),
      'capacity': int.tryParse(_capacityController.text.trim()) ?? 0,
      'price': double.tryParse(_priceController.text.trim()) ?? 0,
      if (startIso != null) 'startTime': startIso,
      if (endIso != null) 'endTime': endIso,
      'status': isDraft ? 'draft' : 'active',
    };

    final provider = context.read<ProducerProvider>();
    final result = _isEditing
        ? await provider.updateEvent(widget.existingEvent!['id'] as int, body)
        : await provider.createEvent(body);
    setState(() => _isSubmitting = false);

    if (result.success) {
      if (mounted) context.pop();
    } else {
      setState(
          () => _errorMessage = result.message ?? (_isEditing ? 'Failed to update event' : 'Failed to create event'));
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
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: Text(_isEditing ? "Edit Event" : "Create Event", style: TextStyle(color: Colors.black)),
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
                      borderColor: AppColors.greyBordersColor,
                      hint: "E.g: Brochette boeuf...",
                      label: "Event Name",
                      textEditingController: _eventNameController,
                    ),
                    SizedBox(height: getHeight() * .02),
                    CustomField(
                      height: getHeight() * .1,
                      borderColor: AppColors.greyBordersColor,
                      hint: "Describe your event...",
                      label: "Description",
                      textEditingController: _descriptionController,
                    ),
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
                    SizedBox(height: 12),
                    GestureDetector(
                      onTap: _pickImages,
                      child: DottedBorderContainer(),
                    ),
                    SizedBox(height: 12),
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
                      borderColor: AppColors.greyBordersColor,
                      hint: "Restaurant name or venue",
                      label: "Venue Name",
                      textEditingController: _venueController,
                    ),
                    SizedBox(height: getHeight() * .02),
                    CustomField(
                      borderColor: AppColors.greyBordersColor,
                      hint: "Address of venue",
                      label: "Address",
                      textEditingController: _addressController,
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
                      borderColor: AppColors.greyBordersColor,
                      hint: "Maximum number of persons",
                      label: "Maximum Capacity",
                      textEditingController: _capacityController,
                    ),
                    SizedBox(height: getHeight() * .02),
                    CustomField(
                      borderColor: AppColors.greyBordersColor,
                      hint: "\$ 0.00",
                      label: "Price per person",
                      textEditingController: _priceController,
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
                          obscure: true,
                          textEditingController: TextEditingController(
                            text:
                                _selectedDate == null
                                    ? ""
                                    : DateFormat.yMMMMd().format(
                                      _selectedDate!,
                                    ),
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
                                borderColor: AppColors.greyBordersColor,
                                hint: "",
                                label: "Start Time",
                                suffixIconSvg: Assets.clockSvg,
                                textEditingController: TextEditingController(
                                  text: _startTime?.format(context) ?? "",
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
                                borderColor: AppColors.greyBordersColor,
                                hint: "",
                                label: "End Time",
                                suffixIconSvg: Assets.clockSvg,
                                textEditingController: TextEditingController(
                                  text: _endTime?.format(context) ?? "",
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

              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(_errorMessage!,
                      style: const TextStyle(color: Colors.red)),
                ),
              // Action Buttons
              Padding(
                padding: EdgeInsets.symmetric(vertical: getHeight() * .03),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        backgroundColor: Colors.transparent,
                        buttonText: "Save as Draft",
                        textColor: Colors.black,
                        borderColor: Colors.black,
                        onTap: _isSubmitting ? null : () => _submit(isDraft: true),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        buttonText: _isSubmitting ? '...' : (_isEditing ? "Update" : "Publish"),
                        onTap: _isSubmitting ? null : () => _submit(isDraft: false),
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
                SizedBox(height: 8),
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
