import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../appAssets/app_assets.dart';
import '../../../../appColors/colors.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../l18n.dart';
import '../../../../res/res.dart';
import 'customer_profile_provider.dart';

class CustomerChoice extends StatelessWidget {
  const CustomerChoice({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProfileProvider>(context);
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
      itemCount: provider.userPosts?.length ?? 0,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {},
          child: CustomerPostCard(index: index),
        );
      },
    );
  }
}

class CustomerPostCard extends StatelessWidget {


  const CustomerPostCard({super.key, this.index = 0, this.showOtherUserDetails = false,});

  final int index;
  final bool showOtherUserDetails;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProfileProvider>(context);
    
    // Get post data based on showOtherUserDetails flag
    final userDetailPosts = provider.getUserDetailResponse?.data?.posts ?? [];
    final post = showOtherUserDetails && userDetailPosts.isNotEmpty
        ? userDetailPosts[index]
        : null;
    final userPost = showOtherUserDetails
        ? null
        : provider.userPosts?[index];
    
    // Use appropriate data source
    final coverImage = showOtherUserDetails
        ? (post?.coverImage ?? "")
        : (userPost?.coverImage ?? "");
    final producerName = showOtherUserDetails
        ? ""
        : (userPost?.producer?.name ?? "");
    final publishDate = showOtherUserDetails
        ? post?.publishDate
        : userPost?.publishDate;
    final description = showOtherUserDetails
        ? (post?.description ?? "")
        : (userPost?.description ?? "");
    final tags = showOtherUserDetails
        ? <String>[]
        : (userPost?.tags ?? []);
    final images = showOtherUserDetails
        ? post?.images
        : userPost?.images;
    final likesCount = showOtherUserDetails
        ? (post?.likesCount ?? 0)
        : 0;
    final commentCount = showOtherUserDetails
        ? (post?.commentCount ?? 0)
        : 0;
    final shareCount = showOtherUserDetails
        ? (post?.shareCount ?? 0)
        : 0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top bar with user info
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            radius: getHeight() * .03,
            backgroundImage: NetworkImage(coverImage),
          ),
          title: CustomText(
            text: producerName,
            fontSize: sizes?.fontSize16,
            fontFamily: Assets.onsetSemiBold,
            giveLinesAsText: true,
          ),
          subtitle: CustomText(
            text: publishDate != null
                ? timeago.format(DateTime.parse(publishDate))
                : 'nil',
            fontSize: sizes?.fontSize12,
            giveLinesAsText: true,
          ),
          trailing: Icon(Icons.more_vert),
        ),
        // Post description
        CustomText(
          text: description,
          fontSize: sizes?.fontSize14,
          giveLinesAsText: true,
        ),
        SizedBox(height: getHeight() * 0.01),
        // Hashtags
        if (tags.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: tags
                .map((tag) => Text(
              '#$tag',
              style: TextStyle(
                color: Colors.blue,
                fontSize: sizes?.fontSize12,
                fontWeight: FontWeight.w500,
              ),
            ))
                .toList(),
          ),

        SizedBox(height: getHeight() * 0.01),
        // Image carousel with indicator
        Stack(
          children: [
            CarouselSlider(
              items: showOtherUserDetails
                  ? (post?.images?.map((img) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          img.url ?? "",
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      );
                    }).toList() ?? [])
                  : (userPost?.images?.map((url) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          url.url ?? "",
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      );
                    }).toList() ?? []),
              options: CarouselOptions(
                height: getHeight() * .4,
                viewportFraction: 1.0,
                enableInfiniteScroll: false,
                autoPlay: false,
              ),
            ),
            Positioned(
              top: 10,
              right: 15,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                color: Colors.black54,
                child: Text(
                  '1/${showOtherUserDetails ? (post?.images?.length ?? 0) : (userPost?.images?.length ?? 0)}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: getHeight() * .03),
        // Divider
        const Divider(),

        // Like, comment, share, bookmark
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIconText(
                Icons.favorite_outlined,
                showOtherUserDetails
                    ? '${likesCount}'
                    : '2.2k',
              ),
              _buildIconText(
                Icons.chat_bubble,
                showOtherUserDetails
                    ? '${commentCount}'
                    : '3.2k',
              ),
              _buildIconText(
                Assets.shareIcon,
                showOtherUserDetails
                    ? '${shareCount}'
                    : '1.2k',
              ),
              _buildInterestedTag("${al.interested} (0)"),
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
        colorFilter: ColorFilter.mode(AppColors.textGreyColor, BlendMode.srcIn),
      );
    } else {
      throw ArgumentError("icon must be IconData or String (SVG path)");
    }

    return Container(
      height: getHeight() * 0.035,
      // ~28px
      width: getWidth() * 0.14,
      // ~55px
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
  Widget _buildInterestedTag(String label) {
    return Container(
      height: getHeight() * 0.035,
      // ~28px
      width: getWidth() * 0.28,
      // (~105px)
      margin: EdgeInsets.only(left: getWidth() * 0.017),
      // control spacing
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF964DFF), Color(0xFFFC5D4A)],
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
    );
  }
}
