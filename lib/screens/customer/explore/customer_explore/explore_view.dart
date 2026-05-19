import 'dart:async';

import 'package:choice_app/providers/customer_provider.dart';
import 'package:choice_app/providers/producer_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../appAssets/app_assets.dart';
import '../../../../appColors/colors.dart';
import '../../../../customWidgets/custom_button.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../customWidgets/custom_textfield.dart';
import '../../../../res/res.dart';
import '../../../restaurant/profile_menu/profile_menu_widgets.dart';
import 'explore_widgets.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProducerProvider>().loadEvents();
      // Load nearby places using a default location (Paris) as fallback
      context.read<CustomerProvider>().loadNearby(
            latitude: 48.8566,
            longitude: 2.3522,
          );
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<CustomerProvider>().searchProducers(query);
    });
  }

  Event _mapEvent(Map<String, dynamic> e) {
    final images = e['images'] as List?;
    final imageUrl = images?.firstOrNull?.toString() ??
        e['imageUrl'] as String? ??
        'https://images.unsplash.com/photo-1528605248644-14dd04022da1';
    final price = e['price'];
    final priceFmt = price != null ? '\$$price' : '\$0.00';
    final role = e['producer']?['role'] as String? ?? 'Restaurant';
    final tag = role[0].toUpperCase() + role.substring(1).toLowerCase();

    String dateTime = 'TBD';
    final start = e['startTime'] as String?;
    if (start != null) {
      try {
        final s = DateTime.parse(start);
        dateTime =
            '${s.month}/${s.day}, ${s.hour}:${s.minute.toString().padLeft(2, '0')}';
      } catch (_) {
        dateTime = start;
      }
    }

    return Event(
      title: e['title'] as String? ?? 'Event',
      tag: tag,
      location: e['venue'] as String? ?? e['address'] as String? ?? '—',
      dateTime: dateTime,
      price: priceFmt,
      imageUrl: imageUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: getHeight() * .07),
        child: Column(
          children: [
            Expanded(
              child: Consumer2<ProducerProvider, CustomerProvider>(
                builder: (context, provider, customerProvider, _) {
                  final apiEvents =
                      provider.events.map(_mapEvent).toList();

                  return ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: sizes!.pagePadding),
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
                                context.push('/customer_maps');
                              },
                            ),
                            SizedBox(width: getWidth() * .02),
                            CustomIconButton(svgString: Assets.chatIcon),
                            SizedBox(width: getWidth() * .02),
                            CustomIconButton(
                                svgString: Assets.notificationIcon),
                          ],
                        ),
                      ),
                      SizedBox(height: getHeight() * .02),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: sizes!.pagePadding),
                        child: Column(
                          children: [
                            CustomField(
                              textEditingController: _searchController,
                              borderColor: AppColors.greyBordersColor,
                              hint: "Search by username or name...",
                              prefixIconSvg: Assets.searchIcon,
                              onChanged: _onSearchChanged,
                            ),
                            if (customerProvider.isSearchingProducers)
                              const Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: LinearProgressIndicator(),
                              )
                            else if (customerProvider.producerSearchResults.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: customerProvider.producerSearchResults.length > 5
                                      ? 5
                                      : customerProvider.producerSearchResults.length,
                                  separatorBuilder: (_, __) => Divider(
                                    height: 1,
                                    color: AppColors.greyBordersColor,
                                  ),
                                  itemBuilder: (context, index) {
                                    final p = customerProvider.producerSearchResults[index];
                                    final name = p['name'] as String? ?? p['fullName'] as String? ?? '—';
                                    final address = p['address'] as String? ?? p['city'] as String? ?? '';
                                    final avatar = p['profileImage'] as String?;
                                    final type = p['role'] as String? ?? p['type'] as String? ?? '';
                                    return ListTile(
                                      leading: CircleAvatar(
                                        radius: 18,
                                        backgroundImage: avatar != null && avatar.isNotEmpty
                                            ? NetworkImage(avatar)
                                            : null,
                                        child: avatar == null || avatar.isEmpty
                                            ? const Icon(Icons.store, size: 18)
                                            : null,
                                      ),
                                      title: CustomText(
                                        text: name,
                                        fontSize: sizes?.fontSize14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.blackColor,
                                      ),
                                      subtitle: address.isNotEmpty
                                          ? CustomText(
                                              text: type.isNotEmpty ? '$type · $address' : address,
                                              fontSize: sizes?.fontSize12,
                                              color: AppColors.primarySlateColor,
                                            )
                                          : null,
                                      onTap: () {
                                        _searchController.clear();
                                        customerProvider.clearProducerSearch();
                                        final tag = (p['role'] as String? ?? 'Restaurant');
                                        context.push('/event_details', extra: tag);
                                      },
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: getHeight() * .02),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: sizes!.pagePadding),
                        child: const SeeMoreWidget(header: 'Events Near You'),
                      ),
                      if (provider.isLoadingEvents && apiEvents.isEmpty)
                        const SizedBox(
                          height: 310,
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else
                        SizedBox(
                          height: getHeightRatio() * 310,
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: sizes!.pagePadding),
                            scrollDirection: Axis.horizontal,
                            itemCount: apiEvents.isNotEmpty
                                ? apiEvents.length
                                : _fallbackEvents.length,
                            itemBuilder: (context, index) {
                              final ev = apiEvents.isNotEmpty
                                  ? apiEvents[index]
                                  : _fallbackEvents[index];
                              return SizedBox(
                                width: getWidthRatio() * 280,
                                child: ExploreEventsCard(
                                  event: ev,
                                  margin: EdgeInsets.only(
                                    top: getHeightRatio() * 8,
                                    bottom: getHeightRatio() * 8,
                                    right: getWidth() * 0.03,
                                  ),
                                  onDetails: () {
                                    context.push(
                                      '/event_details',
                                      extra: ev.tag,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      SizedBox(height: getHeight() * 0.02),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: sizes!.pagePadding),
                        child: const SeeMoreWidget(header: 'Nearby Places'),
                      ),
                      if (customerProvider.isLoadingNearby &&
                          customerProvider.nearbyPlaces.isEmpty)
                        const SizedBox(
                          height: 230,
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else
                        SizedBox(
                          height: getHeightRatio() * 230,
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: sizes!.pagePadding),
                            scrollDirection: Axis.horizontal,
                            itemCount: customerProvider.nearbyPlaces.isNotEmpty
                                ? customerProvider.nearbyPlaces.length
                                : 3,
                            itemBuilder: (context, index) {
                              final place =
                                  customerProvider.nearbyPlaces.isNotEmpty
                                      ? customerProvider.nearbyPlaces[index]
                                      : null;
                              final name = place?['name'] as String? ??
                                  'Nearby Place ${index + 1}';
                              final address =
                                  place?['address'] as String? ?? '—';
                              final imageUrl = place?['profileImage']
                                      as String? ??
                                  'https://images.unsplash.com/photo-1528605248644-14dd04022da1';
                              return SizedBox(
                                width: getWidthRatio() * 280,
                                child: FavouriteRestaurantCard(
                                  imageUrl: imageUrl,
                                  restaurantName: name,
                                  address: address,
                                  isFavourite: false,
                                  margin: EdgeInsets.only(
                                    top: getHeightRatio() * 8,
                                    bottom: getHeightRatio() * 8,
                                    right: getWidth() * 0.03,
                                  ),
                                  onFavouriteTap: () {},
                                  onRestaurantTap: () {},
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<Event> _fallbackEvents = [
    Event(
      title: "Wine & Dine Evening",
      tag: "Restaurant",
      location: "Lyon, France",
      dateTime: "June 20, 10:00 PM – 12:00 PM",
      price: "\$30.00",
      imageUrl:
          "https://images.unsplash.com/photo-1528605248644-14dd04022da1",
    ),
    Event(
      title: "Wellness Yoga Camp",
      tag: "Wellness",
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
