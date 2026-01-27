import 'package:choice_app/appAssets/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../res/res.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../customWidgets/custom_button.dart';
import 'interest_provider.dart';
import '../../../../appColors/colors.dart';

class SelectFriendsView extends StatefulWidget {
  const SelectFriendsView({
    super.key,
    required this.producerId,
    required this.date,
    required this.slotId,
    required this.slotTime,
    required this.message,
  });

  final int producerId;
  final String date;
  final int slotId;
  final String slotTime;
  final String message;

  @override
  State<SelectFriendsView> createState() => _SelectFriendsViewState();
}

class _SelectFriendsViewState extends State<SelectFriendsView> {
  final Set<int> selectedUserIds = {};
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InterestProvider>().fetchFriends();
    });
  }

  @override
  Widget build(BuildContext context) {
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
          text: "Select friends",
          fontSize: 18,
          fontFamily: Assets.onsetSemiBold,
          color: Colors.black,
        ),
      ),
      body: Consumer<InterestProvider>(
        builder: (context, provider, child) {
          final friends = provider.friends;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    if (val.length > 2) provider.searchFriends(val);
                    else if (val.isEmpty) provider.fetchFriends();
                  },
                  decoration: InputDecoration(
                    prefixText: "To: ",
                    prefixStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    hintText: "Type a username or name",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[200]!)),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[200]!)),
                  ),
                ),
              ),
              
              if (selectedUserIds.isNotEmpty)
                Container(
                  height: 100,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: selectedUserIds.map((id) {
                      final friend = friends.firstWhere((f) => f['id'] == id, orElse: () => null);
                      if (friend == null) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: friend['profileImage'] != null 
                                ? NetworkImage(friend['profileImage']) 
                                : null,
                              child: friend['profileImage'] == null ? const Icon(Icons.person) : null,
                            ),
                            const SizedBox(height: 4),
                            CustomText(text: friend['name']!.split(' ')[0], fontSize: 12),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

              Expanded(
                child: provider.isLoading 
                  ? const Center(child: CircularProgressIndicator())
                  : friends.isEmpty 
                    ? const Center(child: Text("No friends found"))
                    : ListView.separated(
                        itemCount: friends.length,
                        separatorBuilder: (context, index) => Divider(color: Colors.grey[100], height: 1),
                        itemBuilder: (context, index) {
                          final friend = friends[index];
                          final id = friend['id'];
                          bool isSelected = selectedUserIds.contains(id);
                          return ListTile(
                            onTap: () {
                              setState(() {
                                if (isSelected) selectedUserIds.remove(id);
                                else selectedUserIds.add(id);
                              });
                            },
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundImage: friend['profileImage'] != null 
                                ? NetworkImage(friend['profileImage']) 
                                : null,
                              child: friend['profileImage'] == null ? const Icon(Icons.person) : null,
                            ),
                            title: CustomText(
                              text: friend['name']!,
                              fontSize: 14,
                              fontFamily: Assets.onsetMedium,
                            ),
                            trailing: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: isSelected ? AppColors.userPrimaryColor : Colors.grey[300]!),
                                color: isSelected ? AppColors.userPrimaryColor : Colors.transparent,
                              ),
                              child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                            ),
                          );
                        },
                      ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomButton(
                  buttonText: provider.isLoading ? "Sending..." : "Send Invite",
                  onTap: provider.isLoading ? null : () async {
                    final success = await provider.createInterest(
                      producerId: widget.producerId,
                      date: widget.date,
                      timeSlot: widget.slotTime,
                      message: widget.message,
                      inviteeIds: selectedUserIds.toList(),
                    );

                    if (success && mounted) {
                      Navigator.popUntil(context, (route) => route.isFirst);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Invitations sent successfully!")),
                      );
                    } else if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: ${provider.errorMessage}")),
                      );
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
