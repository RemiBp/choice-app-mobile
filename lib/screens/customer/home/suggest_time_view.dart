import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../res/res.dart';
import '../../../../appAssets/app_assets.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../customWidgets/custom_button.dart';
import '../../../../customWidgets/animations/bouncing_wrapper.dart';
import 'select_friends_view.dart';
import 'interest_provider.dart';

class SuggestTimeView extends StatefulWidget {
  const SuggestTimeView({super.key, required this.post});
  final dynamic post;

  @override
  State<SuggestTimeView> createState() => _SuggestTimeViewState();
}

class _SuggestTimeViewState extends State<SuggestTimeView> {
  DateTime selectedDate = DateTime.now();
  int? selectedSlotId;
  String? selectedSlotTime;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final producerId = widget.post is Map ? widget.post['producerId'] : widget.post.producerId;
      if (producerId != null) {
        context.read<InterestProvider>().fetchProducerSlots(producerId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final producerName = widget.post is Map ? (widget.post['producer']?['name'] ?? "The Wholesome Fork") : (widget.post.userName ?? "The Wholesome Fork");
    final producerId = widget.post is Map ? widget.post['producerId'] : widget.post.producerId;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomText(
          text: producerName,
          fontSize: 18,
          fontFamily: Assets.onsetSemiBold,
          color: Colors.black,
        ),
      ),
      body: Consumer<InterestProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.producerSlots.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Plan your visit",
                  fontSize: 20,
                  fontFamily: Assets.onsetBold,
                ),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.calendar_today_outlined, "Select a date and time", "Synchronize with your friends"),
                
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(text: "Select Date", fontSize: 16, fontFamily: Assets.onsetSemiBold),
                    GestureDetector(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 90)),
                        );
                        if (date != null) setState(() => selectedDate = date);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                        child: Row(children: [Icon(Icons.calendar_today, size: 14), SizedBox(width: 4), CustomText(text: "${selectedDate.day}/${selectedDate.month}")]),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                _buildDateSelector(),

                const SizedBox(height: 32),
                CustomText(text: "Available Slots", fontSize: 16, fontFamily: Assets.onsetSemiBold),
                const SizedBox(height: 12),
                _buildTimeGrid(provider.producerSlots),

                const SizedBox(height: 32),
                CustomText(text: "Message (Optional)", fontSize: 16, fontFamily: Assets.onsetSemiBold),
                const SizedBox(height: 12),
                TextField(
                  controller: _messageController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "e.g Let's try this Friday night?...",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
                  ),
                ),
                const SizedBox(height: 40),
                CustomButton(
                  buttonText: "Invite Friends",
                  onTap: () {
                    if (selectedSlotId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a time slot")));
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectFriendsView(
                          producerId: producerId,
                          date: selectedDate.toIso8601String().split('T')[0],
                          slotId: selectedSlotId!,
                          slotTime: selectedSlotTime!,
                          message: _messageController.text,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.lightBlue[50], shape: BoxShape.circle),
          child: Icon(icon, color: Colors.lightBlue, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(text: title, fontSize: 14, fontFamily: Assets.onsetSemiBold),
            CustomText(text: subtitle, fontSize: 12, color: Colors.grey),
          ],
        )
      ],
    );
  }

  Widget _buildDateSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (index) {
        final date = DateTime.now().add(Duration(days: index));
        bool isSelected = date.day == selectedDate.day;
        return GestureDetector(
          onTap: () => setState(() => selectedDate = date),
          child: Container(
            width: 60,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.lightBlue.withOpacity(0.1) : Colors.grey[100],
              border: isSelected ? Border.all(color: Colors.lightBlue) : null,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                CustomText(text: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][date.weekday - 1], fontSize: 12, color: isSelected ? Colors.lightBlue : Colors.grey),
                CustomText(text: date.day.toString(), fontSize: 16, fontFamily: Assets.onsetBold, color: isSelected ? Colors.lightBlue : Colors.black),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTimeGrid(List<dynamic> groupedSlots) {
    final dayName = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"][selectedDate.weekday - 1];
    final dayData = groupedSlots.firstWhere((element) => element['day'] == dayName, orElse: () => null);
    final slots = dayData != null ? dayData['slots'] as List : [];

    if (slots.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: CustomText(text: "No slots available for this day", color: Colors.grey),
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: slots.map((slot) {
        final id = slot['id'];
        final startTime = slot['startTime'];
        bool isSelected = selectedSlotId == id;
        return BouncingWrapper(
          onTap: () => setState(() {
            selectedSlotId = id;
            selectedSlotTime = startTime;
          }),
          child: Container(
            width: (MediaQuery.of(context).size.width - 64) / 3,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: isSelected ? Colors.lightBlue : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: CustomText(
                text: startTime,
                fontSize: 12,
                fontFamily: Assets.onsetMedium,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
