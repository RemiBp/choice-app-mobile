import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/screens/customer/maps/customer_maps/wellness_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../appAssets/app_assets.dart';
import '../../../../customWidgets/common_app_bar.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../data/services/map_service.dart';
import '../../../restaurant/profile_menu/profile_menu_widgets.dart';
import 'leisure_bottom_sheet.dart';
import 'restaurant_bottom_sheet.dart';

class CustomerMapsView extends StatefulWidget {
  const CustomerMapsView({super.key});

  @override
  State<CustomerMapsView> createState() => _CustomerMapsViewState();
}

class _CustomerMapsViewState extends State<CustomerMapsView> {
  final MapService _mapService = MapService();
  Set<Marker> _markers = {};
  GoogleMapController? _mapController;

  final List<Map<String, dynamic>> filters = [
    {"title": "Friends", "icon": Assets.profileIcon},
    {"title": "Restaurant", "icon": Assets.knifeForkIcon},
    {"title": "Wellness", "icon": Assets.wellnessIcon},
    {"title": "Leisure", "icon": Assets.leisureIcon},
  ];

  int selectedFilterIndex = 1; // Default to Restaurant
  List<dynamic> _nearbyVenues = [];

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(48.8566, 2.3522), // Paris
    zoom: 13.0,
  );

  @override
  void initState() {
    super.initState();
    _fetchNearbyVenues();
  }

  Future<void> _fetchNearbyVenues() async {
    try {
      final filter = filters[selectedFilterIndex]["title"];
      final response = await _mapService.getNearbyProducers(
        latitude: _initialPosition.target.latitude,
        longitude: _initialPosition.target.longitude,
        type: filter == "Friends" ? "ALL" : filter.toUpperCase(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        if (mounted) {
          setState(() {
            _nearbyVenues = data;
            _markers = data.map((v) {
              return Marker(
                markerId: MarkerId(v['id'].toString()),
                position: LatLng(
                  double.parse(v['latitude'].toString()),
                  double.parse(v['longitude'].toString()),
                ),
                infoWindow: InfoWindow(
                  title: v['restaurantName'] ?? v['userName'],
                  snippet: v['address'],
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  filter == "Restaurant" ? BitmapDescriptor.hueRed :
                  filter == "Wellness" ? BitmapDescriptor.hueGreen :
                  filter == "Leisure" ? BitmapDescriptor.hueViolet :
                  BitmapDescriptor.hueAzure
                ),
              );
            }).toSet();
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching venues: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Map & Location"),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            /// Google Map
            Positioned.fill(
              child: GoogleMap(
                initialCameraPosition: _initialPosition,
                onMapCreated: (controller) => _mapController = controller,
                markers: _markers,
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
              ),
            ),

            /// Top filter chips
            SafeArea(
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(top: 10),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: filters.length,
                  separatorBuilder: (_, __) => SizedBox(width: getWidth() * 0.02),
                  itemBuilder: (context, index) {
                    final filter = filters[index];
                    bool isSelected = index == selectedFilterIndex;
                    return ChoiceChip(
                      avatar: SvgPicture.asset(
                        filter["icon"],
                        width: 18,
                        height: 18,
                        color: isSelected ? Colors.white : AppColors.primarySlateColor,
                      ),
                      label: CustomText(
                        text: filter["title"],
                        fontSize: 12,
                        color: isSelected ? Colors.white : AppColors.primarySlateColor,
                        fontWeight: FontWeight.w500,
                      ),
                      selected: isSelected,
                      selectedColor: AppColors.userPrimaryColor,
                      backgroundColor: Colors.white,
                      showCheckmark: false,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40), side: BorderSide.none),
                      onSelected: (_) {
                        setState(() => selectedFilterIndex = index);
                        _fetchNearbyVenues();
                      },
                    );
                  },
                ),
              ),
            ),

            /// Side controls
            Positioned(
              top: MediaQuery.of(context).size.height * 0.12,
              right: 10,
              child: Column(
                children: [
                  _buildSideButton(Icons.filter_list_sharp, () {
                    final selectedFilter = filters[selectedFilterIndex]["title"];
                    if (["Restaurant", "Wellness", "Leisure"].contains(selectedFilter)) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          switch (selectedFilter) {
                            case "Restaurant": return const RestaurantBottomSheet();
                            case "Wellness": return const WellnessBottomSheet();
                            case "Leisure": return const LeisureBottomSheet();
                            default: return const SizedBox.shrink();
                          }
                        },
                      );
                    }
                  }),
                  const SizedBox(height: 16),
                  _buildSideButton(Icons.my_location, () {
                    _mapController?.animateCamera(CameraUpdate.newLatLng(_initialPosition.target));
                  }),
                ],
              ),
            ),

            /// Bottom horizontal list of venues
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 220,
                child: _nearbyVenues.isEmpty 
                  ? const SizedBox.shrink()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: _nearbyVenues.length,
                      itemBuilder: (context, index) {
                        final v = _nearbyVenues[index];
                        return SizedBox(
                          width: 280,
                          child: FavouriteRestaurantCard(
                            imageUrl: v['profilePicture'] ?? "https://images.unsplash.com/photo-1528605248644-14dd04022da1",
                            restaurantName: v['restaurantName'] ?? v['userName'] ?? "Venue",
                            address: v['address'] ?? "No address",
                            isFavourite: false, 
                            margin: const EdgeInsets.only(right: 12),
                            onFavouriteTap: () {},
                            onRestaurantTap: () {},
                          ),
                        );
                      },
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.black87, size: 22),
        ),
      ),
    );
  }
}
