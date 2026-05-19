import 'package:choice_app/screens/customer/explore/restaurant_explore_details/restaurant_explore_widgets.dart';
import 'package:choice_app/services/customer_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';
import '../../../../appAssets/app_assets.dart';
import '../../../../appColors/colors.dart';
import '../../../../customWidgets/custom_button.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../customWidgets/shadow_icon.dart';
import '../../../../res/res.dart';
import '../../../onboarding/menu/menu_widgets.dart';
import '../../../restaurant/profile_menu/profile_menu_widgets.dart';

class RestaurantExploreDetails extends StatefulWidget {
  final String tag;
  final int? producerId;
  const RestaurantExploreDetails({super.key, required this.tag, this.producerId});

  @override
  State<RestaurantExploreDetails> createState() => _RestaurantExploreDetailsState();
}

class _RestaurantExploreDetailsState extends State<RestaurantExploreDetails> {
  Map<String, dynamic>? _producer;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.producerId != null) _loadDetails();
  }

  Future<void> _loadDetails() async {
    setState(() => _loading = true);
    final r = await CustomerMapsService.getProducerDetails(widget.producerId!);
    if (r.success && mounted) {
      final data = r.data?['data'] as Map<String, dynamic>?;
      setState(() {
        _producer = data;
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  Color getTagColor() {
    switch (widget.tag.toLowerCase()) {
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

  String get _name => _producer?['name'] as String? ?? 'Venue';
  String get _address => _producer?['address'] as String? ?? '—';
  String get _description =>
      _producer?['details'] as String? ??
      _producer?['description'] as String? ??
      'No description available.';
  String get _phone => _producer?['phoneNumber'] as String? ?? '';
  String get _website => _producer?['website'] as String? ?? '';

  List<String> get _photoUrls {
    final photos = _producer?['photos'] as List?;
    if (photos != null && photos.isNotEmpty) {
      return photos
          .map((p) => (p is Map ? p['url'] as String? : p?.toString()) ?? '')
          .where((u) => u.isNotEmpty)
          .toList();
    }
    return ['https://images.unsplash.com/photo-1528605248644-14dd04022da1'];
  }

  final List<MenuGroup> menuGroups = [
    MenuGroup(
      title: 'Brochettes',
      dishes: List.generate(
          3, (_) => Dish(name: 'Al Salmone', description: 'Sauce blanche, saumon fume', price: 20)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.push('/customer_gallery',
                          extra: {'photos': _photoUrls});
                    },
                    child: ExploreEventHeader(photoUrl: _photoUrls.first),
                  ),
                  SizedBox(height: getHeight() * 0.02),

                  Row(
                    children: [
                      EventTag(
                        margin: EdgeInsets.only(
                            left: sizes!.pagePadding, right: getWidth() * 0.02),
                      ),
                      EventTag(
                        text: widget.tag,
                        color: getTagColor(),
                      ),
                    ],
                  ),
                  SizedBox(height: getHeight() * 0.02),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
                    child: CustomText(
                      text: _name,
                      fontSize: sizes?.fontSize20,
                      fontFamily: Assets.onsetSemiBold,
                    ),
                  ),
                  SizedBox(height: getHeight() * 0.02),

                  if (_address.isNotEmpty && _address != '—')
                    IconTextWidget(
                      text: _address,
                      icon: Assets.restaurantLocationIcon,
                      subText: _address,
                      color: getTagColor(),
                    ),

                  if (_phone.isNotEmpty) ...[
                    SizedBox(height: getHeight() * 0.01),
                    IconTextWidget(
                      text: _phone,
                      icon: Assets.ticketIcon,
                      subText: _phone,
                      color: getTagColor(),
                    ),
                  ],

                  Divider(color: AppColors.greyColor),
                  SizedBox(height: getHeight() * 0.01),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "Participants",
                          fontSize: sizes?.fontSize16,
                          fontFamily: Assets.onsetSemiBold,
                        ),
                        GestureDetector(
                          onTap: () => context.push('/participants'),
                          child: CustomText(
                            text: "Show All",
                            fontSize: sizes?.fontSize14,
                            fontFamily: Assets.onsetMedium,
                            color: getTagColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: getHeight() * 0.01),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            const SizedBox(width: 100),
                            CircleAvatar(backgroundColor: Colors.transparent),
                            Positioned(
                              right: 60,
                              child: _buildAvatar(
                                  'https://randomuser.me/api/portraits/women/65.jpg'),
                            ),
                            Positioned(
                              right: 40,
                              child: _buildAvatar(
                                  'https://randomuser.me/api/portraits/women/60.jpg'),
                            ),
                            Positioned(
                              right: 20,
                              child: _buildAvatar(
                                  'https://randomuser.me/api/portraits/men/62.jpg'),
                            ),
                            Positioned(
                              right: 0,
                              child: _buildAvatarCircle('+10'),
                            ),
                          ],
                        ),
                        const Spacer(),
                        SvgPicture.asset(Assets.peopleIcon),
                        CustomText(text: " 10/120", fontSize: sizes?.fontSize12),
                      ],
                    ),
                  ),

                  if (widget.tag.toLowerCase() == "restaurant") ...[
                    Divider(color: AppColors.greyColor),
                    SizedBox(height: getHeight() * 0.01),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
                      child: MenuGroupWidget(
                        menuGroup: menuGroups[0],
                        header: "Menu",
                        optionText: "See Full Menu",
                        hideBorder: true,
                        onAddDish: () => context.push('/full_menu'),
                      ),
                    ),
                  ],

                  Divider(color: AppColors.greyColor),
                  SizedBox(height: getHeight() * 0.01),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
                    child: CustomText(
                      text: "About",
                      fontSize: sizes?.fontSize16,
                      fontFamily: Assets.onsetSemiBold,
                    ),
                  ),
                  SizedBox(height: getHeight() * 0.01),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
                    child: ReadMoreText(
                      _description,
                      trimMode: TrimMode.Line,
                      trimLines: 2,
                      colorClickableText: Colors.pink,
                      trimCollapsedText: 'Read More',
                      trimExpandedText: 'See Less',
                      style: TextStyle(
                        fontSize: sizes?.fontSize16,
                        color: AppColors.blackColor,
                      ),
                      moreStyle: TextStyle(
                        fontSize: sizes?.fontSize14,
                        color: getTagColor(),
                        fontFamily: Assets.onsetMedium,
                      ),
                    ),
                  ),

                  SizedBox(height: getHeight() * 0.01),
                  Divider(color: AppColors.greyColor),
                  SizedBox(height: getHeight() * 0.01),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
                    child: CustomText(
                      text: "Location",
                      fontSize: sizes?.fontSize16,
                      fontFamily: Assets.onsetSemiBold,
                    ),
                  ),
                  SizedBox(height: getHeight() * 0.01),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
                    child: CustomText(
                      text: _address,
                      fontSize: sizes?.fontSize12,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
                    child: Image.asset(Assets.mapImage, height: getHeight() * .2),
                  ),

                  SizedBox(height: getHeight() * 0.01),
                  Divider(color: AppColors.greyColor),
                  SizedBox(height: getHeight() * 0.01),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
                    child: CustomText(
                      text: "Social Links",
                      fontSize: sizes?.fontSize16,
                      fontFamily: Assets.onsetSemiBold,
                    ),
                  ),
                  SizedBox(height: getHeight() * 0.01),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
                    child: Row(
                      children: [
                        if (_website.isNotEmpty)
                          ShadowIcon(icon: Assets.websiteIcon, color: getTagColor()),
                        SizedBox(width: getWidth() * 0.02),
                        ShadowIcon(icon: Assets.instagramIcon, color: getTagColor()),
                        SizedBox(width: getWidth() * 0.02),
                        ShadowIcon(icon: Assets.xIcon, color: getTagColor()),
                        SizedBox(width: getWidth() * 0.02),
                        ShadowIcon(icon: Assets.facebookIcon, color: getTagColor()),
                      ],
                    ),
                  ),

                  SizedBox(height: getHeight() * 0.01),
                  Divider(color: AppColors.greyColor),
                  SizedBox(height: getHeight() * 0.01),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
                    child: CustomText(
                      text: "Organizer",
                      fontSize: sizes?.fontSize16,
                      fontFamily: Assets.onsetSemiBold,
                    ),
                  ),
                  SizedBox(height: getHeight() * 0.01),
                  OrganizerTile(color: getTagColor()),
                  SizedBox(height: getHeight() * 0.01),
                  Divider(color: AppColors.greyColor),
                  SizedBox(height: getHeight() * 0.01),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "More Like This",
                          fontSize: sizes?.fontSize16,
                          fontFamily: Assets.onsetSemiBold,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: CustomText(
                            text: "Show All",
                            fontSize: sizes?.fontSize14,
                            fontFamily: Assets.onsetMedium,
                            color: getTagColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: getHeightRatio() * 230,
                    child: ListView.builder(
                      padding: EdgeInsets.only(
                          left: getWidth() * 0.06, right: getWidth() * 0.03),
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: getWidthRatio() * 280,
                          child: FavouriteRestaurantCard(
                            imageUrl:
                                "https://images.unsplash.com/photo-1528605248644-14dd04022da1",
                            restaurantName: "Venue ${index + 1}",
                            address: "Nearby",
                            isFavourite: false,
                            margin: EdgeInsets.only(
                                top: getHeightRatio() * 8,
                                bottom: getHeightRatio() * 8,
                                right: getWidth() * 0.03),
                            onFavouriteTap: () {},
                            onRestaurantTap: () {},
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: getWidth() * 0.06,
                        vertical: getHeight() * 0.02),
                    color: AppColors.whiteColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "Book a Table",
                              fontSize: sizes?.fontSize12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.inputHintColor,
                            ),
                            CustomText(
                              text: "Reserve Now",
                              fontSize: sizes?.fontSize16,
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 160,
                          height: 48,
                          child: CustomButton(
                            buttonText: 'Book Now',
                            onTap: () => context.push('/book_now'),
                            backgroundColor: AppColors.userPrimaryColor,
                            borderColor: Colors.transparent,
                            textColor: Colors.white,
                            textFontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
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
      child: CircleAvatar(radius: 14, backgroundImage: NetworkImage(imageUrl)),
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
              fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
