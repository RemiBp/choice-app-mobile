import 'package:choice_app/res/res.dart';
import 'package:choice_app/appColors/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../data/models/post_model.dart';
import '../../../data/services/api_service.dart';
import 'suggest_time_view.dart';
import 'venue_detail_view.dart';
import '../../../appAssets/app_assets.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../customWidgets/animations/bouncing_wrapper.dart';
import '../../../customWidgets/glass/glass_container.dart';
import '../../restaurant/home/producer_post_provider.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});

  final dynamic post; // Can be PostModel or Map for flexibility

  @override
  Widget build(BuildContext context) {
    // Extract data
    final bool isModel = post is PostModel;
    final description = isModel ? post.description : post['description'] ?? "";
    final userName = isModel ? (post.userName ?? "User") : (post['user']?['userName'] ?? "User");
    final userImage = isModel ? post.userImage : post['user']?['profileImageUrl'];
    final category = isModel ? post.type : post['type'] ?? "Restaurant";
    final producerName = isModel ? null : post['producer']?['name']; // Backend usually nesting producer differently
    
    final images = isModel ? (post.images ?? []) : ((post['images'] as List<dynamic>?)?.map((i) => i['url'].toString()).toList() ?? []);
    final overallRating = isModel ? post.globalRating?.toStringAsFixed(1) : (post['globalRating'] ?? 0.0).toString();
    final producerId = isModel ? post.producerId : post['producerId'];
    final producer = isModel 
      ? {'id': post.producerId, 'name': post.userName, 'type': post.type} 
      : (post['producer'] ?? {'id': post['producerId'], 'name': post['producerName'], 'type': post['type']});

    // Edge-to-edge design: No margins, just bottom breathing space
    // Clean Card Design
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Tighter margins
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // Slightly tighter radius
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04), // Lighter shadow
            blurRadius: 12,
            offset: Offset(0, 4),
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. User Header (Mockup Alignment)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: userImage != null ? NetworkImage(userImage) : null,
                  backgroundColor: Colors.grey[200],
                  child: userImage == null ? Icon(Icons.person, color: Colors.grey, size: 20) : null,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: userName,
                                fontSize: sizes?.fontSize14,
                                fontFamily: Assets.onsetSemiBold,
                                color: Colors.black,
                              ),
                              CustomText(
                                text: "3 days ago",
                                fontSize: sizes?.fontSize11,
                                color: AppColors.textGreyColor,
                                fontFamily: Assets.onsetMedium,
                              ),
                            ],
                          ),
                          const Icon(Icons.more_vert, color: Colors.grey, size: 20),
                        ],
                      ),
                      const SizedBox(height: 8),
                      BouncingWrapper(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VenueDetailView(
                                producer: producer,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: producerName,
                                    fontSize: sizes?.fontSize14,
                                    fontFamily: Assets.onsetBold,
                                    color: Colors.black,
                                  ),
                                  CustomText(
                                    text: "58 Rue de Tilloy, Beauvais, France", // Mock Place
                                    fontSize: sizes?.fontSize11,
                                    color: AppColors.textGreyColor,
                                    fontFamily: Assets.onsetMedium,
                                    lines: 1,
                                    textOverflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getCategoryColor(category).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: CustomText(
                                text: category,
                                fontSize: 10,
                                color: _getCategoryColor(category),
                                fontFamily: Assets.onsetSemiBold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. Image Carousel
          if (images.isNotEmpty)
          Stack(
            children: [
               CarouselSlider(
                items: images.map<Widget>((url) {
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(url.toString()),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: getHeight() * 0.45,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                  autoPlay: false,
                ),
              ),
              if (overallRating != null)
              Positioned(
                top: 10,
                right: 10,
                child: GlassContainer(
                  blur: 10,
                  opacity: 0.2,
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Color(0xFFFFD700), size: 16),
                        const SizedBox(width: 4),
                        CustomText(
                          text: overallRating,
                          color: Colors.white,
                          fontSize: sizes?.fontSize12,
                          fontFamily: Assets.onsetBold,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 3. Action Bar (Mocking high-density social stats)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _buildIconAction(context, Icons.favorite_border, '2.2k', onTap: () {
                        final postId = isModel ? post.id : post['id'];
                        if (postId != null) {
                          context.read<ProducerPostProvider>().toggleLike(postId);
                        }
                      }),
                      const SizedBox(width: 15),
                      _buildIconAction(context, Icons.chat_bubble_outline, '3.2k'),
                      const SizedBox(width: 15),
                      _buildIconAction(context, Icons.send_outlined, '1.2k'),
                    ],
                  ),
                  const SizedBox(width: 12), // Add spacing
                  // Premium Interested Button
                  BouncingWrapper(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SuggestTimeView(post: post),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)], // Violet Gradient from mockup
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          CustomText(
                            text: "Interested (0)",
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: Assets.onsetBold,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildIconAction(context, Icons.bookmark_border, ''),
                ],
              ),
            ),
          ),

          // 4. Detailed Ratings Grid (Dynamic Choice Feedback)
          if (post['criteriaRatings'] != null)
            _buildRatingsGrid(context, post['criteriaRatings'], category),

          // 5. Description and Tags
          if (description.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: description,
                  fontSize: sizes?.fontSize14,
                  color: Colors.black87,
                  giveLinesAsText: true,
                  height: 1.4,
                ),
                if (post['tags'] != null && (post['tags'] as List).isNotEmpty) ...[
                SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: (post['tags'] as List<dynamic>)
                      .map((tag) => CustomText(
                          text: "#${tag['name']}",
                          color: const Color(0xFF57B46F), // Mockup Green
                          fontSize: sizes?.fontSize12,
                          fontFamily: Assets.onsetMedium,
                        ))
                      .toList(),
                ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingsGrid(BuildContext context, Map<String, dynamic> ratings, String category) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.greyColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 16,
        children: ratings.entries.map((e) {
          final label = _getCriteriaLabel(e.key, category);
          final value = double.tryParse(e.value.toString()) ?? 0.0;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: label, fontSize: sizes?.fontSize12, fontFamily: Assets.onsetMedium),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 14),
                  SizedBox(width: 4),
                  CustomText(text: value.toStringAsFixed(1), fontSize: sizes?.fontSize12, fontFamily: Assets.onsetBold),
                ],
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'restaurant': return Colors.orange;
      case 'wellness': return Colors.pinkAccent;
      case 'leisure': return Colors.purple;
      default: return AppColors.userPrimaryColor;
    }
  }

  Widget _buildIconAction(BuildContext context, IconData icon, String label, {VoidCallback? onTap}) {
    return BouncingWrapper(
      onTap: onTap ?? () {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text("$label action coming soon!")),
        );
      },
      child: Row(
        children: [
          Icon(icon, size: 26, color: Colors.black87),
          if (label.isNotEmpty) ...[
            SizedBox(width: 6),
            CustomText(
              text: label,
              fontSize: sizes?.fontSize14,
              fontFamily: Assets.onsetMedium,
              color: Colors.black87,
            ),
          ],
        ],
      ),
    );
  }

  String _getCriteriaLabel(String key, String category) {
    final labels = {
      'restaurant': {'criteria1': 'Flavor', 'criteria2': 'Service', 'criteria3': 'Place', 'criteria4': 'Portions'},
      'leisure': {'criteria1': 'Stage Direction', 'criteria2': 'Actor Performance', 'criteria3': 'Text Quality', 'criteria4': 'Scenography'},
      'wellness': {'criteria1': 'Expertise', 'criteria2': 'Comfort', 'criteria3': 'Cleanliness', 'criteria4': 'Atmosphere'}
    };
    return labels[category.toLowerCase()]?[key] ?? key;
  }
}
