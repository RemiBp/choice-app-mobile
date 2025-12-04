import 'dart:async';

import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/screens/leisure/leisure_profile_tab_bar/leisure_profile_tab_bar.dart';
import 'package:choice_app/screens/wellness/wellness_profile_tab_bar/wellness_Profile_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../appAssets/app_assets.dart';
import '../../../../customWidgets/common_app_bar.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../l18n.dart';
import '../../../../res/toasts.dart';
import '../../../../userRole/role_provider.dart';
import '../../../../userRole/user_role.dart';
import '../../../restaurant/profile_menu/profile_menu_widgets.dart';
import '../../profile/customer_profile_tab_bar/customer_profile_tab_bar.dart';
import 'filters_bottom_sheet.dart';

class CustomerMapsView extends StatefulWidget {
  const CustomerMapsView({super.key});

  @override
  State<CustomerMapsView> createState() => _CustomerMapsViewState();
}

class _CustomerMapsViewState extends State<CustomerMapsView> {
  GoogleMapController? _mapController;
  double _currentZoom = 17;
  Map<String, dynamic>? _selectedPoint;
  LatLng? _userLocation;
  bool showHeatmap = false;
  final List<Map<String, dynamic>> filters = [
    {"title": "All", "icon": Assets.leisureIcon},
    {"title": "Friends", "icon": Assets.profileIcon},
    {"title": al.categoryRestaurant, "icon": Assets.knifeForkIcon},
    {"title": al.categoryWellness, "icon": Assets.wellnessIcon},
    {"title": al.categoryLeisure, "icon": Assets.leisureIcon},
  ];

  int selectedFilterIndex = 0;

