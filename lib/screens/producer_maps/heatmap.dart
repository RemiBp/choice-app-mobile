import 'dart:async';
import 'package:choice_app/screens/producer_maps/producer_heatmap_provider.dart';
import 'package:choice_app/screens/restaurant/profile/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../appColors/colors.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../res/res.dart';
import '../../l18n.dart';
import '../../res/toasts.dart';
import 'heatmap_widgets.dart';
import 'offer_provider.dart';
import 'offer_widgets.dart';

class HeatmapScreen extends StatefulWidget {
  const HeatmapScreen({super.key});

  @override
  State<HeatmapScreen> createState() => _HeatmapScreenState();
}

class _HeatmapScreenState extends State<HeatmapScreen> {
  String selectedTime = al.allDay;
  String selectedFrequency = al.everyday;
  double _currentZoom = 11;

  GoogleMapController? _mapController;
  final GlobalKey _mapKey = GlobalKey();

  Map<String, dynamic>? _selectedPoint;
  Offset? _selectedPointPosition;
  LatLng? _selectedLatLng;


  Set<Marker> _markers = {};
  int _heatmapKey = 0;
  Set<Circle> _heatmapCircles = {};


  final List<String> timeFilters = [
    al.allDay,
    al.morning,
    al.afternoon,
    al.evening,
    al.night,
  ];

  final List<String> frequencyFilters = [
    al.everyday,
    al.monday,
    al.tuesday,
    al.wednesday,
    al.thursday,
    al.friday,
    al.saturday,
    al.sunday,
  ];

