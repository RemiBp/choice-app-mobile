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

  Map<String, dynamic>? _selectedPoint;
  Offset? _selectedPointPosition;

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
    });
  }
  void _showTooltip(Map<String, dynamic> data, Offset position) {
    setState(() {
      _selectedPoint = data;
      _selectedPointPosition = position;
    });
  }

  void _hideTooltip() {
    setState(() {
      _selectedPoint = null;
      _selectedPointPosition = null;
    });
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
                // GOOGLE MAP
                Positioned.fill(
                  child: _buildGoogleMap(heatmapProvider),
                ),

                // HEATMAP OVERLAY - allows taps to pass through to map
                if (_mapController != null && heatmapProvider.heatmapCoordinates.isNotEmpty)
                  Positioned.fill(
                    child: HeatmapOverlay(
                      // CRITICAL: Use unique key that changes with zoom
                      key: ValueKey('heatmap_$_currentZoom'),
                      controller: _mapController!,
                      zoom: _currentZoom,
                      points: heatmapProvider.heatmapCoordinates,
                      onPointTapped: (data, position) {
                        _showTooltip(data, position);
                      },
                    ),
                  ),

                // ZOOM BUTTONS
                _buildZoomButtons(),

                // TOOLTIP - positioned directly, not as a full-screen overlay
                if (_selectedPoint != null && _selectedPointPosition != null)
                  Positioned(
                    left: (_selectedPointPosition!.dx - 80).clamp(10.0, MediaQuery.of(context).size.width - 170),
                    top: (_selectedPointPosition!.dy - 60).clamp(10.0, MediaQuery.of(context).size.height - 100),
                    child: GestureDetector(
                      onTap: () {}, // Absorb taps on tooltip itself
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
  // ZOOM BUTTONS
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