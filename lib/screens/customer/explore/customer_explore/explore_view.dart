import 'package:choice_app/screens/customer/explore/restaurant_explore_details/restaurant_explore_details.dart';
import 'package:flutter/material.dart';
import '../../../../appAssets/app_assets.dart';
import '../../../../appColors/colors.dart';
import '../../../../customWidgets/custom_button.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../customWidgets/custom_textfield.dart';
import '../../../../res/res.dart';
import '../../../restaurant/profile_menu/profile_menu_widgets.dart';
import '../../maps/customer_maps/customer_maps_view.dart';
import 'explore_widgets.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: getHeight() * .07,
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
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
                                Icon(Icons.location_on_sharp, color: AppColors.userPrimaryColor,),
                                CustomText(
                                  text: "Lyon, France",
                                  fontSize: sizes?.fontSize16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.userPrimaryColor,
                                ),
                                Icon(Icons.keyboard_arrow_down, color: AppColors.userPrimaryColor,),
                              ],
                            ),

                          ],
                        ),
                        Spacer(),
                        CustomIconButton(svgString: Assets.mapIcon, onPress: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CustomerMapsView()),
                          );
                        },),
                        SizedBox(width: getWidth() * .02),
                        CustomIconButton(svgString: Assets.chatIcon),
                        SizedBox(width: getWidth() * .02),
                        CustomIconButton(svgString: Assets.notificationIcon),
                      ],
                    ),
                  ),
                  SizedBox(height: getHeight() * .02),
            Padding(
                    padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
                    child: CustomField(
                      controller: _searchController,
                      borderColor: AppColors.greyBordersColor,
                      hint: "Search by username or name...",
                      prefixIconSvg: Assets.searchIcon,
                    ),
                  ),
                  SizedBox(height: getHeight() * .02),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
                    child: SeeMoreWidget(),
                  ),
                  SizedBox(
                    height: getHeightRatio() * 310,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
                      scrollDirection: Axis.horizontal,
                      itemCount: dummyEvents.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: getWidthRatio() * 280, // card width
                          child: ExploreEventsCard(
                              event: dummyEvents[index],
                            margin: EdgeInsets.only(top: getHeightRatio() * 8, bottom: getHeightRatio() * 8, right: getWidth() * 0.03),
                            onDetails: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RestaurantExploreDetails(
                                  tag: dummyEvents[index].tag,
                                )),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: getHeight() * 0.02),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
                    child: SeeMoreWidget(),
                  ),
                  SizedBox(
                    height: getHeightRatio() * 230,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: getWidthRatio() * 280,
                          child: FavouriteRestaurantCard(
                            imageUrl: "https://images.unsplash.com/photo-1528605248644-14dd04022da1",
                            restaurantName: "Restaurant ${index + 1}",
                            address: "123 Main Street, City",
                            isFavourite: index % 2 == 0,
                            margin: EdgeInsets.only(top: getHeightRatio() * 8, bottom: getHeightRatio() * 8, right: getWidth() * 0.03),
                            onFavouriteTap: () {},
                            onRestaurantTap: () {},
                          ),
                        );
                      },
                    ),
                  )

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
      tag: "Restaurant",
      location: "Lyon, France",
      dateTime: "June 20, 10:00 PM – 12:00 PM",
      price: "\$30.00",
      imageUrl: "https://images.unsplash.com/photo-1528605248644-14dd04022da1",
    ),
    Event(
      title: "Beach Leisure Party",
      tag: "Leisure",
      location: "Nice, France",
      dateTime: "July 15, 6:00 PM – 11:00 PM",
      price: "\$45.00",
      imageUrl: "https://images.unsplash.com/photo-1528605248644-14dd04022da1",
    ),
    Event(
      title: "Romantic Dinner Night",
      tag: "Restaurant",
      location: "Paris, France",
      dateTime: "Aug 5, 8:00 PM – 11:00 PM",
      price: "\$55.00",
      imageUrl: "https://images.unsplash.com/photo-1528605248644-14dd04022da1",
    ),
    Event(
      title: "Wellness Yoga Camp",
      tag: "Wellness",
      location: "Bali, Indonesia",
      dateTime: "Sep 1, 7:00 AM – 6:00 PM",
      price: "\$90.00",
      imageUrl: "https://images.unsplash.com/photo-1528605248644-14dd04022da1",
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
