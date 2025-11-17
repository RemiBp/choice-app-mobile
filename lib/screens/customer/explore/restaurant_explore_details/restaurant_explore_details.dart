import 'package:choice_app/screens/customer/explore/restaurant_explore_details/event_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readmore/readmore.dart';

import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/customWidgets/custom_button.dart';
import 'package:choice_app/customWidgets/shadow_icon.dart';
import 'package:choice_app/appAssets/app_assets.dart';
import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/l18n.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/screens/customer/explore/book_now/book_now_view.dart';
import 'package:choice_app/screens/customer/explore/full_menu/full_menu_view.dart';
import 'package:choice_app/screens/customer/explore/participants/participants_screen.dart';
import 'package:choice_app/screens/customer/explore/customer_gallery/customer_gallery_screen.dart';
import 'package:choice_app/screens/customer/explore/restaurant_explore_details/restaurant_explore_widgets.dart';

import '../../../../models/get_events_details_response.dart';
import '../../../onboarding/menu/menu_widgets.dart';
import '../../../restaurant/profile_menu/profile_menu_widgets.dart';
import 'package:choice_app/screens/onboarding/menu/menu_widgets.dart' as menuWidgets;


class RestaurantExploreDetails extends StatefulWidget {
  final int eventId;
  final String tag;

  const RestaurantExploreDetails({
    super.key,
    required this.eventId,
    required this.tag,
  });

  @override
  State<RestaurantExploreDetails> createState() =>
      _RestaurantExploreDetailsState();
}

class _RestaurantExploreDetailsState extends State<RestaurantExploreDetails> {
  int _currentImageIndex = 0;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    Future.microtask(() {
      Provider.of<EventDetailsProvider>(context, listen: false)
          .getEventById(widget.eventId);
    });
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
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

