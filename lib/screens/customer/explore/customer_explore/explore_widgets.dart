import 'package:choice_app/appColors/colors.dart';
import 'package:flutter/material.dart';
import '../../../../appAssets/app_assets.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../l18n.dart';
import '../../../../res/res.dart';
import 'explore_view.dart';


class BrowseCategoryWidget extends StatelessWidget {
  final List<String> imagePaths;
  final List<String> labels;
  final Function(String category)? onCategoryTap; // callback

  const BrowseCategoryWidget({
    super.key,
    required this.imagePaths,
    required this.labels,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SeeMoreWidget(header: al.browseByCategory),
        SizedBox(height: getHeight() * 0.015),
        SizedBox(
          height: getHeight() * 0.19,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: imagePaths.length,
            itemBuilder: (context, index) {
              final String label = labels[index]; // single label string

              return Padding(
                padding: EdgeInsets.only(right: getWidth() * 0.04),
                child: GestureDetector(
                  onTap: () {
                    // Send the lowercase category name
                    if (onCategoryTap != null) {
                      onCategoryTap!(label.toLowerCase());
                    }
                  },
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          imagePaths[index],
                          width: getWidth() * 0.28,
                          height: getWidth() * 0.28,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: getHeight() * 0.008),
                      CustomText(
                        text: label,
                        fontSize: sizes?.fontSize14,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}



class SeeMoreWidget extends StatelessWidget {
  final String? header;
  const SeeMoreWidget({super.key, this.header});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CustomText(
            text: header??al.browseByCategory,
            fontSize: sizes?.fontSize18,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
        ),
        CustomText(
          text: al.seeMore,
          fontSize: sizes?.fontSize14,
          fontWeight: FontWeight.w500,
          color: AppColors.userPrimaryColor,
        ),
      ],
    );
  }
}

class ExploreEventsCard extends StatelessWidget {
  final Event event;
  final Function onDetails;
  final EdgeInsetsGeometry? margin;
  const ExploreEventsCard({super.key, required this.event, required this.onDetails, this.margin});

  Color getTagColor(String tag) {
    switch (tag.toLowerCase()) {
      case "restaurant":
        return AppColors.restaurantPrimaryColor;
      case "wellness":
        return AppColors.wellnessPrimaryColor;
      case "leisure":
        return AppColors.leisurePrimaryColor;
      default:
        return AppColors.userPrimaryColor;
    }
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onDetails(),
      child: Container(
        height: getHeightRatio() * 310,
        margin: margin?? EdgeInsets.symmetric(vertical: getHeightRatio() * 8),
        padding: EdgeInsets.all(getWidthRatio() * 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image + Tag
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      event.imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: getHeightRatio() * 10,
                    left: getWidthRatio() * 10,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: getWidth() * 0.035,
                        vertical: getHeight() * 0.01,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.redColor.withAlpha(60),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: CustomText(
                        text: al.event,
                        fontSize: sizes?.fontSize12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.redColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: getHeightRatio() * 10),

            // Tag (Restaurant / Wellness / Leisure)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: getWidth() * 0.035,
                vertical: getHeight() * 0.01,
              ),
              decoration: BoxDecoration(
                color: getTagColor(event.tag).withAlpha(40),
                borderRadius: BorderRadius.circular(40),
              ),
              child: CustomText(
                text: event.tag,
                fontSize: sizes?.fontSize12,
                fontWeight: FontWeight.w500,
                color: getTagColor(event.tag),
              ),
            ),

            SizedBox(height: getHeightRatio() * 5),

            CustomText(
              text: event.title,
              fontSize: sizes?.fontSize18,
              fontFamily: Assets.onsetSemiBold,
            ),

            SizedBox(height: getHeightRatio() * 5),

            Row(
              children: [
                Icon(Icons.location_on,
                    color: AppColors.getPrimaryColorFromContext(context),
                    size: getHeightRatio() * 15),
                SizedBox(width: getWidth() * 0.02),
                CustomText(
                  text: event.location,
                  fontSize: sizes?.fontSize12,
                  fontFamily: Assets.onsetMedium,
                ),
              ],
            ),

            SizedBox(height: getHeightRatio() * 5),

            Row(
              children: [
                Icon(Icons.access_time_filled,
                    color: AppColors.getPrimaryColorFromContext(context),
                    size: getHeightRatio() * 15),
                SizedBox(width: 6),
                CustomText(
                  text: event.dateTime,
                  fontSize: sizes?.fontSize12,
                  fontFamily: Assets.onsetMedium,
                ),
              ],
            ),

            SizedBox(height: getHeightRatio() * 5),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Price
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: event.price,
                        style: TextStyle(
                          color: AppColors.getPrimaryColorFromContext(context),
                          fontFamily: Assets.onsetSemiBold,
                          fontSize: sizes?.fontSize16,
                        ),
                      ),
                      TextSpan(
                        text: '/${al.person}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: Assets.onsetRegular,
                          fontSize: sizes?.fontSize12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Avatars (static for now)
                Stack(
                  children: [
                    Container(width: getWidth() * .3),
                    Positioned(
                      right: 60,
                      child: _buildAvatar(
                        'https://randomuser.me/api/portraits/women/65.jpg',
                      ),
                    ),
                    Positioned(
                      right: 40,
                      child: _buildAvatar(
                        'https://randomuser.me/api/portraits/women/60.jpg',
                      ),
                    ),
                    Positioned(
                      right: 20,
                      child: _buildAvatar(
                        'https://randomuser.me/api/portraits/men/62.jpg',
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: _buildAvatarCircle('+10'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );

  }

  Widget _buildAvatar(String imageUrl) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 14,
        backgroundImage: NetworkImage(imageUrl),
      ),
    );
  }

  Widget _buildAvatarCircle(String text) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 14,
        backgroundColor: Colors.grey.shade400,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}


// class ExploreEventsCard extends StatelessWidget {
//   const ExploreEventsCard({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {},
//       child: Container(
//         height: getHeightRatio() * 320,
//         margin: EdgeInsets.symmetric(vertical: getHeightRatio() * 8),
//         padding: EdgeInsets.all(getWidthRatio() * 10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(16),
//                     child: Image.network(
//                       "https://images.unsplash.com/photo-1528605248644-14dd04022da1",
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   Positioned(
//                     top: getHeightRatio() * 10,
//                     left: getWidthRatio() * 10,
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: getWidth() * 0.035,
//                         vertical: getHeight() * 0.01,
//                       ),
//                       decoration: BoxDecoration(
//                         color: AppColors.redColor.withAlpha(60),
//                         borderRadius: BorderRadius.circular(40),
//                       ),
//                       child: CustomText(
//                         text: "Event",
//                         fontSize: sizes?.fontSize12,
//                         fontWeight: FontWeight.w500,
//                         color: AppColors.redColor,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             SizedBox(height: getHeightRatio() * 10),
//
//             Container(
//               padding: EdgeInsets.symmetric(
//                 horizontal: getWidth() * 0.035,
//                 vertical: getHeight() * 0.01,
//               ),
//               decoration: BoxDecoration(
//                 color: AppColors.getPrimaryColorFromContext(context).withAlpha(40),
//                 borderRadius: BorderRadius.circular(40),
//               ),
//               child: CustomText(
//                 text: "Restaurant",
//                 fontSize: sizes?.fontSize12,
//                 fontWeight: FontWeight.w500,
//                 color: AppColors.getPrimaryColorFromContext(context),
//               ),
//             ),
//
//             SizedBox(height: getHeightRatio() * 5),
//
//             CustomText(
//               text: "Wine & Dine Evening",
//               fontSize: sizes?.fontSize18,
//               fontFamily: Assets.onsetSemiBold,
//             ),
//
//             SizedBox(height: getHeightRatio() * 5),
//
//             Row(
//               children: [
//                 Icon(
//                   Icons.location_on,
//                   color: AppColors.getPrimaryColorFromContext(context),
//                   size: getHeightRatio() * 15,
//                 ),
//                 SizedBox(width: getWidth() * 0.02),
//                 CustomText(
//                   text: "Lyon, France",
//                   fontSize: sizes?.fontSize12,
//                   fontFamily: Assets.onsetMedium,
//                 ),
//               ],
//             ),
//
//             SizedBox(height: getHeightRatio() * 5),
//
//             Row(
//               children: [
//                 Icon(
//                   Icons.access_time_filled,
//                   color: AppColors.getPrimaryColorFromContext(context),
//                   size: getHeightRatio() * 15,
//                 ),
//                 SizedBox(width: 6),
//                 CustomText(
//                   text: "June 20, 10:00 PM – 12:00 PM",
//                   fontSize: sizes?.fontSize12,
//                   fontFamily: Assets.onsetMedium,
//                 ),
//               ],
//             ),
//
//             SizedBox(height: getHeightRatio() * 5),
//
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // Price
//                 RichText(
//                   text: TextSpan(
//                     children: [
//                       TextSpan(
//                         text: '\$30.00',
//                         style: TextStyle(
//                           color: AppColors.getPrimaryColorFromContext(context),
//                           fontFamily: Assets.onsetSemiBold,
//                           fontSize: sizes?.fontSize16,
//                         ),
//                       ),
//                       TextSpan(
//                         text: '/Person',
//                         style: TextStyle(
//                           color: Colors.grey[600],
//                           fontFamily: Assets.onsetRegular,
//                           fontSize: sizes?.fontSize12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 Stack(
//                   children: [
//                     Container(width: getWidth() * .3),
//                     Positioned(
//                       right: 60,
//                       child: _buildAvatar(
//                         'https://randomuser.me/api/portraits/women/65.jpg',
//                       ),
//                     ),
//                     Positioned(
//                       right: 40,
//                       child: _buildAvatar(
//                         'https://randomuser.me/api/portraits/women/60.jpg',
//                       ),
//                     ),
//                     Positioned(
//                       right: 20,
//                       child: _buildAvatar(
//                         'https://randomuser.me/api/portraits/men/62.jpg',
//                       ),
//                     ),
//                     Positioned(
//                       right: 0,
//                       child: _buildAvatarCircle('+10'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAvatar(String imageUrl) {
//     return CircleAvatar(
//       radius: 16,
//       backgroundColor: Colors.white,
//       child: CircleAvatar(
//         radius: 14,
//         backgroundImage: NetworkImage(imageUrl),
//       ),
//     );
//   }
//
//   Widget _buildAvatarCircle(String text) {
//     return CircleAvatar(
//       radius: 16,
//       backgroundColor: Colors.white,
//       child: CircleAvatar(
//         radius: 14,
//         backgroundColor: Colors.grey.shade400,
//         child: Text(
//           text,
//           style: const TextStyle(
//             fontSize: 10,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }


