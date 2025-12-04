class GetNearbyProducersOnMapResponse {
  List<Producer>? producers;
  List<Friend>? friends;

  GetNearbyProducersOnMapResponse({this.producers, this.friends});

  GetNearbyProducersOnMapResponse.fromJson(Map<String, dynamic> rawJson) {
    final json = rawJson['data'] as Map<String, dynamic>;
    if (json['producers'] != null) {
      producers = <Producer>[];
      json['producers'].forEach((v) {
        producers!.add(Producer.fromJson(v));
      });
    }
    if (json['friends'] != null) {
      friends = <Friend>[];
      json['friends'].forEach((v) {
        friends!.add(Friend.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (producers != null) {
      data['producers'] = producers!.map((v) => v.toJson()).toList();
    }
    if (friends != null) {
      data['friends'] = friends!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Producer {
  int? id;
  String? name;
  String? type;
  String? latitude;
  String? longitude;
  String? address;
  double? distanceKm;

  Producer({
    this.id,
    this.name,
    this.type,
    this.latitude,
    this.longitude,
    this.address,
    this.distanceKm,
  });

  Producer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    distanceKm = json['distance_km'] != null
        ? (json['distance_km'] is num
            ? json['distance_km'].toDouble()
            : double.tryParse(json['distance_km'].toString()))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['address'] = address;
    data['distance_km'] = distanceKm;
    return data;
  }
}

class Friend {
  int? id;
  String? fullName;
  String? userName;
  String? profileImageUrl;
  double? latitude;
  double? longitude;
  double? distanceKm;

  Friend({
    this.id,
    this.fullName,
    this.userName,
    this.profileImageUrl,
    this.latitude,
    this.longitude,
    this.distanceKm,
  });

  Friend.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    userName = json['userName'];
    profileImageUrl = json['profileImageUrl'];
    latitude = json['latitude'] != null
        ? (json['latitude'] is num
            ? json['latitude'].toDouble()
            : double.tryParse(json['latitude'].toString()))
        : null;
    longitude = json['longitude'] != null
        ? (json['longitude'] is num
            ? json['longitude'].toDouble()
            : double.tryParse(json['longitude'].toString()))
        : null;
    distanceKm = json['distance_km'] != null
        ? (json['distance_km'] is num
            ? json['distance_km'].toDouble()
            : double.tryParse(json['distance_km'].toString()))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fullName'] = fullName;
    data['userName'] = userName;
    data['profileImageUrl'] = profileImageUrl;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['distance_km'] = distanceKm;
    return data;
  }
}