  String formatEventDate(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      DateTime dt = DateTime.parse(date);
      return DateFormat('EEEE, MMMM d, yyyy').format(dt);
      // Example output: Monday, November 6, 2025
    } catch (e) {
      return date; // fallback to raw string if parse fails
    }
  }

  String formatEventTime(String? start, String? end) {
    if ((start ?? "").isEmpty && (end ?? "").isEmpty) return "";
    DateFormat input = DateFormat('HH:mm'); // backend format
    DateFormat output = DateFormat('h:mm a'); // 12-hour with AM/PM

    String startFormatted = '';
    String endFormatted = '';

    if (start != null && start.isNotEmpty) {
      try {
        startFormatted = output.format(input.parse(start));
      } catch (_) {}
    }

    if (end != null && end.isNotEmpty) {
      try {
        endFormatted = output.format(input.parse(end));
      } catch (_) {}
    }

    if (startFormatted.isEmpty) return endFormatted;
    if (endFormatted.isEmpty) return startFormatted;

    return "$startFormatted - $endFormatted"; // Example: 12:00 PM - 10:00 PM
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EventDetailsProvider>(
      create: (ctx) => EventDetailsProvider()..getEventById(widget.eventId),
      builder: (context, _) {
        return Consumer<EventDetailsProvider>(
          builder: (context, provider, _) {
            final loading = provider.isLoading;
            final EventData? event = provider.eventData;

            return Scaffold(
              backgroundColor: Colors.white,
              body: loading
                  ? const Center(child: CircularProgressIndicator())
                  : event == null
                  ? Center(
                child: CustomText(
                  text: "Event not found",
                  fontSize: sizes?.fontSize16,
                ),
              )
                  : _buildContent(context, provider, event),
            );
          },
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, EventDetailsProvider provider,
      EventData event) {
    final images = event.eventImages ?? [];
    final producer = event.producer;

    // Menu categories
    final menuCategories = producer?.menuCategory ?? [];

    // Socials
    final website = producer?.website;
    final instagram = producer?.instagram;
    final twitter = producer?.twitter;
    final facebook = producer?.facebook;

    final participantCount = event.totalParticipants ?? 0;
    final maxCapacity = event.maxCapacity ?? 0;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image carousel
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageGalleryScreen(
                    restaurantId: producer?.id.toString() ?? '0',
                  ),
                ),
              );
            },
            child: Stack(
              children: [
                Container(
                  color: Colors.grey.shade200,
                  height: getHeight() * .33,
                  width: double.infinity,
                  child: images.isEmpty
                      ? Image.asset(
                    Assets.mapImage,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                      : PageView.builder(
                    controller: _pageController,
                    onPageChanged: (idx) {
                      setState(() => _currentImageIndex = idx);
                    },
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      final imgPath = images[index];
                      final url =
                          "https://elasticbeanstalk-eu-west-3-838155148197.s3.eu-west-3.amazonaws.com/$imgPath";
                      return Image.network(
                        url,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        loadingBuilder: (c, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                        errorBuilder: (c, e, s) => Container(
                          color: Colors.grey.shade200,
                          child:
                          const Center(child: Icon(Icons.image)),
                        ),
                      );
                    },
                  ),
                ),
                // Back button
                Positioned(
                  top: getHeight() * .06,
                  left: 16,
                  child: IconButton.filled(
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.white30,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
                // Image counter
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "${images.isEmpty ? 0 : (_currentImageIndex + 1)}/${images.length == 0 ? 1 : images.length}",
                      style:
                      const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Tags row
          Row(
            children: [
              EventTag(
                margin: EdgeInsets.only(left: sizes!.pagePadding, right: 8),
              ),
              EventTag(
                text: widget.tag,
                color: getTagColor(),
              ),
            ],
          ),
          SizedBox(height: getHeight() * .02),

          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
            child: CustomText(
              text: event.title ?? '',
              fontSize: sizes?.fontSize20,
              fontFamily: Assets.onsetSemiBold,
            ),
          ),

          SizedBox(height: getHeight() * .02),

          // Date/time
          IconTextWidget(
            text: formatEventDate(event.date),
            icon: Assets.calender,
            subText: formatEventTime(event.startTime, event.endTime),
            color: AppColors.getPrimaryColorFromContext(context),
          ),
          SizedBox(height: getHeight() * .01),

          // Address
          IconTextWidget(
            text: event.location ?? (producer?.address ?? ''),
            icon: Assets.restaurantLocationIcon,
            subText: producer?.address ?? '',
            color: AppColors.getPrimaryColorFromContext(context),
          ),
          SizedBox(height: getHeight() * .01),

          // Ticket info
          IconTextWidget(
            text:  event.pricePerGuest != null ? "\$${event.pricePerGuest}${al.perPerson}" : "-",
            icon: Assets.ticketIcon,
            subText:al.ticketPrice,
            color: AppColors.getPrimaryColorFromContext(context),
          ),

          Divider(color: AppColors.greyColor),
          SizedBox(height: getHeight() * .01),

          // Participants
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: al.participants,
                  fontSize: sizes?.fontSize16,
                  fontFamily: Assets.onsetSemiBold,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ParticipantsScreen()),
                    );
                  },
                  child: CustomText(
                    text: al.showAll,
                    fontSize: sizes?.fontSize14,
                    fontFamily: Assets.onsetMedium,
                    color: AppColors.getPrimaryColorFromContext(context),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: getHeight() * .01),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(width: getWidth() * .23),
                    if (participantCount > 0)
                      Positioned(
                        right: 60,
                        child: _buildAvatar(
                            'https://randomuser.me/api/portraits/women/65.jpg'),
                      ),
                    if (participantCount > 1)
                      Positioned(
                        right: 40,
                        child: _buildAvatar(
                            'https://randomuser.me/api/portraits/women/60.jpg'),
                      ),
                    if (participantCount > 2)
                      Positioned(
                        right: 20,
                        child: _buildAvatar(
                            'https://randomuser.me/api/portraits/men/62.jpg'),
                      ),
                    Positioned(
                      right: 0,
                      child: _buildAvatarCircle(
                          '+${participantCount > 3 ? participantCount - 3 : 0}'),
                    ),
                  ],
                ),
                const Spacer(),
                SvgPicture.asset(Assets.peopleIcon),
                CustomText(
                  text: " $participantCount/$maxCapacity",
                  fontSize: sizes?.fontSize12,
                ),
              ],
            ),
          ),

          // Restaurant menu
          if ((widget.tag.toLowerCase() == "restaurant") &&
              menuCategories.isNotEmpty)
            Column(
              children: [
                Divider(color: AppColors.greyColor),
                SizedBox(height: getHeight() * .01),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
                  child: MenuGroupWidget(
                    menuGroup: MenuGroup(
                      title: menuCategories.first.name ?? '',
                      dishes: (menuCategories.first.dishes ?? [])
                          .map((d) => menuWidgets.Dish(
                        name: d.name ?? '',
                        description: d.description ?? '',
                        price: d.price ?? 0,
                      ))
                          .toList(),
                    ),
                    header: al.menu,
                    optionText: al.seeFullMenu,
                    hideBorder: true,
                    onAddDish: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FullMenuView()));
                    },
                  ),
                ),
              ],
            ),

          Divider(color: AppColors.greyColor),
          SizedBox(height: getHeight() * .01),

          // About / description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
            child: CustomText(
              text: al.aboutEvent,
              fontSize: sizes?.fontSize16,
              fontFamily: Assets.onsetSemiBold,
            ),
          ),
          SizedBox(height: getHeight() * .01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
            child: ReadMoreText(
              event.description ?? '',
              trimMode: TrimMode.Line,
              trimLines: 3,
              colorClickableText:
              AppColors.getPrimaryColorFromContext(context),
              trimCollapsedText: al.readMore,
              trimExpandedText: al.seeLess,
              style: TextStyle(
                fontSize: sizes?.fontSize16,
                color: AppColors.blackColor,
              ),
              moreStyle: TextStyle(
                fontSize: sizes?.fontSize14,
                color: AppColors.getPrimaryColorFromContext(context),
                fontFamily: Assets.onsetMedium,
              ),
            ),
          ),

          SizedBox(height: getHeight() * .01),
          Divider(color: AppColors.greyColor),

          // Location preview
          SizedBox(height: getHeight() * .01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
            child: CustomText(
              text: al.location,
              fontSize: sizes?.fontSize16,
              fontFamily: Assets.onsetSemiBold,
            ),
          ),
          SizedBox(height: getHeight() * .01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  Assets.locationIcon,
                  height: getHeight() * 0.022,
                  width: getHeight() * 0.022,
                  colorFilter: ColorFilter.mode(
                      AppColors.getPrimaryColorFromContext(context),
                      BlendMode.srcIn),
                ),
                SizedBox(width: getWidth() * 0.01),
                Expanded(
                  child: CustomText(
                    text: producer?.address ?? '',
                    fontSize: sizes?.fontSize12,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: getHeight() * .008),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
            child: Image.asset(Assets.mapImage, height: getHeight() * .2),
          ),

          SizedBox(height: getHeight() * .01),
          Divider(color: AppColors.greyColor),

          // Social links
          SizedBox(height: getHeight() * .01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
            child: CustomText(
              text: al.socialLinks,
              fontSize: sizes?.fontSize16,
              fontFamily: Assets.onsetSemiBold,
            ),
          ),
          SizedBox(height: getHeight() * .01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
            child: Row(
              children: [
                if (website != null && website.isNotEmpty)
                  ShadowIcon(
                    icon: Assets.websiteIcon,
                    color: AppColors.getPrimaryColorFromContext(context),
                  ),
                if (instagram != null && instagram.isNotEmpty)
                  ShadowIcon(
                    icon: Assets.instagramIcon,
                    color: AppColors.getPrimaryColorFromContext(context),
                  ),
                if (twitter != null && twitter.isNotEmpty)
                  ShadowIcon(
                    icon: Assets.xIcon,
                    color: AppColors.getPrimaryColorFromContext(context),
                  ),
                if (facebook != null && facebook.isNotEmpty)
                  ShadowIcon(
                    icon: Assets.facebookIcon,
                    color: AppColors.getPrimaryColorFromContext(context),
                  ),
              ],
            ),
          ),

          SizedBox(height: getHeight() * .01),
          Divider(color: AppColors.greyColor),

          // Organizer section
          SizedBox(height: getHeight() * .01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
            child: CustomText(
              text: al.organizer,
              fontSize: sizes?.fontSize16,
              fontFamily: Assets.onsetSemiBold,
            ),
          ),
          SizedBox(height: getHeight() * .01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
            child: _buildOrganizerTile(producer),
          ),

          SizedBox(height: getHeight() * .01),
          Divider(color: AppColors.greyColor),

          // More events
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomText(
                    text: al.moreEventsLikeThis,
                    fontSize: sizes?.fontSize16,
                    fontFamily: Assets.onsetSemiBold,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: CustomText(
                    text: al.showAll,
                    fontSize: sizes?.fontSize14,
                    fontFamily: Assets.onsetMedium,
                    color: AppColors.getPrimaryColorFromContext(context),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: getHeightRatio() * 230,
            child: provider.isMoreEventsLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.moreEventsList == null || provider.moreEventsList!.isEmpty
                ? Center(
              child: CustomText(
                text: "No similar events found",
                fontSize: sizes?.fontSize14,
              ),
            )
                : ListView.builder(
              padding: EdgeInsets.only(
                  left: getWidth() * 0.06, right: getWidth() * 0.03),
              scrollDirection: Axis.horizontal,
              itemCount: provider.moreEventsList!.length,
              itemBuilder: (context, index) {
                final event = provider.moreEventsList![index];

                final img = (event.eventImages != null &&
                    event.eventImages!.isNotEmpty)
                    ? "https://elasticbeanstalk-eu-west-3-838155148197.s3.eu-west-3.amazonaws.com/${event.eventImages!.first}"
                    : null;

                return SizedBox(
                  width: getWidthRatio() * 280,
                  child: FavouriteRestaurantCard(
                    restaurantName: event.title ?? 'Event',
                    address: event.location ?? '',
                    imageUrl: img ?? "https://dummyimage.com/600x400/cccccc/000000&text=No+Image",
                    isFavourite: false,
                    margin: EdgeInsets.only(
                        top: getHeightRatio() * 8,
                        bottom: getHeightRatio() * 8,
                        right: getWidth() * 0.03),
                    onFavouriteTap: () {},
                    onRestaurantTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantExploreDetails(
                            eventId: event.id!,
                            tag: widget.tag,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          // Bottom ticket + book now
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                horizontal: getWidth() * 0.06, vertical: getHeight() * 0.02),
            color: AppColors.whiteColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: al.ticketPrice,
                      fontSize: sizes?.fontSize12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.inputHintColor,
                    ),
                    Row(
                      children: [
                        CustomText(
                          text: event.pricePerGuest != null
                              ? "\$${event.pricePerGuest}"
                              : "\$0.00",
                          fontSize: sizes?.fontSize16,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w600,
                        ),
                        CustomText(
                          text: al.perPerson,
                          fontSize: sizes?.fontSize14,
                          color: AppColors.inputHintColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ],
                ),
                CustomButton(
                  buttonText: al.bookNow,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookNowScreen(
                              eventId: event.id!,
                              pricePerPerson: double.tryParse(event.pricePerGuest ?? "0") ?? 0.0,
                            )
                        ));
                  },
                  buttonWidth: getWidth() * .38,
                  height: getHeight() * 0.06,
                  backgroundColor: AppColors.userPrimaryColor,
                  borderColor: Colors.transparent,
                  textColor: Colors.white,
                  textFontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrganizerTile(Producer? producer) {
    final profileImage = producer?.profileImage ?? '';
    final name = producer?.name ?? '';

    return Row(
      children: [
        CircleAvatar(
          radius: getHeight() * 0.03,
          backgroundImage:
          profileImage.isNotEmpty ? NetworkImage(profileImage) : null,
          backgroundColor: Colors.grey.shade200,
          child: profileImage.isEmpty ? const Icon(Icons.person) : null,
        ),
        SizedBox(width: getWidth() * 0.02),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: name,
                fontWeight: FontWeight.w500,
                fontSize: sizes?.fontSize14,
                color: AppColors.blackColor,
              ),
              CustomText(
                text: 'Organize Team',
                fontWeight: FontWeight.w400,
                fontSize: sizes?.fontSize14,
              ),
            ],
          ),
        ),
        ShadowIcon(
          icon: Assets.phoneIcon,
          color: AppColors.getPrimaryColorFromContext(context),
        ),
        SizedBox(width: getWidth() * 0.02),
        ShadowIcon(
          icon: Assets.messagesIcon,
          color: AppColors.getPrimaryColorFromContext(context),
        ),
      ],
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
            fontSize: 10,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
