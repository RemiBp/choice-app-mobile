class NearbyProducersResponse {
  final int status;
  final String message;
  final NearbyProducersData? data;

  NearbyProducersResponse({required this.status, required this.message, this.data});

  factory NearbyProducersResponse.fromJson(Map<String, dynamic> json) {
    return NearbyProducersResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? NearbyProducersData.fromJson(json['data']) : null,
    );
  }
}

class NearbyProducersData {
  final List<ProducerItem> producers;
  final int totalProducers;
  final int currentPage;
  final int totalPages;

  NearbyProducersData({
    required this.producers,
    required this.totalProducers,
    required this.currentPage,
    required this.totalPages,
  });

  factory NearbyProducersData.fromJson(Map<String, dynamic> json) {
    return NearbyProducersData(
      producers: (json['producers'] as List)
          .map((e) => ProducerItem.fromJson(e))
          .toList(),
      totalProducers: json['totalProducers'],
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
    );
  }
}

class ProducerItem {
  final int id;
  final String name;
  final String type;
  final double latitude;
  final double longitude;
  final String address;
  final String? profileImage;
  final double distance;
  final int etaInMinutes;

  ProducerItem({
    required this.id,
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.profileImage,
    required this.distance,
    required this.etaInMinutes,
  });

  factory ProducerItem.fromJson(Map<String, dynamic> json) {
    return ProducerItem(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
      address: json['address'] ?? '',
      profileImage: json['profileImage'],
      distance: double.tryParse(json['distance'].toString()) ?? 0.0,
      etaInMinutes: json['etaInMinutes'] ?? 0,
    );
  }
}
