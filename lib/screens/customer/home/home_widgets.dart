import 'package:carousel_slider/carousel_slider.dart';
import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/screens/restaurant/home/choice_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../appAssets/app_assets.dart';
import '../../../l18n.dart';
import '../../../routes/routes.dart';

class PostCard extends StatefulWidget {
  final int index;

  const PostCard({super.key, required this.index});

  @override
  State<PostCard> createState() => _PostCardState();
}
class _PostCardState extends State<PostCard> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChoiceProvider>(context,listen: false);
    final post = provider.postsResponse.data![widget.index];
    final images = post.images ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top bar with user info
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            radius: getHeight() * .03,
            backgroundImage: NetworkImage(
              provider.postsResponse.data?[widget.index].coverImage??"",
            ),
          ),
          title: CustomText(
            text: 'Liberty Bite Bistro',
            fontSize: sizes?.fontSize16,
            fontFamily: Assets.onsetSemiBold,
            giveLinesAsText: true,
          ),
          subtitle: CustomText(
            text: provider.postsResponse.data![widget.index].createdAt != null
                ? timeago.format(
              DateTime.parse(provider.postsResponse.data![widget.index].createdAt!),
            )
                : 'nil',
            fontSize: sizes?.fontSize12,
            giveLinesAsText: true,
          ),
          trailing: Icon(Icons.more_vert),
        ),
        // Post description
        Consumer<ChoiceProvider>(
          builder: (context,provider,_) {
            return CustomText(
              text: provider.postsResponse.data?[widget.index].description ?? "",
              fontSize: sizes?.fontSize14,
              giveLinesAsText: true,
            );
          }
        ),
        SizedBox(height: getHeight() * 0.01),
        // Hashtags
        Wrap(
          spacing: 8,
          children: (post.postTags ?? [])
              .map(
                (tagItem) => Text(
              "#${tagItem.tag?.name ?? ''}",
              style: TextStyle(color: Colors.blue),
            ),
          )
              .toList(),
        ),
        SizedBox(height: getHeight() * 0.01),
        // Image carousel with indicator
        Stack(
          children: [
            CarouselSlider(
              items: images.map((img) {
                return GestureDetector(
                  onTap: () {
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: "Close",
                      barrierColor: AppColors.blackColor.withValues(alpha: 0.9),
                      transitionDuration: Duration(milliseconds: 200),
                      pageBuilder: (_, __, ___) {
                        return FullScreenImageViewer(
                          images: images.map((e) => e.url ?? "").toList(),
                          initialIndex: currentIndex,
                        );
                      },
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      img.url ?? "",
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: getHeight() * .4,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                onPageChanged: (i, _) {
                  setState(() => currentIndex = i);
                },
              ),
            ),

            //  IMAGE COUNTER
            Positioned(
              top: 10,
              right: 15,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${currentIndex + 1}/${images.length}",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),        SizedBox(height: getHeight() * .03),
        // Divider
        const Divider(),

        // Like, comment, share, bookmark
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIconText(Icons.favorite_outlined, '2.2k'),
              _buildIconText(Icons.chat_bubble, '3.2k'),
              _buildIconText(Assets.shareIcon, '1.2k'),
              _buildInterestedTag("${al.interested} (0)",context),
            ],
          ),
        ),
      ],
    );
  }

  // Icon + Text with border
  Widget _buildIconText(dynamic icon, String text) {
    Widget iconWidget;

    if (icon is IconData) {
      // Normal material icon
      iconWidget = Icon(
        icon,
        size: getHeight() * 0.016,
        color: AppColors.textGreyColor,
      );
    } else if (icon is String) {
      // SVG asset path
      iconWidget = SvgPicture.asset(
        icon,
        height: getHeight() * 0.016,
        colorFilter: ColorFilter.mode(AppColors.textGreyColor,BlendMode.srcIn),
      );
    } else {
      throw ArgumentError("icon must be IconData or String (SVG path)");
    }

    return Container(
      height: getHeight() * 0.035, // 28px
      width: getWidth() * 0.14,    // 55px
      margin: EdgeInsets.only(right: getWidth() * 0.01),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.textGreyColor, width: 1),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconWidget,
          SizedBox(width: getWidth() * 0.008),
          Flexible(
            child: CustomText(
              text: text,
              fontSize: sizes?.fontSize10,
              fontFamily: Assets.onsetMedium,
              color: AppColors.textGreyColor,
            ),
          ),
        ],
      ),
    );
  }


  // Interested Tag (wider now)
  Widget _buildInterestedTag(String label, BuildContext context) {
    return GestureDetector(
      onTap: () {
        //  Navigate wherever you want
        context.push(Routes.suggestTimeSlotRoute);
        // Navigator.pushNamed(context, Routes.suggestTimeSlotRoute);
      },
      child: Container(
        height: getHeight() * 0.035,
        width: getWidth() * 0.28,
        margin: EdgeInsets.only(left: getWidth() * 0.017),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF964DFF),
              Color(0xFFFC5D4A),
            ],
          ),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, color: Colors.white, size: getHeight() * 0.016),
            SizedBox(width: getWidth() * 0.01),
            Flexible(
              child: CustomText(
                text: label,
                fontSize: sizes?.fontSize10,
                fontFamily: Assets.onsetMedium,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenImageViewer extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const FullScreenImageViewer({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: controller,
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return InteractiveViewer(
                child: Center(
                  child: Image.network(
                    widget.images[index],
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),

          // Close Button
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

