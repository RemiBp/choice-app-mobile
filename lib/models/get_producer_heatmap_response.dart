class GetProducerHeatmapResponse {
  final double lat;
  final double lng;
  final int count;
  final List<HeatmapUser> users;

  GetProducerHeatmapResponse({
    required this.lat,
    required this.lng,
    required this.count,
    required this.users,
  });

  factory GetProducerHeatmapResponse.fromJson(Map<String, dynamic> json) {
    return GetProducerHeatmapResponse(
      lat: double.parse(json['lat']),
      lng: double.parse(json['lng']),
      count: int.parse(json['count']),
      users: (json['users'] as List<dynamic>)
          .map((e) => HeatmapUser.fromJson(e))
          .toList(),
    );
  }
}

class HeatmapUser {
  final int id;
  final String email;
  final String username;

  HeatmapUser({
    required this.id,
    required this.email,
    required this.username,
  });

  factory HeatmapUser.fromJson(Map<String, dynamic> json) {
    return HeatmapUser(
      id: json['id'],
      email: json['email'],
      username: json['username'],
    );
  }
}
