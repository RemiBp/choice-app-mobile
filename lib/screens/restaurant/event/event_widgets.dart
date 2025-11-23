import 'package:choice_app/models/get_all_events_response.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/screens/restaurant/event/eventWidgets/delete_event.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../appAssets/app_assets.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_button.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../l18n.dart';
import 'event_provider.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key, this.isDraft = false,  this.eventsResponse});

  final bool isDraft;
  final Data? eventsResponse;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(
          Routes.restaurantEventDetailsRoute,
          extra: {"isDraft": isDraft},
        );
      },
      child: Container(
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Event image
            Container(
              height: getHeight() * .23,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                image: DecorationImage(
                  image: NetworkImage(
                   eventsResponse?.eventImages?.first??"" ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Padding for content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  CustomText(
                    text: eventsResponse?.title ?? "Unknown Event",
                    fontSize: sizes?.fontSize18,
                    fontFamily: Assets.onsetSemiBold,
                  ),
                  SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(Icons.location_on, color: AppColors.getPrimaryColorFromContext(context), size: 18, ),
                      SizedBox(width: 6),
                      CustomText(
                        text: eventsResponse?.location ?? "Unknown Location",
                        fontSize: sizes?.fontSize12,
                        fontFamily: Assets.onsetMedium,
                      ),
                    ],
                  ),
                  SizedBox(height: 6),

                  // Time
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_filled,
                        color: AppColors.getPrimaryColorFromContext(context),
                        size: 18,
                      ),
                      SizedBox(width: 6),
                      CustomText(
                        text: '${eventsResponse?.date}, ${eventsResponse?.startTime} - ${eventsResponse?.endTime}',
                        fontSize: sizes?.fontSize12,
                        fontFamily: Assets.onsetMedium,
                      ),
                    ],
                  ),
                  SizedBox(height: 12),

                  // Bottom row: Price + avatars
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '\$${eventsResponse?.pricePerGuest}',
                              style: TextStyle(
                                color: AppColors.getPrimaryColorFromContext(context),
                                fontFamily: Assets.onsetSemiBold,
                                fontSize: sizes?.fontSize16,
                              ),
                            ),
                            TextSpan(
                              text: '/Person',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontFamily: Assets.onsetRegular,
                                fontSize: sizes?.fontSize12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Stack(
                        children: [
                          Container(width: getWidth() * .3),
                          CircleAvatar(backgroundColor: Colors.transparent),
                          Positioned(
                            right: 60,
                            child: _buildAvatar(
                              'https://randomuser.me/api/portraits/women/65.jpg',
                            ),
                          ),
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
            isDraft
                ? Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: getHeight() * .02,
                    horizontal: getWidth() * .05,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          height: getHeight() * .055,
                          backgroundColor: Colors.transparent,
                          buttonText: al.delete,
                          textColor: Colors.red,
                          borderColor: Colors.red,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return DeleteEventDialog();
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: CustomButton(
                          height: getHeight() * .055,
                          buttonText:al.edit,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  // Avatar with image
  Widget _buildAvatar(String imageUrl) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.white,
      child: CircleAvatar(radius: 14, backgroundImage: NetworkImage(imageUrl)),
    );
  }

  // Avatar with count
  Widget _buildAvatarCircle(String text) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 14,
        backgroundColor: Colors.grey.shade400,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
