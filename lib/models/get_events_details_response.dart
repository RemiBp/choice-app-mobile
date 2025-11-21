class EventDetailsResponse {
  int? status;
  String? message;
  EventData? data;

  EventDetailsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? EventData.fromJson(json['data']) : null;
  }
}

class EventData {
  int? id;
  String? title;
  String? description;
  String? date;
  String? startTime;
  String? endTime;
  String? timeZone;
  String? venueName;
  String? location;
  double? latitude;
  double? longitude;
  String? serviceType;
  String? pricePerGuest;
  int? maxCapacity;
  List<String>? eventImages;
  String? status;
  int? producerId;
  int? totalParticipants;

  Producer? producer;

  EventData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    timeZone = json['timeZone'];
    venueName = json['venueName'];
    location = json['location'];

    latitude = double.tryParse(json['latitude']?.toString() ?? "");
    longitude = double.tryParse(json['longitude']?.toString() ?? "");

    serviceType = json['serviceType'];
    pricePerGuest = json['pricePerGuest']?.toString();
    maxCapacity = json['maxCapacity'];
    status = json['status'];
    producerId = json['producerId'];
    totalParticipants = json['totalParticipants'];

    eventImages = json['eventImages'] != null
        ? List<String>.from(json['eventImages'])
        : [];

    producer = json['producer'] != null
        ? Producer.fromJson(json['producer'])
        : null;
  }
}

class Producer {
  int? id;
  String? name;
  String? address;
  String? phoneNumber;

  String? website;
  String? instagram;
  String? twitter;
  String? facebook;

  String? profileImage;
  User? user;

  List<Photo>? photos;
  List<MenuCategory>? menuCategory;

  Producer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    phoneNumber = json['phoneNumber'];

    website = json['website'];
    instagram = json['instagram'];
    twitter = json['twitter'];
    facebook = json['facebook'];

    profileImage = json['user']?['profileImageUrl'];

    user = json['user'] != null ? User.fromJson(json['user']) : null;

    photos = [];
    if (json['photos'] != null) {
      json['photos']
          .forEach((v) => photos!.add(Photo.fromJson(v)));
    }

    menuCategory = [];
    if (json['menuCategory'] != null) {
      json['menuCategory']
          .forEach((v) => menuCategory!.add(MenuCategory.fromJson(v)));
    }
  }
}

class Photo {
  int? id;
  String? url;

  Photo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
  }
}

class MenuCategory {
  int? id;
  String? name;
  List<Dish>? dishes;

  MenuCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];

    dishes = [];
    if (json['dishes'] != null) {
      json['dishes']
          .forEach((v) => dishes!.add(Dish.fromJson(v)));
    }
  }
}
class User {
  int? id;
  String? email;
  String? fullName;
  String? userName;
  String? phoneNumber;
  String? profileImageUrl;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    fullName = json['fullName'];
    userName = json['userName'];
    phoneNumber = json['phoneNumber'];
    profileImageUrl = json['profileImageUrl'];
  }
}

class Dish {
  int? id;
  String? name;
  String? description;
  double? price;

  Dish.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = (json['price'] as num?)?.toDouble();
  }
}