  @override
  void initState() {
    super.initState();

    // fetch heatmap from API as soon as the screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Get both providers
      final heatmapProvider = ProducerHeatmapProvider.of(context, listen: false);
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

      // Set context for BOTH providers
      heatmapProvider.context = context;
      profileProvider.context = context;

      await heatmapProvider.fetchProducerHeatmapFromProfile();
      _createHeatmapCircles();
    });
  }


  void _createHeatmapCircles() {
    final heatmapProvider = ProducerHeatmapProvider.of(context, listen: false);
    final points = heatmapProvider.heatmapCoordinates;

    if (points.isEmpty) return;

    // Find max intensity for normalization
    final maxIntensity = points
        .map((e) => (e["count"] ?? 1).toDouble())
        .reduce((a, b) => a > b ? a : b);

    setState(() {
      _heatmapCircles = points.asMap().entries.expand((entry) {
        final index = entry.key;
        final point = entry.value;
        final count = point["count"] ?? 1;
        final intensity = count.toDouble();
        final normalizedIntensity = (intensity / maxIntensity).clamp(0.0, 1.0);

        // Base radius that doesn't change with zoom - smaller size
        final baseRadius = 30.0 + (normalizedIntensity * 40.0); // 30-70 meters instead of 50-200

        // Create multiple circles for gradient effect (like the image)
        List<Circle> gradientCircles = [];

        // Layer 1 - Innermost (Red/Orange) - Most opaque
        gradientCircles.add(Circle(
          circleId: CircleId('heatmap_${index}_inner'),
          center: LatLng(point["lat"], point["lng"]),
          radius: baseRadius * 0.3,
          fillColor: _getInnerColor(normalizedIntensity).withValues(alpha:0.8),
          strokeWidth: 0,
          consumeTapEvents: true,
          onTap: () => _showTooltipForPoint(point),
        ));

        // Layer 2 - Middle-Inner (Orange/Yellow)
        gradientCircles.add(Circle(
          circleId: CircleId('heatmap_${index}_mid1'),
          center: LatLng(point["lat"], point["lng"]),
          radius: baseRadius * 0.5,
          fillColor: _getMidColor1(normalizedIntensity).withValues(alpha:0.6),
          strokeWidth: 0,
          consumeTapEvents: true,
          onTap: () => _showTooltipForPoint(point),
        ));

        // Layer 3 - Middle (Yellow/Green)
        gradientCircles.add(Circle(
          circleId: CircleId('heatmap_${index}_mid2'),
          center: LatLng(point["lat"], point["lng"]),
          radius: baseRadius * 0.7,
          fillColor: _getMidColor2(normalizedIntensity).withValues(alpha:0.4),
          strokeWidth: 0,
          consumeTapEvents: true,
          onTap: () => _showTooltipForPoint(point),
        ));

        // Layer 4 - Outer (Green/Blue)
        gradientCircles.add(Circle(
          circleId: CircleId('heatmap_${index}_outer1'),
          center: LatLng(point["lat"], point["lng"]),
          radius: baseRadius * 0.85,
          fillColor: _getOuterColor1(normalizedIntensity).withValues(alpha:0.25),
          strokeWidth: 0,
          consumeTapEvents: true,
          onTap: () => _showTooltipForPoint(point),
        ));

        // Layer 5 - Outermost (Blue - fades out)
        gradientCircles.add(Circle(
          circleId: CircleId('heatmap_${index}_outer2'),
          center: LatLng(point["lat"], point["lng"]),
          radius: baseRadius,
          fillColor: const Color(0xFF2196F3).withValues(alpha:0.15),
          strokeWidth: 0,
          consumeTapEvents: true,
          onTap: () => _showTooltipForPoint(point),
        ));

        return gradientCircles;
      }).toSet();

      // Create visible markers in the center
      _markers = points.asMap().entries.map((entry) {
        final index = entry.key;
        final point = entry.value;

        return Marker(
          markerId: MarkerId('marker_$index'),
          position: LatLng(point["lat"], point["lng"]),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          onTap: () {
            print('Marker tapped: ${point["count"]} users');
            _showTooltipForPoint(point);
          },
        );
      }).toSet();
    });
  }
  Color _getInnerColor(double normalizedIntensity) {
    // Red to Orange based on intensity
    if (normalizedIntensity > 0.7) return Colors.red; // High intensity
    if (normalizedIntensity > 0.5) return const Color(0xFFFF5722); // Orange-Red
    if (normalizedIntensity > 0.3) return const Color(0xFFFF9800); // Orange
    return const Color(0xFFFFEB3B); // Yellow for low intensity
  }

  Color _getMidColor1(double normalizedIntensity) {
    // Orange to Yellow
    if (normalizedIntensity > 0.7) return const Color(0xFFFF5722); // Orange
    if (normalizedIntensity > 0.5) return const Color(0xFFFF9800); // Orange
    if (normalizedIntensity > 0.3) return const Color(0xFFFFEB3B); // Yellow
    return const Color(0xFF8BC34A); // Light Green
  }

  Color _getMidColor2(double normalizedIntensity) {
    // Yellow to Green
    if (normalizedIntensity > 0.7) return const Color(0xFFFF9800); // Orange
    if (normalizedIntensity > 0.5) return const Color(0xFFFFEB3B); // Yellow
    if (normalizedIntensity > 0.3) return const Color(0xFF8BC34A); // Light Green
    return const Color(0xFF4CAF50); // Green
  }

  Color _getOuterColor1(double normalizedIntensity) {
    // Green to Blue
    if (normalizedIntensity > 0.7) return const Color(0xFFFFEB3B); // Yellow
    if (normalizedIntensity > 0.5) return const Color(0xFF8BC34A); // Light Green
    if (normalizedIntensity > 0.3) return const Color(0xFF4CAF50); // Green
    return const Color(0xFF03A9F4); // Light Blue
  }


  void _showTooltipForPoint(Map<String, dynamic> point) async {
    final latLng = LatLng(point["lat"], point["lng"]);

    // Convert LatLng to screen position first
    if (_mapController != null) {
      try {
        final screenCoordinate = await _mapController!.getScreenCoordinate(latLng);

        if (mounted) {
          setState(() {
            _selectedPoint = point;
            _selectedLatLng = latLng;
            _selectedPointPosition = Offset(
              screenCoordinate.x.toDouble(),
              screenCoordinate.y.toDouble(),
            );
          });

          // Auto-hide after 5 seconds
          Future.delayed(const Duration(seconds: 5), () {
            if (mounted && _selectedPoint == point) {
              _hideTooltip();
            }
          });
        }
      } catch (e) {
        print('Error getting screen coordinate: $e');
      }
    }
  }

  // void _createMarkers() {
  //   final heatmapProvider = ProducerHeatmapProvider.of(context, listen: false);
  //   final points = heatmapProvider.heatmapCoordinates;
  //
  //   setState(() {
  //     _markers = points.asMap().entries.map((entry) {
  //       final index = entry.key;
  //       final point = entry.value;
  //       final count = point["count"] ?? 0;
  //
  //       return Marker(
  //         markerId: MarkerId('point_$index'),
  //         position: LatLng(point["lat"], point["lng"]),
  //         icon: BitmapDescriptor.defaultMarkerWithHue(_getMarkerHue(count)),
  //         infoWindow: InfoWindow(
  //           title: '$count user${count == 1 ? '' : 's'}',
  //           snippet: 'Lat: ${point["lat"]}, Lng: ${point["lng"]}',
  //         ),
  //       );
  //     }).toSet();
  //   });
  // }
  //
  // double _getMarkerHue(int count) {
  //   // Green (120) -> Yellow (60) -> Red (0)
  //   if (count <= 5) return 120.0;  // Green
  //   if (count <= 10) return 90.0;  // Yellow-Green
  //   if (count <= 15) return 60.0;  // Yellow
  //   if (count <= 20) return 30.0;  // Orange
  //   return 0.0;                     // Red
  // }

  // void _showTooltip(Map<String, dynamic> data, Offset position) {
  //   setState(() {
  //     _selectedPoint = data;
  //     _selectedPointPosition = position;
  //   });
  // }

  void _hideTooltip() {
    setState(() {
      _selectedPoint = null;
      _selectedPointPosition = null;
      _selectedLatLng = null;
    });
  }
  void _updateTooltipPosition() async {
    if (_selectedLatLng != null && _mapController != null) {
      final RenderBox? mapBox = _mapKey.currentContext?.findRenderObject() as RenderBox?;
      final screenCoordinate = await _mapController!.getScreenCoordinate(_selectedLatLng!);

      double topOffset = 0;
      if (mapBox != null) {
        final mapPosition = mapBox.localToGlobal(Offset.zero);
        topOffset = mapPosition.dy;
      }

      if (mounted) {
        setState(() {
          _selectedPointPosition = Offset(
            screenCoordinate.x.toDouble(),
            screenCoordinate.y.toDouble() + topOffset,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final heatmapProvider = ProducerHeatmapProvider.of(context);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          const Divider(color: AppColors.greyBordersColor, thickness: 1, height: 1),
          Expanded(
            child: Stack(
              children: [

                _buildGoogleMap(heatmapProvider),

                // ZOOM BUTTONS
                _buildZoomButtons(),

                // TOOLTIP
                if (_selectedPoint != null && _selectedPointPosition != null)
                  Positioned(
                    left: (_selectedPointPosition!.dx - 75).clamp(10.0, MediaQuery.of(context).size.width - 160),
                    top: (_selectedPointPosition!.dy - 100).clamp(10.0, MediaQuery.of(context).size.height - 200),
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
                      child: HeatmapTooltip(
                        position: _selectedPointPosition!,
                        userCount: _selectedPoint!["count"] ?? 0,
                        onDismiss: _hideTooltip,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildOfferButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // APP BAR
  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(getHeight() * 0.15),
      child: SafeArea(
        child: Container(
          color: AppColors.whiteColor,
          padding: EdgeInsets.symmetric(
            horizontal: getWidth() * 0.05,
            vertical: getHeight() * 0.015,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new, size: 20),
                  ),
                  SizedBox(width: getWidth() * 0.03),
                  CustomText(
                    text: al.heatmap,
                    fontSize: getWidth() * 0.05,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                ],
              ),
              SizedBox(height: getHeight() * 0.025),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      value: selectedTime,
                      items: timeFilters,
                      onChanged: (v) => setState(() => selectedTime = v!),
                    ),
                  ),
                  SizedBox(width: getWidth() * 0.03),
                  Expanded(
                    child: _buildDropdown(
                      value: selectedFrequency,
                      items: frequencyFilters,
                      onChanged: (v) => setState(() => selectedFrequency = v!),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

// GOOGLE MAP + HEATMAP
  Widget _buildGoogleMap(ProducerHeatmapProvider provider) {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(31.5204, 74.3587),
        zoom: 14,
      ),
      markers: _markers,
      circles: _heatmapCircles, // ADD CIRCLES
      onMapCreated: (controller) {
        _mapController = controller;
      },
      onCameraMove: (position) {
        _currentZoom = position.zoom;
        if (_selectedLatLng != null && _mapController != null) {
          _updateTooltipPosition();
        }
      },
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      onTap: (latLng) {
        if (_selectedPoint != null) {
          _hideTooltip();
        }
      },
    );
  }  // ZOOM BUTTONS
  Widget _buildZoomButtons() {
    return Positioned(
      top: getHeight() * 0.03,
      right: getWidth() * 0.04,
      child: Column(
        children: [
          _buildSideButton(Icons.add, () {
            _mapController?.animateCamera(CameraUpdate.zoomIn());
          }),
          SizedBox(height: getHeight() * 0.01),
          _buildSideButton(Icons.remove, () {
            _mapController?.animateCamera(CameraUpdate.zoomOut());
          }),
        ],
      ),
    );
  }

  Widget _buildSideButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.black87, size: 22), // Fixed: use 'icon' parameter
        ),
      ),
    );
  }

  // OFFER BUTTON
  Widget _buildOfferButton(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: AppColors.getPrimaryColorFromContext(context),
      elevation: 4,
      icon: const Icon(Icons.add, color: Colors.white),
      label: CustomText(
        text: al.createOffer,
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: getWidth() * 0.035,
      ),
      onPressed: () async{
        final profileProvider = context.read<ProfileProvider>();
        final profile = await profileProvider.getProducerProfile();
        final producerId = profile?.producer?.id;

        if (producerId == null) {
          Toasts.getErrorToast(text: "Unable to fetch producer ID");
          return;
        }

        final templateProvider = context.read<TemplateProvider>();
        templateProvider.clearTemplates();
        await templateProvider.getProducerOfferTemplates(context: context, producerId: producerId);

        final selected = await showModalBottomSheet<Template>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const OfferTemplateBottomSheet(),
        );

      },
    );
  }

  // DROPDOWN
  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: getHeight() * 0.045,
      padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.03),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.greyBordersColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          items: items
              .map(
                (e) => DropdownMenuItem<String>(
              value: e,
              child: CustomText(
                text: e,
                fontSize: getWidth() * 0.03,
                color: AppColors.blackColor,
              ),
            ),
          )
              .toList(),
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}