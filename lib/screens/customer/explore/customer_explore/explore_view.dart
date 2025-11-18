import 'package:choice_app/screens/customer/explore/browse_producers/browse_producers_view.dart';
import 'package:choice_app/screens/customer/explore/browse_producers/search_producer_view.dart';
import 'package:choice_app/screens/customer/explore/restaurant_explore_details/restaurant_explore_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../appAssets/app_assets.dart';
import '../../../../appColors/colors.dart';
import '../../../../customWidgets/custom_button.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../customWidgets/custom_textfield.dart';
import '../../../../l18n.dart';
import '../../../../res/res.dart';
import '../../../restaurant/profile_menu/profile_menu_widgets.dart';
import '../../maps/customer_maps/customer_maps_view.dart';
import '../restaurant_explore_details/non_event_explore_details.dart';
import 'customer_explore_view_provider.dart';
import 'explore_widgets.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ExploreViewProvider>(context, listen: false);
    Future.microtask(() {
      provider.getEventsNearMe();
      provider.getNearbyProducers(
        allowedTypes: ["wellness", "restaurant"],
      ); // fetch producers for Surprise Me
    });
  }
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExploreViewProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Padding(
        padding: EdgeInsets.only(top: getHeight() * .07),
        child: Column(
          children: [
            //  HEADER stays fixed
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Choice",
                        fontSize: sizes?.fontSize28,
                        fontFamily: Assets.onsetSemiBold,
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_on_sharp,
                              color: AppColors.userPrimaryColor),
                          CustomText(
                            text: "Lyon, France",
                            fontSize: sizes?.fontSize16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.userPrimaryColor,
                          ),
                          Icon(Icons.keyboard_arrow_down,
                              color: AppColors.userPrimaryColor),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  CustomIconButton(
                    svgString: Assets.mapIcon,
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerMapsView()),
                      );
                    },
                  ),
                  SizedBox(width: getWidth() * .02),
                  CustomIconButton(svgString: Assets.chatIcon),
                  SizedBox(width: getWidth() * .02),
                  CustomIconButton(svgString: Assets.notificationIcon),
                ],
              ),
            ),
            SizedBox(height: getHeight() * .02),

            //  SEARCH stays fixed
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchProducersScreen(),
                    ),
                  );
                },
                child: AbsorbPointer(
                  child: CustomField(
                    borderColor: AppColors.greyBordersColor,
                    hint: al.searchPlaceholder,
                    prefixIconSvg: Assets.searchIcon,
                  ),
                ),
              ),
            ),
            SizedBox(height: getHeight() * .02),

            // SCROLLABLE CONTENT
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  //  Browse by Category
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
                    child: BrowseCategoryWidget(
                      imagePaths: [
                        Assets.restaurantImage,
                        Assets.wellnessImage,
                        Assets.leisureImage,
                      ],
                      labels: [
                        al.categoryRestaurant,
                        al.categoryWellness,
                        al.categoryLeisure,
                      ],
                      onCategoryTap: (category) {
                        // Navigate based on the tapped category
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BrowseProducersScreen(
                              categoryType: category, // optional parameter you can define
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: getHeight() * 0.02),
                  //EVENTS NEAR YOU section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
                    child: SeeMoreWidget(header: al.eventsNearYou),
                  ),

                  SizedBox(height: getHeight() * 0.015),

                  SizedBox(
                    height: getHeight() * 0.48,
                    child: provider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : provider.events.isEmpty
                        ? const Center(child: Text("No events nearby"))
                        : ListView.builder(
                      padding: EdgeInsets.symmetric(
                          horizontal: sizes!.pagePadding),
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.events.length,
                      itemBuilder: (context, index) {
                        final event = provider.events[index];

                        return SizedBox(
                          width: getWidth() * 0.75,
                          child: ExploreEventsCard(
                            event: Event(
                              title: event.title ?? "Untitled",
                              tag: event.serviceType ?? "Restaurant",
                              location: event.location ?? "Unknown",
                              dateTime:
                              "${event.date ?? ''} ${event.startTime ?? ''} - ${event.endTime ?? ''}",
                              price: "\$${event.pricePerGuest ?? '0'}",
                              imageUrl: event.eventImages?.isNotEmpty == true
                              ? "https://elasticbeanstalk-eu-west-3-838155148197.s3.eu-west-3.amazonaws.com/${event.eventImages!.first}"
                                : "https://via.placeholder.com/300",
                            ),
                            margin: EdgeInsets.only(
                              top: getHeight() * 0.01,
                              bottom: getHeight() * 0.01,
                              right: getWidth() * 0.03,
                            ),
                            onDetails: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RestaurantExploreDetails(
                                        eventId: event.id!,
                                        tag: event.serviceType ?? "Restaurant",
                                      ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: getHeight() * 0.02),

                  //  Surprise Me
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
                    child: SeeMoreWidget(header: al.surpriseMe),
                  ),

                  SizedBox(height: getHeight() * 0.015),

                  SizedBox(
                    height: getHeight() * 0.28,
                    child: Consumer<ExploreViewProvider>(
                      builder: (context, provider, _) {
                        if (provider.isProducersLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final producers = provider.nearbyProducers;

                        if (producers.isEmpty) {
                          return const Center(
                            child: Text(
                              "No nearby producers found",
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
                          scrollDirection: Axis.horizontal,
                          itemCount: producers.length,
                          itemBuilder: (context, index) {
                            final producer = producers[index];
                            final type = producer.type?.toLowerCase() ?? "";

                            return SizedBox(
                              width: getWidth() * 0.75,
                              child: FavouriteRestaurantCard(
                                imageUrl: producer.profileImage != null
                                    ? "https://elasticbeanstalk-eu-west-3-838155148197.s3.eu-west-3.amazonaws.com/${producer.profileImage}"
                                    : "https://via.placeholder.com/300",
                                restaurantName: producer.name,
                                address: producer.address.isNotEmpty
                                    ? producer.address
                                    : "No address available",
                                isFavourite: false,
                                chipText: type.isNotEmpty
                                    ? (type == "restaurant"
                                    ? "Restaurant"
                                    : type == "wellness"
                                    ? "Wellness"
                                    : null)
                                    : null,
                                chipColor: type == "restaurant"
                                    ? AppColors.restaurantPrimaryColor.withValues(alpha: 90)
                                    : type == "wellness"
                                    ? AppColors.wellnessPrimaryColor.withValues(alpha: 90)
                                    : Colors.grey,
                                margin: EdgeInsets.only(
                                  top: getHeight() * 0.01,
                                  bottom: getHeight() * 0.01,
                                  right: getWidth() * 0.03,
                                ),
                                onFavouriteTap: () {},
                                onRestaurantTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => NonEventDetailsScreen(
                                        type: producer.type.toLowerCase() ?? "",
                                        producerId: producer.id.toString(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
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

  final List<Event> dummyEvents = [
    Event(
      title: "Wine & Dine Evening",
      tag: al.categoryRestaurant,
      location: "Lyon, France",
      dateTime: "June 20, 10:00 PM – 12:00 PM",
      price: "\$30.00",
      imageUrl:
      "https://images.unsplash.com/photo-1528605248644-14dd04022da1",
    ),
    Event(
      title: "Beach Leisure Party",
      tag: al.categoryLeisure,
      location: "Nice, France",
      dateTime: "July 15, 6:00 PM – 11:00 PM",
      price: "\$45.00",
      imageUrl:
      "https://images.unsplash.com/photo-1528605248644-14dd04022da1",
    ),
    Event(
      title: "Romantic Dinner Night",
      tag: al.categoryRestaurant,
      location: "Paris, France",
      dateTime: "Aug 5, 8:00 PM – 11:00 PM",
      price: "\$55.00",
      imageUrl:
      "https://images.unsplash.com/photo-1528605248644-14dd04022da1",
    ),
    Event(
      title: "Wellness Yoga Camp",
      tag: al.categoryWellness,
      location: "Bali, Indonesia",
      dateTime: "Sep 1, 7:00 AM – 6:00 PM",
      price: "\$90.00",
      imageUrl:
      "https://images.unsplash.com/photo-1528605248644-14dd04022da1",
    ),
  ];
}


class Event {
  final String title;
  final String tag;
  final String location;
  final String dateTime;
  final String price;
  final String imageUrl;

  Event({
    required this.title,
    required this.tag,
    required this.location,
    required this.dateTime,
    required this.price,
    required this.imageUrl,
  });
}
