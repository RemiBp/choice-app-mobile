import 'package:choice_app/providers/customer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../appColors/colors.dart';
import '../../customWidgets/common_app_bar.dart';
import '../../customWidgets/custom_button.dart';
import '../../customWidgets/custom_text.dart';
import '../../res/res.dart';
import 'bookings_widgets.dart';

class BookingDetails extends StatefulWidget {
  final bool? isCancelled;
  final Map<String, dynamic>? booking;
  const BookingDetails({super.key, this.isCancelled, this.booking});

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  @override
  Widget build(BuildContext context) {
    final b = widget.booking ?? {};
    final user = b['user'] as Map<String, dynamic>? ?? {};
    final guests = (b['guests'] as num?)?.toInt() ?? 1;
    final amount = b['amount'] != null ? '\$${b['amount']}' : '—';
    final bookingId = b['id']?.toString() ?? '—';
    final bookingIdInt = b['id'] as int?;
    final startTime = b['startTime'] as String?;
    final endTime = b['endTime'] as String?;
    final cancelReason = b['cancellationReason'] as String? ??
        'Reservation was cancelled.';
    final notes = b['notes'] as String? ?? '—';
    final status = (b['status'] as String? ?? '').toLowerCase();
    final existingRating = b['rating'] as num?;
    final existingReview = b['review'] as String?;

    String dateStr = '—';
    String timeStr = '—';
    if (startTime != null) {
      try {
        final s = DateTime.parse(startTime);
        dateStr = '${_month(s.month)} ${s.day}, ${s.year}';
        final eStr = endTime != null
            ? '– ${_formatTime(DateTime.parse(endTime))}'
            : '';
        timeStr = '${_formatTime(s)} $eStr'.trim();
      } catch (_) {}
    }

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(title: "Booking Details"),
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: sizes!.pagePadding, vertical: getHeight() * 0.02),
        child: Column(
          children: [
            widget.isCancelled ?? false
                ? Expanded(
                    child: ListView(
                      children: [
                        CustomText(
                          text: "Cancellation Reason",
                          fontSize: sizes?.fontSize16,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: getHeight() * 0.02),
                        CustomText(
                          text: cancelReason,
                          fontSize: sizes?.fontSize14,
                          color: AppColors.primarySlateColor,
                          fontWeight: FontWeight.w500,
                          giveLinesAsText: true,
                        ),
                      ],
                    ),
                  )
                : Expanded(
                    child: ListView(
                      children: [
                        CustomText(
                          text: "Booking Information",
                          fontSize: sizes?.fontSize16,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: getHeight() * 0.02),
                        BookingInfoRow(
                            label: "Booking ID", value: '#$bookingId'),
                        SizedBox(height: getHeight() * 0.01),
                        BookingInfoRow(
                            label: "No. of Persons",
                            value: '$guests person${guests > 1 ? 's' : ''}'),
                        SizedBox(height: getHeight() * 0.01),
                        BookingInfoRow(label: "Date", value: dateStr),
                        SizedBox(height: getHeight() * 0.01),
                        BookingInfoRow(label: "Time", value: timeStr),
                        SizedBox(height: getHeight() * 0.01),
                        BookingInfoRow(label: "Amount", value: amount),
                        Divider(
                            color: AppColors.greyBordersColor,
                            height: getHeight() * 0.03),
                        CustomText(
                          text: "Customer Information",
                          fontSize: sizes?.fontSize16,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: getHeight() * 0.02),
                        BookingInfoRow(
                            label: "Customer Name:",
                            value: user['fullName'] as String? ?? '—'),
                        SizedBox(height: getHeight() * 0.01),
                        BookingInfoRow(
                            label: "Email:",
                            value: user['email'] as String? ?? '—'),
                        SizedBox(height: getHeight() * 0.01),
                        BookingInfoRow(
                            label: "Phone:",
                            value: user['phone'] as String? ?? '—'),
                        Divider(
                            color: AppColors.greyBordersColor,
                            height: getHeight() * 0.03),
                        CustomText(
                          text: "Notes",
                          fontSize: sizes?.fontSize16,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: getHeight() * 0.02),
                        CustomText(
                          text: notes,
                          fontSize: sizes?.fontSize14,
                          color: AppColors.primarySlateColor,
                          fontWeight: FontWeight.w500,
                          giveLinesAsText: true,
                        ),
                        // ── Review section for completed bookings ──
                        if (status == 'completed') ...[
                          Divider(
                              color: AppColors.greyBordersColor,
                              height: getHeight() * 0.03),
                          CustomText(
                            text: "Your Review",
                            fontSize: sizes?.fontSize16,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: getHeight() * 0.02),
                          if (existingRating != null) ...[
                            Row(
                              children: List.generate(5, (i) {
                                return Icon(
                                  i < existingRating.round()
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 22,
                                );
                              }),
                            ),
                            if (existingReview != null &&
                                existingReview.isNotEmpty) ...[
                              SizedBox(height: getHeight() * 0.01),
                              CustomText(
                                text: existingReview,
                                fontSize: sizes?.fontSize14,
                                color: AppColors.primarySlateColor,
                                fontWeight: FontWeight.w400,
                                giveLinesAsText: true,
                              ),
                            ],
                          ] else ...[
                            CustomText(
                              text: "You haven't reviewed this booking yet.",
                              fontSize: sizes?.fontSize14,
                              color: AppColors.primarySlateColor,
                              fontWeight: FontWeight.w400,
                            ),
                            SizedBox(height: getHeight() * 0.02),
                            if (bookingIdInt != null)
                              CustomButton(
                                buttonText: 'Leave a Review',
                                onTap: () => _showReviewSheet(
                                    context, bookingIdInt),
                              ),
                          ],
                        ],
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void _showReviewSheet(BuildContext context, int bookingId) {
    int selectedRating = 0;
    final commentController = TextEditingController();
    bool isSubmitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (sheetCtx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: sizes!.pagePadding,
                right: sizes!.pagePadding,
                top: getHeight() * 0.03,
                bottom:
                    MediaQuery.of(sheetCtx).viewInsets.bottom +
                        getHeight() * 0.03,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'Rate Your Experience',
                        fontSize: sizes?.fontSize18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(sheetCtx),
                        child: const Icon(Icons.close,
                            color: AppColors.primarySlateColor),
                      ),
                    ],
                  ),
                  SizedBox(height: getHeight() * 0.02),
                  // Star rating
                  Row(
                    children: List.generate(5, (i) {
                      return GestureDetector(
                        onTap: () =>
                            setModalState(() => selectedRating = i + 1),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(
                            i < selectedRating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 36,
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: getHeight() * 0.02),
                  // Comment field
                  Container(
                    height: getHeight() * 0.12,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.greyBordersColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: commentController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText: 'Share your experience (optional)...',
                        hintStyle: TextStyle(
                          color: AppColors.primarySlateColor,
                          fontSize: sizes?.fontSize14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                  ),
                  SizedBox(height: getHeight() * 0.02),
                  CustomButton(
                    buttonText: isSubmitting ? '...' : 'Submit Review',
                    onTap: isSubmitting || selectedRating == 0
                        ? null
                        : () async {
                            setModalState(() => isSubmitting = true);
                            final provider = context.read<CustomerProvider>();
                            final result = await provider.addReview(
                              bookingId,
                              {
                                'rating': selectedRating,
                                if (commentController.text.trim().isNotEmpty)
                                  'review': commentController.text.trim(),
                              },
                            );
                            if (!sheetCtx.mounted) return;
                            Navigator.pop(sheetCtx);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(result.success
                                    ? 'Review submitted!'
                                    : result.message ?? 'Failed to submit.'),
                                backgroundColor: result.success
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            );
                          },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _month(int m) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[m];
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final min = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour < 12 ? 'AM' : 'PM';
    return '$h:$min $period';
  }
}
