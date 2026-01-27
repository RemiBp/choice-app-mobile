import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/appAssets/app_assets.dart';
import '../../../../res/res.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../customWidgets/animations/bouncing_wrapper.dart';
import '../../../../customWidgets/animations/fade_in_up.dart';
import '../../../../customWidgets/glass/glass_container.dart';
import 'suggest_time_view.dart';
import 'comparison_view.dart';
import 'home_widgets.dart'; 

class VenueDetailView extends StatelessWidget {
  const VenueDetailView({super.key, required this.producer});
  final dynamic producer;

  @override
  Widget build(BuildContext context) {
    final producerName = producer['name'] ?? "La Grande Brasserie";
    final category = producer['type'] ?? "Restaurant";
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. Hero Header
          SliverAppBar(
            expandedHeight: getHeight() * 0.4,
            pinned: true,
            elevation: 0,
            leading: IconButton(
              icon: CircleAvatar(
                backgroundColor: Colors.black26,
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                   Image.network(
                    "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-1.2.1&auto=format&fit=crop&w=1200&q=80",
                    fit: BoxFit.cover,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: CustomText(
                            text: category,
                            fontSize: 10,
                            fontFamily: Assets.onsetBold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomText(
                          text: producerName,
                          fontSize: 28,
                          color: Colors.white,
                          fontFamily: Assets.onsetBold,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Info & Stats
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHeaderStat("⭐ 4.8", "Global"),
                      _buildHeaderStat("🤝 1.2k", "Friends"),
                      _buildHeaderStat("🔥 High", "Popularity"),
                    ],
                  ),
                  const SizedBox(height: 30),
                  
                  // Action Buttons ROW
                  Row(
                    children: [
                      Expanded(
                        child: BouncingWrapper(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SuggestTimeView(post: {'producer': producer, 'producerId': producer['id']})),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)]),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: CustomText(text: "Interested", color: Colors.white, fontFamily: Assets.onsetBold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      BouncingWrapper(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ComparisonView(
                                venueA: producer,
                                venueB: {'name': 'Mock Competitor', 'type': producer['type'] ?? 'Restaurant'},
                              ),
                            ),
                          );
                        },
                        child: Container(
                           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                           decoration: BoxDecoration(
                             color: Colors.grey[100],
                             borderRadius: BorderRadius.circular(12),
                           ),
                           child: const Icon(Icons.compare_arrows, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                  CustomText(text: "Soul Metrics", fontSize: 18, fontFamily: Assets.onsetBold),
                  const SizedBox(height: 16),
                  _buildDetailedRatings(category),

                   const SizedBox(height: 40),
                  CustomText(text: "Social Density", fontSize: 18, fontFamily: Assets.onsetBold),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(Assets.mapImage, height: 180, width: double.infinity, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 8),
                  CustomText(text: "Live view of ChoiceApp community near here", fontSize: 12, color: Colors.grey),

                  const SizedBox(height: 40),
                  CustomText(text: "Services & Specialties", fontSize: 18, fontFamily: Assets.onsetBold),
                  const SizedBox(height: 16),
                  _buildServiceList(),
                  
                  const SizedBox(height: 100), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String value, String label) {
    return Column(
      children: [
        CustomText(text: value, fontSize: 16, fontFamily: Assets.onsetBold),
        CustomText(text: label, fontSize: 12, color: Colors.grey),
      ],
    );
  }

  Widget _buildDetailedRatings(String category) {
    // Mapping keys to names for demo
    final metrics = ["criteria1", "criteria2", "criteria3", "criteria4"];
    return Column(
      children: metrics.map((m) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: _getLabel(m, category), fontSize: 14),
              Row(
                children: List.generate(5, (index) => Icon(Icons.star, size: 14, color: index < 4 ? Colors.amber : Colors.grey[200])),
              ),
            ],
          ),
        );
      }).toList(),
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

  Widget _buildServiceList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey[100]!), borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8))),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: "Specialty Service ${index + 1}", fontSize: 14, fontFamily: Assets.onsetSemiBold),
                    CustomText(text: "45.00 €", fontSize: 12, color: AppColors.userPrimaryColor),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
            ],
          ),
        );
      },
    );
  }
}
