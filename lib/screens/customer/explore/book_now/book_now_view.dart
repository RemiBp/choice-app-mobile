import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../appColors/colors.dart';
import '../../../../customWidgets/common_app_bar.dart';
import '../../../../customWidgets/custom_button.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../customWidgets/custom_textfield.dart';
import '../../../../res/res.dart';
import '../../../../services/customer_service.dart';

class BookNowScreen extends StatefulWidget {
  /// The producer/event ID to book for.
  final int? producerId;
  final double? pricePerPerson;
  const BookNowScreen({super.key, this.producerId, this.pricePerPerson});

  @override
  State<BookNowScreen> createState() => _BookNowScreenState();
}

class _BookNowScreenState extends State<BookNowScreen> {
  int persons = 2;

  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  final _notesController = TextEditingController();

  bool _isSubmitting = false;
  String? _errorMessage;
  String? _successMessage;

  double get pricePerPerson => widget.pricePerPerson ?? 30.0;
  double get totalPrice => persons * pricePerPerson;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

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

  Future<void> _onContinue() async {
    if (_selectedDate == null) {
      setState(() => _errorMessage = 'Please select a date.');
      return;
    }
    if (_startTime == null) {
      setState(() => _errorMessage = 'Please select a start time.');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
      _successMessage = null;
    });

    final startDt = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _startTime!.hour,
      _startTime!.minute,
    );

    // Format date as YYYY-MM-DD and time strings as HH:MM for the API
    final dateStr =
        '${_selectedDate!.year.toString().padLeft(4, '0')}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';
    final startTimeStr =
        '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}';

    final body = <String, dynamic>{
      'guests': persons,
      'date': dateStr,
      'startTime': startTimeStr,
      'amount': totalPrice,
      if (_endTime != null)
        'endTime':
            '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}',
      if (_notesController.text.trim().isNotEmpty)
        'notes': _notesController.text.trim(),
      if (widget.producerId != null) 'producerId': widget.producerId,
    };

    final result = await CustomerBookingService.createBooking(body);
    if (!mounted) return;

    setState(() => _isSubmitting = false);

    if (result.success) {
      setState(() => _successMessage = 'Booking confirmed!');
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) context.pop();
    } else {
      setState(() => _errorMessage = result.message ?? 'Booking failed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(title: "Book Now"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Number of Persons",
              fontSize: sizes?.fontSize14,
              color: AppColors.blackColor,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.greyBordersColor),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 20),
                    color: AppColors.blackColor,
                    onPressed: persons > 1
                        ? () => setState(() => persons--)
                        : null,
                  ),
                  Expanded(
                    child: Center(
                      child: CustomText(
                        text: persons.toString(),
                        fontSize: sizes?.fontSize16,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 20),
                    color: AppColors.blackColor,
                    onPressed: () => setState(() => persons++),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Date picker
            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: CustomField(
                  borderColor: AppColors.greyBordersColor,
                  hint: "Select date",
                  label: "Date",
                  suffixIcon: Icons.calendar_month_rounded,
                  textEditingController: TextEditingController(
                    text: _selectedDate == null
                        ? ''
                        : DateFormat.yMMMMd().format(_selectedDate!),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),

            // Start / End time
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickTime(true),
                    child: AbsorbPointer(
                      child: CustomField(
                        borderColor: AppColors.greyBordersColor,
                        hint: "Start time",
                        label: "Start Time",
                        textEditingController: TextEditingController(
                          text: _startTime?.format(context) ?? '',
                        ),
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
                        hint: "End time (optional)",
                        label: "End Time",
                        textEditingController: TextEditingController(
                          text: _endTime?.format(context) ?? '',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            CustomField(
              textEditingController: _notesController,
              borderColor: AppColors.greyBordersColor,
              hint: "Any special requests...",
              label: "Notes (optional)",
              height: 80,
            ),

            if (_errorMessage != null) ...[
              SizedBox(height: 8),
              Text(_errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 13)),
            ],
            if (_successMessage != null) ...[
              SizedBox(height: 8),
              Text(_successMessage!,
                  style: const TextStyle(color: Colors.green, fontSize: 13)),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(
            horizontal: sizes!.pagePadding, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withAlpha(20),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CustomText(
                  text: "$persons Person${persons != 1 ? 's' : ''}",
                  fontSize: sizes?.fontSize12,
                  color: AppColors.primarySlateColor,
                  fontWeight: FontWeight.w500,
                ),
                const Spacer(),
                CustomText(
                  text: "\$${totalPrice.toStringAsFixed(2)}",
                  fontSize: sizes?.fontSize16,
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w600,
                )
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                CustomText(
                  text: "\$${pricePerPerson.toStringAsFixed(2)}",
                  fontSize: sizes?.fontSize16,
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w600,
                ),
                CustomText(
                  text: "/per person",
                  fontSize: sizes?.fontSize12,
                  color: AppColors.primarySlateColor,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            SizedBox(height: 16),
            CustomButton(
              buttonText: _isSubmitting ? '...' : "Confirm Booking",
              onTap: _isSubmitting ? null : _onContinue,
            ),
          ],
        ),
      ),
    );
  }
}
