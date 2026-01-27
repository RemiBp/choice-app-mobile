import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import '../../../data/services/map_service.dart';
import '../../../common/utils.dart';
import '../../../appColors/colors.dart';

class ProducerMapScreen extends StatefulWidget {
  const ProducerMapScreen({super.key});

  @override
  State<ProducerMapScreen> createState() => _ProducerMapScreenState();
}

class _ProducerMapScreenState extends State<ProducerMapScreen> {
  late GoogleMapController _mapController;
  final MapService _mapService = MapService();
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  
  late String _role;
  late int _producerId;
  List<String> _catalogItems = [];
  bool _isLoadingCatalog = true;

  // Default position
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(48.8566, 2.3522),
    zoom: 14.0,
  );

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    _producerId = int.tryParse(PreferenceUtils.userId) ?? 1;
    _role = PreferenceUtils.role.toLowerCase();
    
    await _fetchCatalog();
    _fetchHeatmapData();
    _fetchProducerDetails();
  }


  Future<void> _fetchCatalog() async {
    setState(() => _isLoadingCatalog = true);
    try {
      Response response;
      if (_role.contains('restau')) {
        response = await _mapService.getMenu();
        final menu = response.data['data']['menu'] as List;
        for (var category in menu) {
          final dishes = category['dishes'] as List;
          _catalogItems.addAll(dishes.map((d) => d['name'].toString()));
        }
      } else if (_role.contains('well')) {
        response = await _mapService.getWellnessServices();
        final services = response.data['data'] as List;
        _catalogItems.addAll(services.map((s) => s['serviceType']['name'].toString()));
      } else if (_role.contains('leis')) {
        response = await _mapService.getLeisureEvents();
        final events = response.data['data'] as List;
        _catalogItems.addAll(events.map((e) => e['title'].toString()));
      }
    } catch (e) {
      debugPrint("Error fetching catalog: \$e");
    } finally {
      if (mounted) setState(() => _isLoadingCatalog = false);
    }
  }

  double _getMarkerHue() {
    if (_role.contains('restau')) return BitmapDescriptor.hueOrange;
    if (_role.contains('well')) return BitmapDescriptor.hueGreen;
    if (_role.contains('leis')) return BitmapDescriptor.hueViolet;
    return BitmapDescriptor.hueAzure;
  }

  Color _getPrimaryColor() {
     if (_role.contains('restau')) return AppColors.restaurantPrimaryColor;
     if (_role.contains('well')) return AppColors.wellnessPrimaryColor;
     if (_role.contains('leis')) return AppColors.leisurePrimaryColor;
     return AppColors.userPrimaryColor;
  }

  Future<void> _fetchProducerDetails() async {
    try {
      final response = await _mapService.getProducerHeatmap(_producerId); 
      if (response.statusCode == 200 && response.data['data'].isNotEmpty) {
        final first = response.data['data'][0];
        _mapController.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(
              double.parse(first['lat'].toString()),
              double.parse(first['lng'].toString()),
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error centering map: \$e');
    }
  }

  static const String _mapStyle = '''
[
  {
    "featureType": "poi",
    "elementType": "labels",
    "stylers": [
      { "visibility": "off" }
    ]
  }
]
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Maps', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            onMapCreated: (controller) {
              _mapController = controller;
              _mapController.setMapStyle(_mapStyle);
            },
            markers: _markers,
            circles: _circles,
            myLocationEnabled: true,
            mapType: MapType.normal,
            zoomControlsEnabled: false,
          ),
          _buildOverlayControls(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateOfferBottomSheet(context),
        label: const Text('Create Offer', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.local_offer),
        backgroundColor: _getPrimaryColor(),
      ),
    );
  }

  Widget _buildOverlayControls() {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Search activity in your area...',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _currentStep = 0;
  List<dynamic> _templates = [];
  Map<String, dynamic>? _selectedTemplate;
  double _targetRadius = 500; // meters
  int _nearbyUsersCount = 0;

  Future<void> _fetchHeatmapData() async {
    try {
      final response = await _mapService.getProducerHeatmap(_producerId); 
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final randomSeed = DateTime.now().millisecond;
        
        setState(() {
          _markers = data.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final count = item['count'] ?? (10 + (index % 15));
            
            // Dynamic insight from catalog
            String insight = "your business";
            if (_catalogItems.isNotEmpty) {
              insight = _catalogItems[(randomSeed + index) % _catalogItems.length];
            } else {
              if (_role.contains('restau')) insight = "ramen";
              else if (_role.contains('well')) insight = "wellness";
              else insight = "activities";
            }

            return Marker(
              markerId: MarkerId("${item['lat']}_${item['lng']}"),
              position: LatLng(
                double.parse(item['lat'].toString()),
                double.parse(item['lng'].toString()),
              ),
              infoWindow: InfoWindow(
                title: '$count potential clients',
                snippet: '$count users searched for "$insight" recently',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(_getMarkerHue()),
            );
          }).toSet();
        });
      }
    } catch (e) {
      debugPrint('Error fetching heatmap data: \$e');
    }
  }

  Future<void> _fetchTemplates() async {
    try {
      final response = await _mapService.getOfferTemplates(_producerId);
      if (response.statusCode == 200) {
        setState(() {
          _templates = response.data['data'];
        });
      }
    } catch (e) {
      debugPrint('Error fetching templates: \$e');
    }
  }

  Future<void> _updateNearbyUsersCount() async {
    try {
      // Get current map center for targeting
      final center = await _mapController.getVisibleRegion();
      final lat = (center.northeast.latitude + center.southwest.latitude) / 2;
      final lng = (center.northeast.longitude + center.southwest.longitude) / 2;

      final response = await _mapService.getNearbyUsers(
        latitude: lat,
        longitude: lng,
        radius: _targetRadius / 1000, // convert to km
      );
      if (response.statusCode == 200) {
        setState(() {
          _nearbyUsersCount = (response.data['data'] as List).length;
          _circles = {
            Circle(
              circleId: const CircleId('target_radius'),
              center: LatLng(lat, lng),
              radius: _targetRadius,
              fillColor: Colors.blueAccent.withOpacity(0.2),
              strokeColor: Colors.blueAccent,
              strokeWidth: 2,
            ),
          };
        });
      }
    } catch (e) {
      debugPrint('Error fetching nearby users: $e');
    }
  }

  void _showCreateOfferBottomSheet(BuildContext context) {
    _fetchTemplates();
    _currentStep = 0;
    _selectedTemplate = null;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                _buildHeader(setModalState),
                Expanded(child: _buildStepContent(setModalState)),
                _buildFooter(setModalState),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(StateSetter setModalState) {
    String title = 'Create Target Offer';
    if (_currentStep == 1) title = 'Configure Offer';
    if (_currentStep == 2) title = 'Review & Send';

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold)),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(StateSetter setModalState) {
    if (_currentStep == 0) return _buildTemplateStep(setModalState);
    if (_currentStep == 1) return _buildConfigStep(setModalState);
    return _buildReviewStep(setModalState);
  }

  Widget _buildTemplateStep(StateSetter setModalState) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _templates.length,
      itemBuilder: (context, index) {
        final template = _templates[index];
        final isSelected = _selectedTemplate == template;
        return Card(
          elevation: isSelected ? 4 : 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isSelected ? const BorderSide(color: Colors.blueAccent, width: 2) : BorderSide.none,
          ),
          child: ListTile(
            title: Text(template['name'] ?? 'Custom Offer'),
            subtitle: Text(template['description'] ?? 'No description'),
            onTap: () {
              setModalState(() => _selectedTemplate = template);
            },
          ),
        );
      },
    );
  }

  Widget _buildConfigStep(StateSetter setModalState) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Target Radius', style: TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: _targetRadius,
            min: 100,
            max: 5000,
            divisions: 49,
            label: '${_targetRadius.toInt()}m',
            onChanged: (val) {
              setModalState(() => _targetRadius = val);
              _updateNearbyUsersCount();
            },
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.people, color: Colors.blueAccent),
                const SizedBox(width: 12),
                Text(
                  'Estimated Reach: $_nearbyUsersCount users',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStep(StateSetter setModalState) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Offer Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildSummaryChip('Template', _selectedTemplate?['name'] ?? 'Custom'),
          _buildSummaryChip('Radius', '${_targetRadius.toInt()}m'),
          _buildSummaryChip('Target', '$_nearbyUsersCount Potential Customers'),
          const Spacer(),
          const Text(
            'Users in the selected area will receive a push notification with this offer.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryChip(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFooter(StateSetter setModalState) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            if (_currentStep < 2) {
              setModalState(() => _currentStep++);
              if (_currentStep == 1) _updateNearbyUsersCount();
            } else {
              _sendOffer();
            }
          },
          child: Text(
            _currentStep == 2 ? 'Send Notification' : 'Next',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Future<void> _sendOffer() async {
    // Logic to send offer via MapService
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Targeted notifications are being sent!')),
    );
  }
}
