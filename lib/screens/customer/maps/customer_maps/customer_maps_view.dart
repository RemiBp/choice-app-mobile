import 'dart:async';

import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/models/get_nearby_producers_response.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/screens/customer/maps/customer_maps/customer_maps_provider.dart';
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
  Set<Marker> _markers = {};
  Set<Marker> _allMarkers = {}; // Store all markers for filtering
  bool _isBuildingMarkers = false;
  MapType _currentMapType = MapType.normal;
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

  late CustomerMapsProvider customerMapsProvider;

  @override
  void initState() {
    super.initState();
    customerMapsProvider = Provider.of<CustomerMapsProvider>(context, listen: false,);
    customerMapsProvider.context = context;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await customerMapsProvider.getNearbyProducers(latitude: 0, longitude: 0, radius: 0);
      // Build markers after data is fetched
      if (customerMapsProvider.getNearbyProducersOnMapResponse != null) {
        debugPrint('Response received, building markers...');
        await _buildMarkers();
        debugPrint('Marker building completed. Total markers: ${_markers.length}');
      } else {
        debugPrint('Response is null, cannot build markers');
      }
      // await _fetchUserLocation();
    });
  }

  String _getMarkerIconPath(String? type) {
    switch (type?.toLowerCase()) {
      case 'restaurant':
        return Assets.restaurantMarker;
      case 'wellness':
        return Assets.wellnessMarker;
      case 'leisure':
        return Assets.leisureMarker;
      default:
        return Assets.userMarker;
    }
  }


  static final Map<String, BitmapDescriptor> _iconCache = {};

  Future<BitmapDescriptor> _getBitmapDescriptorFromSvg(String assetPath) async {
    // Check cache first
    if (_iconCache.containsKey(assetPath)) {
      return _iconCache[assetPath]!;
    }

    try {
      // For now, use default markers with different colors based on asset path
      // You can implement proper SVG conversion later if needed
      BitmapDescriptor descriptor;
      
      if (assetPath.contains('restaurant')) {
        descriptor = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      } else if (assetPath.contains('wellness')) {
        descriptor = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      } else if (assetPath.contains('leisure')) {
        descriptor = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      } else {
        descriptor = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      }
      
      _iconCache[assetPath] = descriptor;
      return descriptor;
    } catch (e) {
      debugPrint('Error creating bitmap from SVG $assetPath: $e');
      // Fallback to default marker
      final fallback = BitmapDescriptor.defaultMarker;
      _iconCache[assetPath] = fallback;
      return fallback;
    }
  }

  Future<void> _buildMarkers() async {
    if (_isBuildingMarkers) {
      debugPrint('_buildMarkers: Already building markers, skipping');
      return;
    }
    
    _isBuildingMarkers = true;
    
    // final customerMapsProvider = Provider.of<CustomerMapsProvider>(context, listen: false);
    final response = customerMapsProvider.getNearbyProducersOnMapResponse;
    
    if (response == null) {
      debugPrint('_buildMarkers: Response is null');
      _isBuildingMarkers = false;
      return;
    }

    debugPrint('_buildMarkers: Building markers. Producers: ${response.producers?.length ?? 0}, Friends: ${response.friends?.length ?? 0}');

    Set<Marker> newMarkers = {};
    int markerIndex = 0;

    // Add a test marker at the center to verify markers work
    // newMarkers.add(
    //   Marker(
    //     markerId: const MarkerId('test_marker'),
    //     position: const LatLng(38.703900, -9.139900),
    //     icon: BitmapDescriptor.defaultMarker,
    //     infoWindow: const InfoWindow(title: 'Test Marker'),
    //   ),
    // );
    // debugPrint('Added test marker at (38.703900, -9.139900)');

    // Add producers markers
    if (response.producers != null && response.producers!.isNotEmpty) {
      for (var producer in response.producers!) {
        if (producer.latitude != null && producer.longitude != null) {
          try {
            final latStr = producer.latitude?.toString().trim() ?? '';
            final lngStr = producer.longitude?.toString().trim() ?? '';
            final lat = double.tryParse(latStr) ?? 0.0;
            final lng = double.tryParse(lngStr) ?? 0.0;
            
            debugPrint('Producer ${producer.id}: latStr="$latStr", lngStr="$lngStr", parsed lat=$lat, lng=$lng, type=${producer.type}');
            
            if (lat != 0.0 && lng != 0.0 && lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180) {
              final iconPath = _getMarkerIconPath(producer.type);
              final icon = await _getBitmapDescriptorFromSvg(iconPath);
              
              newMarkers.add(
                Marker(
                  markerId: MarkerId('producer_${producer.id}_$markerIndex'),
                  position: LatLng(lat, lng),
                  icon: icon,
                ),
              );
              markerIndex++;
              debugPrint('Added marker for producer ${producer.id} at ($lat, $lng)');
            } else {
              debugPrint('Invalid coordinates for producer ${producer.id}');
            }
          } catch (e) {
            debugPrint('Error creating marker for producer ${producer.id}: $e');
          }
        } else {
          debugPrint('Producer ${producer.id}: latitude or longitude is null');
        }
      }
    } else {
      debugPrint('No producers in response');
    }

    // Add friends markers
    if (response.friends != null && response.friends!.isNotEmpty) {
      for (var friend in response.friends!) {
        if (friend.latitude != null && friend.longitude != null) {
          try {
            final lat = friend.latitude!;
            final lng = friend.longitude!;
            
            debugPrint('Friend ${friend.id}: lat=$lat, lng=$lng');
            
            if (lat != 0.0 && lng != 0.0) {
              final icon = await _getBitmapDescriptorFromSvg(Assets.userMarker);
              
              newMarkers.add(
                Marker(
                  markerId: MarkerId('friend_${friend.id}_$markerIndex'),
                  position: LatLng(lat, lng),
                  icon: icon,
                ),
              );
              markerIndex++;
              debugPrint('Added marker for friend ${friend.id} at ($lat, $lng)');
            }
          } catch (e) {
            debugPrint('Error creating marker for friend ${friend.id}: $e');
          }
        }
      }
    }

    debugPrint('_buildMarkers: Created ${newMarkers.length} markers');

    if (mounted) {
      setState(() {
        _allMarkers = newMarkers; // Store all markers
        _markers = newMarkers; // Initially show all markers
        _isBuildingMarkers = false;
      });
      debugPrint('_buildMarkers: Markers updated in state. Total markers: ${_markers.length}');
      
      // Apply current filter
      _filterMarkers();
      
      // Adjust camera to show all markers if we have any
      if (_markers.isNotEmpty && _mapController != null) {
        _fitMarkersInView();
      }
    } else {
      debugPrint('_buildMarkers: Widget not mounted, cannot update state');
      _isBuildingMarkers = false;
    }
  }

  void _filterMarkers() {
    if (_allMarkers.isEmpty) return;
    
    Set<Marker> filteredMarkers = {};
    
    switch (selectedFilterIndex) {
      case 0: // "All"
        filteredMarkers = _allMarkers;
        break;
      case 1: // "Friends"
        filteredMarkers = _allMarkers.where((marker) {
          return marker.markerId.value.startsWith('friend_');
        }).toSet();
        break;
      case 2: // Restaurant
        filteredMarkers = _allMarkers.where((marker) {
          return marker.markerId.value.startsWith('producer_') &&
                 _isMarkerType(marker, 'restaurant');
        }).toSet();
        break;
      case 3: // Wellness
        filteredMarkers = _allMarkers.where((marker) {
          return marker.markerId.value.startsWith('producer_') &&
                 _isMarkerType(marker, 'wellness');
        }).toSet();
        break;
      case 4: // Leisure
        filteredMarkers = _allMarkers.where((marker) {
          return marker.markerId.value.startsWith('producer_') &&
                 _isMarkerType(marker, 'leisure');
        }).toSet();
        break;
      default:
        filteredMarkers = _allMarkers;
    }
    
    setState(() {
      _markers = filteredMarkers;
    });
    
    // Adjust camera to show filtered markers
    if (_markers.isNotEmpty && _mapController != null) {
      _fitMarkersInView();
    }
  }

  bool _isMarkerType(Marker marker, String type) {
    // Extract producer ID from marker ID (format: 'producer_{id}_{index}')
    final markerId = marker.markerId.value;
    if (!markerId.startsWith('producer_')) return false;
    
    final response = customerMapsProvider.getNearbyProducersOnMapResponse;
    if (response?.producers == null || response!.producers!.isEmpty) return false;
    
    // Extract the producer ID from marker ID
    final parts = markerId.split('_');
    if (parts.length < 2) return false;
    
    final producerId = int.tryParse(parts[1]);
    if (producerId == null) return false;
    
    // Find the producer and check its type
    try {
      final producer = response.producers!.firstWhere(
        (p) => p.id == producerId,
      );
      
      return producer.type?.toLowerCase() == type.toLowerCase();
    } catch (e) {
      return false;
    }
  }

  void _fitMarkersInView() {
    if (_markers.isEmpty || _mapController == null) return;
    
    try {
      final positions = _markers.map((marker) => marker.position).toList();
      
      double minLat = positions.first.latitude;
      double maxLat = positions.first.latitude;
      double minLng = positions.first.longitude;
      double maxLng = positions.first.longitude;
      
      for (var position in positions) {
        minLat = minLat < position.latitude ? minLat : position.latitude;
        maxLat = maxLat > position.latitude ? maxLat : position.latitude;
        minLng = minLng < position.longitude ? minLng : position.longitude;
        maxLng = maxLng > position.longitude ? maxLng : position.longitude;
      }
      
      final bounds = LatLngBounds(
        southwest: LatLng(minLat - 0.01, minLng - 0.01),
        northeast: LatLng(maxLat + 0.01, maxLng + 0.01),
      );
      
      _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
      debugPrint('Camera adjusted to fit ${_markers.length} markers');
    } catch (e) {
      debugPrint('Error fitting markers in view: $e');
      // Fallback: just center on first marker
      if (_markers.isNotEmpty) {
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(_markers.first.position, 15),
        );
      }
    }
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
    // final roleProvider = context.read<RoleProvider>();
    return Scaffold(
      appBar: CommonAppBar(title: al.mapLocation),
      body: SizedBox(
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

                  // ...markers.map((marker) {
                  //   return Positioned(
                  //     left: MediaQuery.of(context).size.width * marker["dx"],
                  //     top: MediaQuery.of(context).size.height * marker["dy"],
                  //     child: GestureDetector(
                  //       onTap: () => _openProfileSheet(context, marker["type"]),
                  //       child: SvgPicture.asset(
                  //         marker["icon"],
                  //         width: getWidth() * 0.11, // ~42px
                  //         height: getHeight() * 0.065, // ~58px
                  //       ),
                  //     ),
                  //   );
                  // }).toList(),

                  // if (showHeatmap)
                  //   AnimatedOpacity(
                  //     opacity: showHeatmap ? 1 : 0,
                  //     duration: const Duration(milliseconds: 400),
                  //     child: Image.asset(
                  //       Assets.heatmapImage, // your heatmap image asset
                  //       fit: BoxFit.cover,
                  //       color: Colors.white.withValues(alpha: 0.7),
                  //       colorBlendMode: BlendMode.modulate,
                  //     ),
                  //   ),
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
                        _filterMarkers();
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
                      if (_currentMapType == MapType.normal) {
                        _currentMapType = MapType.satellite;
                      } else if (_currentMapType == MapType.satellite) {
                        _currentMapType = MapType.terrain;
                      } else if (_currentMapType == MapType.terrain) {
                        _currentMapType = MapType.hybrid;
                      } else {
                        _currentMapType = MapType.normal;
                      }
                    });
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

            // Positioned(
            //   bottom: getHeight() * 0.03,
            //   left: 0,
            //   right: 0,
            //   child: SizedBox(
            //     height: getHeightRatio() * 230,
            //     child: ListView.builder(
            //       padding: EdgeInsets.only(
            //         left: getWidth() * 0.06,
            //         right: getWidth() * 0.03,
            //       ),
            //       scrollDirection: Axis.horizontal,
            //       itemCount: 5,
            //       itemBuilder: (context, index) {
            //         return SizedBox(
            //           width: getWidthRatio() * 280,
            //           child: BookmarkRestaurantCard(
            //             imageUrl:
            //                 "https://images.unsplash.com/photo-1528605248644-14dd04022da1",
            //             address: "123 Main Street, City",
            //             rating: 4.2,
            //             tag: "Wellness",
            //             // ← shows in top-left chip
            //             isBookmarked: true,
            //             margin: EdgeInsets.only(
            //               top: getHeightRatio() * 8,
            //               bottom: getHeightRatio() * 8,
            //               right: getWidth() * 0.03,
            //             ),
            //             onBookmarkTap: () {
            //               // handle bookmark toggle
            //             },
            //             onCardTap: () {
            //               // handle navigation
            //             },
            //           ),
            //         );
            //       },
            //     ),
            //   ),
            // ),

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
        target: LatLng(38.703900, -9.139900),  // Lahore center
        // target: LatLng(31.5204, 74.3587),  // Lahore center
        zoom: 17,                          // closer zoom so heatmap is visible
      ),
      markers: _markers,
      mapType: _currentMapType,
      onMapCreated: (controller) async {
        _mapController = controller;
        // Wait a bit for map to be ready, then check if we need to fit markers
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted && _markers.isNotEmpty) {
          _fitMarkersInView();
        }
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
