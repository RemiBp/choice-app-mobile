import 'package:carousel_slider/carousel_slider.dart';
import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/res/res.dart';
import 'package:flutter/material.dart';

import '../../../appAssets/app_assets.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key, this.post});

  final Map<String, dynamic>? post;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int _currentImage = 0;
  bool _liked = false;

  List<String> get _images {
    final raw = widget.post?['images'];
    if (raw is List && raw.isNotEmpty) return raw.map((e) => e.toString()).toList();
    final single = widget.post?['imageUrl'] as String?;
    if (single != null && single.isNotEmpty) return [single];
    return [
      'https://www.imagelato.com/images/article-image-ample-service-area-34a39db5.jpg',
    ];
  }

  String get _title =>
      widget.post?['producer']?['businessName'] as String? ??
      widget.post?['user']?['fullName'] as String? ??
      'Choice';

  String get _role =>
      widget.post?['producer']?['type'] as String? ?? '';

  String get _description =>
      widget.post?['description'] as String? ??
      widget.post?['content'] as String? ??
      '';

  String? get _avatarUrl =>
      widget.post?['producer']?['avatarUrl'] as String? ??
      widget.post?['user']?['avatarUrl'] as String?;

  List<String> get _tags {
    final raw = widget.post?['tags'];
    if (raw is List) return raw.map((t) => t.toString()).toList();
    return [];
  }

  int get _likes => (widget.post?['likesCount'] as num?)?.toInt() ?? 0;
  int get _comments => (widget.post?['commentsCount'] as num?)?.toInt() ?? 0;

  String _formatCount(int n) =>
      n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : n.toString();

  String _formatDate(String iso) {
    try {
      final d = DateTime.parse(iso);
      final diff = DateTime.now().difference(d);
      if (diff.inDays >= 1) return '${diff.inDays}d ago';
      if (diff.inHours >= 1) return '${diff.inHours}h ago';
      if (diff.inMinutes >= 1) return '${diff.inMinutes}m ago';
      return 'Just now';
    } catch (_) {
      return '';
    }
  }

  Color get _roleColor {
    switch (_role.toLowerCase()) {
      case 'restaurant': return AppColors.restaurantPrimaryColor;
      case 'leisure': return AppColors.leisurePrimaryColor;
      case 'wellness': return AppColors.wellnessPrimaryColor;
      default: return AppColors.primarySlateColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final imgs = _images;
    final dateStr = widget.post?['createdAt'] != null
        ? _formatDate(widget.post!['createdAt'].toString())
        : '';

    return Container(
      margin: EdgeInsets.only(bottom: getHeight() * .018),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.greyColor,
                  backgroundImage: _avatarUrl != null ? NetworkImage(_avatarUrl!) : null,
                  child: _avatarUrl == null
                      ? Icon(Icons.store, size: 20, color: Colors.grey.shade500)
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: _title,
                        fontSize: sizes?.fontSize14,
                        fontFamily: Assets.onsetSemiBold,
                      ),
                      if (dateStr.isNotEmpty)
                        CustomText(
                          text: dateStr,
                          fontSize: sizes?.fontSize11,
                          color: AppColors.primarySlateColor,
                        ),
                    ],
                  ),
                ),
                if (_role.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _roleColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CustomText(
                      text: _role[0].toUpperCase() + _role.substring(1),
                      fontSize: sizes?.fontSize10,
                      color: _roleColor,
                      fontFamily: Assets.onsetMedium,
                    ),
                  ),
                const SizedBox(width: 4),
                Icon(Icons.more_vert, size: 18, color: AppColors.primarySlateColor),
              ],
            ),
          ),

          // ── Description ─────────────────────────────────────
          if (_description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: CustomText(
                text: _description,
                fontSize: sizes?.fontSize14,
                giveLinesAsText: true,
                color: AppColors.blackColor,
              ),
            ),

          // ── Tags ────────────────────────────────────────────
          if (_tags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                children: _tags.take(5).map((t) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.getPrimaryColorFromContext(context).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '#$t',
                    style: TextStyle(
                      color: AppColors.getPrimaryColorFromContext(context),
                      fontSize: sizes?.fontSize11 ?? 11,
                      fontFamily: Assets.onsetMedium,
                    ),
                  ),
                )).toList(),
              ),
            ),

          // ── Image carousel ──────────────────────────────────
          Stack(
            children: [
              CarouselSlider(
                items: imgs.map((url) => ClipRRect(
                  borderRadius: imgs.length == 1
                      ? BorderRadius.circular(0)
                      : BorderRadius.zero,
                  child: Image.network(
                    url,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade100,
                      child: const Center(child: Icon(Icons.image_not_supported, color: Colors.grey)),
                    ),
                  ),
                )).toList(),
                options: CarouselOptions(
                  height: getHeight() * .35,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                  autoPlay: imgs.length > 1,
                  autoPlayInterval: const Duration(seconds: 4),
                  onPageChanged: (i, _) => setState(() => _currentImage = i),
                ),
              ),
              if (imgs.length > 1)
                Positioned(
                  bottom: 8,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      imgs.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: _currentImage == i ? 16 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _currentImage == i ? Colors.white : Colors.white54,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // ── Actions ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _liked = !_liked),
                  child: Row(
                    children: [
                      Icon(
                        _liked ? Icons.favorite : Icons.favorite_border,
                        size: 20,
                        color: _liked ? Colors.red : AppColors.textGreyColor,
                      ),
                      const SizedBox(width: 4),
                      CustomText(
                        text: _formatCount(_likes + (_liked ? 1 : 0)),
                        fontSize: sizes?.fontSize12,
                        color: AppColors.textGreyColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Row(
                  children: [
                    Icon(Icons.chat_bubble_outline, size: 20, color: AppColors.textGreyColor),
                    const SizedBox(width: 4),
                    CustomText(
                      text: _formatCount(_comments),
                      fontSize: sizes?.fontSize12,
                      color: AppColors.textGreyColor,
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Icon(Icons.share_outlined, size: 20, color: AppColors.textGreyColor),
                const Spacer(),
                Icon(Icons.bookmark_border, size: 20, color: AppColors.textGreyColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
