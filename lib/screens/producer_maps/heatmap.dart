import 'package:choice_app/screens/producer_maps/producer_heatmap_provider.dart';
import 'package:choice_app/screens/restaurant/profile/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../appColors/colors.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../res/res.dart';
import '../../l18n.dart';
import 'heatmap_widgets.dart';
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

  @override
  Widget build(BuildContext context) {
    final heatmapProvider = ProducerHeatmapProvider.of(context);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          const Divider(color: Color(0xFFE0E0E0), thickness: 1, height: 1),
          Expanded(
            child: Stack(
              children: [
                // GOOGLE MAP WITH HEATMAP
                Positioned.fill(
                  child: _buildGoogleMap(heatmapProvider),
                ),
                _buildZoomButtons(),
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
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(25.1264, 62.3225),  // Gwadar center
            zoom: 17,                          // closer zoom so heatmap is visible
          ),
          onMapCreated: (controller) => _mapController = controller,
          onCameraMove: (position) {
            _currentZoom = position.zoom;
          },

          onCameraIdle: () {
            setState(() {});     // map finished moving
          },
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
        ),

        // HEATMAP OVERLAY
        if (_mapController != null && provider.heatmapCoordinates.isNotEmpty)
          Positioned.fill(
            child: HeatmapOverlay(
              key: ValueKey(_currentZoom), // Rebuild on zoom change
              controller: _mapController!,
              zoom: _currentZoom,
              points: provider.heatmapCoordinates,
            ),
          ),
      ],
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
      onPressed: () {
        showModalBottomSheet(
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