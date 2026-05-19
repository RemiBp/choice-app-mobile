import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/providers/customer_provider.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/screens/customer/maps/customer_maps/wellness_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../appAssets/app_assets.dart';
import '../../../../customWidgets/common_app_bar.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../restaurant/profile_menu/profile_menu_widgets.dart';
import 'leisure_bottom_sheet.dart';
import 'restaurant_bottom_sheet.dart';

class CustomerMapsView extends StatefulWidget {
  const CustomerMapsView({super.key});

  @override
  State<CustomerMapsView> createState() => _CustomerMapsViewState();
}

class _CustomerMapsViewState extends State<CustomerMapsView> {
  GoogleMapController? _mapController;
  LatLng _center = const LatLng(48.8566, 2.3522);
  double _lat = 48.8566;
  double _lng = 2.3522;

  final List<Map<String, dynamic>> filters = [
    {"title": "Friends", "icon": Assets.profileIcon, "type": "friends"},
    {"title": "Restaurant", "icon": Assets.knifeForkIcon, "type": "restaurant"},
    {"title": "Wellness", "icon": Assets.wellnessIcon, "type": "wellness"},
    {"title": "Leisure", "icon": Assets.leisureIcon, "type": "leisure"},
  ];

  int selectedFilterIndex = 1;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        LocationPermission perm = await Geolocator.checkPermission();
        if (perm == LocationPermission.denied) {
          perm = await Geolocator.requestPermission();
        }
        if (perm != LocationPermission.deniedForever &&
            perm != LocationPermission.denied) {
          final pos = await Geolocator.getCurrentPosition(
            locationSettings:
                const LocationSettings(accuracy: LocationAccuracy.high),
          );
          _lat = pos.latitude;
          _lng = pos.longitude;
          _center = LatLng(_lat, _lng);
          _mapController?.animateCamera(CameraUpdate.newLatLng(_center));
        }
      }
    } catch (_) {}
    if (mounted) _loadPlaces();
  }

  void _loadPlaces() {
    final type = filters[selectedFilterIndex]["type"] as String;
    context.read<CustomerProvider>().loadNearby(
          latitude: _lat,
          longitude: _lng,
          type: type,
        );
  }

  Set<Marker> _buildMarkers(List<Map<String, dynamic>> places) {
    return places.asMap().entries.map((entry) {
      final i = entry.key;
      final p = entry.value;
      final lat = (p['latitude'] as num?)?.toDouble();
      final lng = (p['longitude'] as num?)?.toDouble();
      if (lat == null || lng == null) return null;
      return Marker(
        markerId: MarkerId('producer_$i'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
          title: p['name'] as String? ?? '',
          snippet: p['address'] as String? ?? '',
        ),
        onTap: () {
          final id = p['id'];
          if (id != null) {
            context.push('/event_details', extra: {
              'tag': filters[selectedFilterIndex]["title"] as String,
              'producerId': id,
            });
          }
        },
      );
    }).whereType<Marker>().toSet();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Map & Location"),
      body: Consumer<CustomerProvider>(
        builder: (context, provider, _) {
          final markers = _buildMarkers(provider.nearbyPlaces);
          return SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: _center, zoom: 13),
                  onMapCreated: (controller) => _mapController = controller,
                  markers: markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                ),

                SafeArea(
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.only(top: 10),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: filters.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(width: getWidth() * 0.02),
                      itemBuilder: (context, index) {
                        final filter = filters[index];
                        final isSelected = index == selectedFilterIndex;
                        return ChoiceChip(
                          avatar: SvgPicture.asset(
                            filter["icon"],
                            width: getWidthRatio() * 18,
                            height: getHeightRatio() * 18,
                            colorFilter: ColorFilter.mode(
                              isSelected
                                  ? AppColors.whiteColor
                                  : AppColors.primarySlateColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          label: CustomText(
                            text: filter["title"],
                            fontSize: sizes?.fontSize12,
                            color: isSelected
                                ? AppColors.whiteColor
                                : AppColors.primarySlateColor,
                            fontWeight: FontWeight.w500,
                          ),
                          selected: isSelected,
                          selectedColor: AppColors.userPrimaryColor,
                          backgroundColor: AppColors.whiteColor,
                          showCheckmark: false,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                            side: BorderSide.none,
                          ),
                          onSelected: (_) {
                            setState(() => selectedFilterIndex = index);
                            _loadPlaces();
                          },
                        );
                      },
                    ),
                  ),
                ),

                Positioned(
                  top: MediaQuery.of(context).size.height * 0.12,
                  right: 10,
                  child: Column(
                    children: [
                      _buildSideButton(Icons.filter_list_sharp, () {
                        final selectedFilter =
                            filters[selectedFilterIndex]["title"] as String;
                        if (selectedFilter == "Restaurant" ||
                            selectedFilter == "Wellness" ||
                            selectedFilter == "Leisure") {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              switch (selectedFilter) {
                                case "Restaurant":
                                  return const RestaurantBottomSheet();
                                case "Wellness":
                                  return const WellnessBottomSheet();
                                case "Leisure":
                                  return const LeisureBottomSheet();
                                default:
                                  return const SizedBox.shrink();
                              }
                            },
                          );
                        }
                      }),
                      const SizedBox(height: 16),
                      _buildSideButton(Icons.my_location, () {
                        _mapController?.animateCamera(
                          CameraUpdate.newLatLngZoom(_center, 13),
                        );
                      }),
                      const SizedBox(height: 16),
                      _buildSideButton(Icons.add, () {
                        _mapController?.animateCamera(CameraUpdate.zoomIn());
                      }),
                      const SizedBox(height: 8),
                      _buildSideButton(Icons.remove, () {
                        _mapController?.animateCamera(CameraUpdate.zoomOut());
                      }),
                    ],
                  ),
                ),

                if (provider.isLoadingNearby)
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(),
                  ),

                Positioned(
                  bottom: getHeight() * 0.03,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: getHeightRatio() * 230,
                    child: ListView.builder(
                      padding: EdgeInsets.only(
                          left: getWidth() * 0.06, right: getWidth() * 0.03),
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.nearbyPlaces.isNotEmpty
                          ? provider.nearbyPlaces.length
                          : 3,
                      itemBuilder: (context, index) {
                        final place = provider.nearbyPlaces.isNotEmpty
                            ? provider.nearbyPlaces[index]
                            : null;
                        final name =
                            place?['name'] as String? ?? 'Nearby ${index + 1}';
                        final address = place?['address'] as String? ?? '—';
                        final imageUrl = place?['profileImage'] as String? ??
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
                            onRestaurantTap: place != null
                                ? () => context.push('/event_details', extra: {
                                      'tag': filters[selectedFilterIndex]
                                          ["title"] as String,
                                      'producerId': place['id'],
                                    })
                                : () {},
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
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
