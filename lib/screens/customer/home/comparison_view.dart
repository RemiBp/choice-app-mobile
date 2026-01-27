import 'package:flutter/material.dart';
import '../../../../res/res.dart';
import 'package:choice_app/appAssets/app_assets.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../customWidgets/animations/bouncing_wrapper.dart';
import '../../../../customWidgets/custom_button.dart';

class ComparisonView extends StatelessWidget {
  const ComparisonView({super.key, required this.venueA, required this.venueB});
  final dynamic venueA;
  final dynamic venueB;

  @override
  Widget build(BuildContext context) {
    final catA = venueA['type'] ?? "Restaurant";
    final metrics = ["criteria1", "criteria2", "criteria3", "criteria4"];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CustomText(text: "Compare Choices", fontFamily: Assets.onsetSemiBold, fontSize: 18),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.close, color: Colors.black), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Head-to-Head Header
            Row(
              children: [
                Expanded(child: _buildVenueHeader(venueA)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: CustomText(text: "VS", fontSize: 20, fontFamily: Assets.onsetBold, color: Colors.grey),
                ),
                Expanded(child: _buildVenueHeader(venueB ?? {'name': 'Select Rival', 'type': 'Any'})),
              ],
            ),
            const SizedBox(height: 40),
            
            // Comparison Grid
            Column(
              children: metrics.map((m) => _buildComparisonRow(m, catA)).toList(),
            ),

            const SizedBox(height: 50),
            CustomText(text: "The Verdict", fontSize: 18, fontFamily: Assets.onsetBold),
            const SizedBox(height: 8),
            CustomText(
              text: "${venueA['name']} leads in saveur and atmosphere, making it the preferred choice for tonight.",
              fontSize: 14,
              color: Colors.grey[700],
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 40),
            CustomButton(
              buttonText: "Confirm this Choice",
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVenueHeader(dynamic venue) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(40),
            image: const DecorationImage(
              image: NetworkImage("https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=200&q=80"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 12),
        CustomText(text: venue['name'] ?? "Venue", fontSize: 14, fontFamily: Assets.onsetBold, textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildComparisonRow(String key, String category) {
    final label = _getLabel(key, category);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        children: [
          CustomText(text: label, fontSize: 12, color: Colors.grey, fontFamily: Assets.onsetMedium),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildValueBar(4.8, true)),
              const SizedBox(width: 20),
              Expanded(child: _buildValueBar(4.2, false)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValueBar(double value, bool isLeft) {
    return Stack(
      alignment: isLeft ? Alignment.centerRight : Alignment.centerLeft,
      children: [
        Container(
          height: 8,
          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4)),
        ),
        FractionallySizedBox(
          widthFactor: value / 5,
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isLeft 
                  ? [const Color(0xFF8E2DE2), const Color(0xFF4A00E0)] 
                  : [Colors.orange, Colors.deepOrange],
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        Positioned(
          left: isLeft ? null : 0,
          right: isLeft ? 0 : null,
          top: -20,
          child: CustomText(text: value.toString(), fontSize: 10, fontFamily: Assets.onsetBold),
        )
      ],
    );
  }

  String _getLabel(String key, String category) {
     final labels = {
      'restaurant': {'criteria1': 'Flavor', 'criteria2': 'Service', 'criteria3': 'Place', 'criteria4': 'Portions'},
      'leisure': {'criteria1': 'Stage Direction', 'criteria2': 'Actor Performance', 'criteria3': 'Text Quality', 'criteria4': 'Scenography'},
      'wellness': {'criteria1': 'Expertise', 'criteria2': 'Comfort', 'criteria3': 'Cleanliness', 'criteria4': 'Atmosphere'}
    };
    return labels[category.toLowerCase()]?[key] ?? key;
  }
}