  final List<Map<String, dynamic>> markers = [
    {"icon": Assets.userMarker, "dx": 0.35, "dy": 0.3, "type": UserRole.user},
    {
      "icon": Assets.restaurantMarker,
      "dx": 0.55,
      "dy": 0.25,
      "type": UserRole.restaurant,
    },
    {
      "icon": Assets.wellnessMarker,
      "dx": 0.7,
      "dy": 0.2,
      "type": UserRole.wellness,
    },
    {
      "icon": Assets.leisureMarker,
      "dx": 0.65,
      "dy": 0.4,
      "type": UserRole.leisure,
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchUserLocation();
    });
  }

  Future<void> _fetchUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Toasts.getErrorToast(text: "Location services are disabled. Please enable them to use the map.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Toasts.getErrorToast(text: "Location permission is denied. Please grant permission to use the map.");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Toasts.getErrorToast(text: "Location permission is permanently denied. Please enable it in settings.");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        setState(() {
          _userLocation = LatLng(position.latitude, position.longitude);
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleProvider = context.read<RoleProvider>();
    return Scaffold(
      appBar: CommonAppBar(title: al.mapLocation),
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Stack(
          children: [
            // Map image placeholder + optional heatmap overlay
            Positioned.fill(
              child: Stack(
                fit: StackFit.expand, //  ensures full area fill
                children: [
                  // Base map
                  _buildGoogleMap(),

                  ...markers.map((marker) {
                    return Positioned(
                      left: MediaQuery.of(context).size.width * marker["dx"],
                      top: MediaQuery.of(context).size.height * marker["dy"],
                      child: GestureDetector(
                        onTap: () => _openProfileSheet(context, marker["type"]),
                        child: SvgPicture.asset(
                          marker["icon"],
                          width: getWidth() * 0.11, // ~42px
                          height: getHeight() * 0.065, // ~58px
                        ),
                      ),
                    );
                  }).toList(),

                  if (showHeatmap)
                    AnimatedOpacity(
                      opacity: showHeatmap ? 1 : 0,
                      duration: const Duration(milliseconds: 400),
                      child: Image.asset(
                        Assets.heatmapImage, // your heatmap image asset
                        fit: BoxFit.cover,
                        color: Colors.white.withValues(alpha: 0.7),
                        colorBlendMode: BlendMode.modulate,
                      ),
                    ),
                ],
              ),
            ),

            // Top filter chips (horizontal)
            SafeArea(
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(top: 10),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: filters.length,
                  separatorBuilder:
                      (_, __) => SizedBox(width: getWidth() * 0.02),
                  itemBuilder: (context, index) {
                    final filter = filters[index];
                    return ChoiceChip(
                      avatar: SvgPicture.asset(
                        filter["icon"],
                        width: getWidthRatio() * 18,
                        height: getHeightRatio() * 18,
                        colorFilter: ColorFilter.mode(
                          index == selectedFilterIndex
                              ? AppColors.whiteColor
                              : AppColors.primarySlateColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      label: CustomText(
                        text: filter["title"],
                        fontSize: sizes?.fontSize12,
                        color:
                            index == selectedFilterIndex
                                ? AppColors.whiteColor
                                : AppColors.primarySlateColor,
                        fontWeight: FontWeight.w500,
                      ),
                      selected: index == selectedFilterIndex,
                      selectedColor: AppColors.userPrimaryColor,
                      backgroundColor: AppColors.whiteColor,
                      showCheckmark: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                        side: BorderSide.none,
                      ),
                      onSelected: (_) {
                        setState(() {
                          selectedFilterIndex = index;
                        });
                      },
                    );
                  },
                ),
              ),
            ),

            //Side control buttons (rectangular with rounded corners)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.12,
              right: 10,
              child: Column(
                children: [
                  _buildSideButton(Icons.filter_list_sharp, () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      // allows 90% height (since you used 0.9 of screen height)
                      backgroundColor: Colors.transparent,
                      // keeps your rounded corners visible
                      builder: (context) => const FiltersBottomSheet(),
                    );
                  }),

                  const SizedBox(height: 16),
                  _buildSideButton(Icons.public, () {
                    setState(() {
                      showHeatmap = !showHeatmap; // toggle heat map overlay
                    });
                  }),
                  const SizedBox(height: 16),
                  _buildSideButton(Icons.add, () {}),
                  const SizedBox(height: 8),
                  _buildSideButton(Icons.remove, () {
                    // zoom out
                  }),
                ],
              ),
            ),

            Positioned(
              bottom: getHeight() * 0.03,
              left: 0,
              right: 0,
              child: SizedBox(
                height: getHeightRatio() * 230,
                child: ListView.builder(
                  padding: EdgeInsets.only(
                    left: getWidth() * 0.06,
                    right: getWidth() * 0.03,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: getWidthRatio() * 280,
                      child: BookmarkRestaurantCard(
                        imageUrl:
                            "https://images.unsplash.com/photo-1528605248644-14dd04022da1",
                        address: "123 Main Street, City",
                        rating: 4.2,
                        tag: "Wellness",
                        // ← shows in top-left chip
                        isBookmarked: true,
                        margin: EdgeInsets.only(
                          top: getHeightRatio() * 8,
                          bottom: getHeightRatio() * 8,
                          right: getWidth() * 0.03,
                        ),
                        onBookmarkTap: () {
                          // handle bookmark toggle
                        },
                        onCardTap: () {
                          // handle navigation
                        },
                      ),
                    );
                  },
                ),
              ),
            ),

            /// Floating filter button (bottom right)
            // Positioned(
            //   bottom: 30,
            //   right: 20,
            //   child: FloatingActionButton(
            //     onPressed: () {
            //       // TODO: open FiltersBottomSheet
            //     },
            //     backgroundColor: Colors.white,
            //     child: const Icon(Icons.filter_alt, color: Colors.black87),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleMap() {
    Timer? _zoomDebounce;
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(31.5204, 74.3587),  // Lahore center
        zoom: 17,                          // closer zoom so heatmap is visible
      ),
      onMapCreated: (controller) {
        _mapController = controller;
        // Trigger initial render after a short delay
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) setState(() {});
        });
      },
      onCameraMove: (position) {
        _currentZoom = position.zoom;
        // Hide tooltip when map moves
        _zoomDebounce?.cancel();
        _zoomDebounce = Timer(const Duration(milliseconds: 50), () {
          if (mounted) setState(() {});
        });

        if (_selectedPoint != null) {
          _hideTooltip();
        }
      },
      onCameraIdle: () {
        setState(() {});     // map finished moving
      },
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      onTap: (latLng) {
        // Hide tooltip when tapping on map
        if (_selectedPoint != null) {
          _hideTooltip();
        }
      },
    );
  }

  void _hideTooltip() {
    setState(() {
      _selectedPoint = null;
    });
  }

  // Rectangular side buttons (like in screenshot)
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

void _openProfileSheet(BuildContext context, UserRole type) {
  // decide which widget to show
  late final Widget profileView;
  if (type == UserRole.user) {
    profileView = CustomerProfileTabBar();
  } else if (type == UserRole.restaurant || type == UserRole.leisure) {
    profileView = LeisureProfileTabBar(); // or your restaurant tab bar
  } else {
    profileView = WellnessProfileTabBar();
  }

  // show the draggable modal
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.black.withValues(alpha: 0.8),
    // dims the background
    barrierColor: Colors.black.withValues(alpha: 0.8),
    // dim effect
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // drag handle
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // profile content
                Expanded(child: profileView),
              ],
            ),
          );
        },
      );
    },
  );
}
