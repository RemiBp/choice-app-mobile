import 'package:choice_app/appColors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../appAssets/app_assets.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../customWidgets/custom_textfield.dart';
import '../../../../res/res.dart';
import '../../../../routes/routes.dart';
import '../customer_provider.dart';

class SubChoiceSelection extends StatefulWidget {
  final String selectedChoice;

  const SubChoiceSelection({super.key, required this.selectedChoice});

  @override
  _SubChoiceSelectionState createState() => _SubChoiceSelectionState();
}

class _SubChoiceSelectionState extends State<SubChoiceSelection> {
  int? selectedProducerId;
  String? selectedProducerName;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Mock location for Beauvais/Paris for now
      context.read<CustomerProvider>().searchVenues(
        lat: 49.43, 
        lng: 2.08,
        type: widget.selectedChoice.toUpperCase(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = GoRouterState.of(context).extra as Map<String, dynamic>?;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Choice'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Consumer<CustomerProvider>(
        builder: (context, provider, child) {
          final venues = provider.nearbyVenues;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildSelectedTypeCard(name: data?["title"], icon: data?["icon"]),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    text: data?["description"] ?? "Where did you go?",
                    fontFamily: Assets.onsetMedium,
                    fontSize: sizes?.fontSize14,
                  ),
                ),
                const SizedBox(height: 12),
                CustomField(
                  controller: _searchController,
                  borderColor: AppColors.greyBordersColor,
                  hint: "Search for a ${widget.selectedChoice.toLowerCase()}...",
                  prefixIconSvg: Assets.searchIcon,
                  onChanged: (val) {
                    // Could implement debounced search here
                  },
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: provider.isLoading 
                    ? const Center(child: CircularProgressIndicator())
                    : venues.isEmpty
                      ? const Center(child: Text("No venues found nearby"))
                      : ListView.separated(
                          itemCount: venues.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final v = venues[index];
                            final id = v['id'];
                            final name = v['restaurantName'] ?? v['userName'] ?? "Unknown";
                            final address = v['address'] ?? "No address";
                            final isSelected = selectedProducerId == id;
                            return ListTile(
                              title: CustomText(
                                text: name,
                                fontSize: sizes?.fontSize14,
                                fontFamily: Assets.onsetSemiBold,
                              ),
                              subtitle: CustomText(
                                text: address,
                                fontSize: sizes?.fontSize12,
                                color: Colors.grey,
                              ),
                              trailing: Icon(
                                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                color: isSelected ? AppColors.userPrimaryColor : Colors.grey,
                              ),
                              onTap: () => setState(() {
                                selectedProducerId = id;
                                selectedProducerName = name;
                              }),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          side: const BorderSide(color: Colors.black),
                        ),
                        child: CustomText(
                          text: "Back",
                          fontFamily: Assets.onsetSemiBold,
                          fontSize: sizes?.fontSize16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: selectedProducerId == null ? null : () {
                          context.push(Routes.createChoiceRoute, extra: {
                            "title": data?["title"],
                            "icon": data?["icon"],
                            "description": data?["description"],
                            "producerId": selectedProducerId,
                            "producerName": selectedProducerName,
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.userPrimaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: CustomText(
                          text: "Next",
                          fontFamily: Assets.onsetSemiBold,
                          fontSize: sizes?.fontSize16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedTypeCard({required String? name, required String? icon}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyBordersColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) SvgPicture.asset(icon, width: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: name ?? "Restaurant",
                  fontFamily: Assets.onsetMedium,
                  fontSize: sizes?.fontSize14,
                ),
                CustomText(
                  text: "Reviewing your experience at this venue.",
                  fontSize: sizes?.fontSize12,
                  color: Colors.grey,
                ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: CustomText(
                    text: "Change Type",
                    fontSize: sizes?.fontSize14,
                    fontFamily: Assets.onsetMedium,
                    color: AppColors.userPrimaryColor,
                    textDecoration: TextDecoration.underline,
                    decorationColor: AppColors.userPrimaryColor,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
