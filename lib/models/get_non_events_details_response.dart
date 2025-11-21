class NonEventDetailsResponse {
  final Producer? producer;
  final Wellness? wellness;
  final Stats? stats;
  Socials? socials;

  NonEventDetailsResponse({
    required this.producer,
    required this.wellness,
    required this.stats,
    this.socials,
  });

  factory NonEventDetailsResponse.fromJson(Map<String, dynamic> json) {
    return NonEventDetailsResponse(
      producer: json["data"]["producer"] != null
          ? Producer.fromJson(json["data"]["producer"])
          : null,
      wellness: json["data"]["wellness"] != null
          ? Wellness.fromJson(json["data"]["wellness"])
          : null,
      stats: json["data"]["stats"] != null
          ? Stats.fromJson(json["data"]["stats"])
          : null,
      socials: json["data"]["socials"] != null
          ? Socials.fromJson(json["data"]["socials"])
          : null,
    );
  }
}


class Producer {
  final int? id;
  final int? userId;
  String? phoneNumber;
  final String? name;
  final String? address;
  final String? type; // restaurant | wellness
  String? website;
  String? instagram;
  String? twitter;
  String? facebook;
  String? details;

  final List<BusinessHour>? businessHours;
  final List<Photo>? photos;
  final List<MenuCategory>? menuCategory;

  Producer({
    this.id,
    this.userId,
    this.name,
    this.address,
    this.type,
    this.website,
    this.twitter,
    this.instagram,
    this.facebook,
    this.details,
    this.businessHours,
    this.photos,
    this.menuCategory,
    this.phoneNumber
  });

  factory Producer.fromJson(Map<String, dynamic> json) {
    return Producer(
      id: json["id"],
      userId: json["userId"],
      name: json["name"],
      address: json["address"],
      type: json["type"],
      website: json["website"],
      twitter: json["twitter"],
      facebook: json["facebook"],
      instagram: json["instagram"],
      details: json["details"],
      phoneNumber: json['phoneNumber'],

        businessHours: json["user"]?["operationalHours"] != null
          ? (json["user"]["operationalHours"] as List)
          .map((e) => BusinessHour.fromJson(e))
          .toList()
          : [],
      photos: json["photos"] != null
          ? (json["photos"] as List).map((e) => Photo.fromJson(e)).toList()
          : [],
      menuCategory: json["menuCategory"] != null
          ? (json["menuCategory"] as List)
          .map((e) => MenuCategory.fromJson(e))
          .toList()
          : [],
    );
  }
}


class BusinessHour {
  final String? day;
  final String? startTime;
  final String? endTime;
  final bool? isClosed;

  BusinessHour({
    this.day,
    this.startTime,
    this.endTime,
    this.isClosed,
  });

  factory BusinessHour.fromJson(Map<String, dynamic> json) {
    return BusinessHour(
      day: json["day"],
      startTime: json["startTime"],
      endTime: json["endTime"],
      isClosed: json["isClosed"],
    );
  }
}


class Photo {
  final int? id;
  final String? url;

  Photo({this.id, this.url});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json["id"],
      url: json["url"],
    );
  }
}


class MenuCategory {
  final int? id;
  final String? name;
  final List<Dish>? dishes;

  MenuCategory({this.id, this.name, this.dishes});

  factory MenuCategory.fromJson(Map<String, dynamic> json) {
    return MenuCategory(
      id: json["id"],
      name: json["name"],
      dishes: json["dishes"] != null
          ? (json["dishes"] as List).map((e) => Dish.fromJson(e)).toList()
          : [],
    );
  }
}

class Dish {
  final int? id;
  final String? name;
  final String? description;
  final num? price;

  Dish({this.id, this.name, this.description, this.price});

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      price: json["price"],
    );
  }
}


class Wellness {
  final List<dynamic> services;
  final List<dynamic> selectedServices;

  Wellness({required this.services, required this.selectedServices});

  factory Wellness.fromJson(Map<String, dynamic> json) {
    return Wellness(
      services: json["services"] ?? [],
      selectedServices: json["selectedServices"] ?? [],
    );
  }
}

class Stats {
  final int? posts;
  final int? followers;

  Stats({this.posts, this.followers});

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      posts: json["posts"],
      followers: json["followers"],
    );
  }
}

class Socials {
  final String? instagram;
  final String? twitter;
  final String? facebook;
  final String? website;

  Socials({
    this.instagram,
    this.twitter,
    this.facebook,
    this.website,
  });

  factory Socials.fromJson(Map<String, dynamic> json) {
    return Socials(
      instagram: json["instagram"],
      twitter: json["twitter"],
      facebook: json["facebook"],
      website: json["website"],
    );
  }
}
