class MoreEventsByProducerResponse {
  int? status;
  String? message;
  Data? data;

  MoreEventsByProducerResponse({this.status, this.message, this.data});

  MoreEventsByProducerResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  int? producerId;
  String? type;
  int? totalEvents;
  List<Event>? events;

  Data({this.producerId, this.type, this.totalEvents, this.events});

  Data.fromJson(Map<String, dynamic> json) {
    producerId = json['producerId'];
    type = json['type'];
    totalEvents = json['totalEvents'];
    if (json['events'] != null) {
      events = [];
      json['events'].forEach((v) {
        events!.add(Event.fromJson(v));
      });
    }
  }
}

class Event {
  int? id;
  String? title;
  String? description;
  String? date;
  String? startTime;
  String? endTime;
  String? timeZone;
  String? venueName;
  String? location;
  String? latitude;
  String? longitude;
  String? serviceType;
  String? pricePerGuest;
  int? maxCapacity;
  List<String>? eventImages;
  String? status;
  int? producerId;
  bool? isActive;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  Producer? producer;
  EventType? eventType;

  Event({
    this.id,
    this.title,
    this.description,
    this.date,
    this.startTime,
    this.endTime,
    this.timeZone,
    this.venueName,
    this.location,
    this.latitude,
    this.longitude,
    this.serviceType,
    this.pricePerGuest,
    this.maxCapacity,
    this.eventImages,
    this.status,
    this.producerId,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.producer,
    this.eventType,
  });

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    timeZone = json['timeZone'];
    venueName = json['venueName'];
    location = json['location'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    serviceType = json['serviceType'];
    pricePerGuest = json['pricePerGuest'];
    maxCapacity = json['maxCapacity'];
    eventImages = json['eventImages'] != null ? List<String>.from(json['eventImages']) : null;
    status = json['status'];
    producerId = json['producerId'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    producer = json['producer'] != null ? Producer.fromJson(json['producer']) : null;
    eventType = json['eventType'] != null ? EventType.fromJson(json['eventType']) : null;
  }
}

class Producer {
  int? id;
  int? userId;
  String? name;
  String? companyEmail;
  String? address;
  String? city;
  String? country;
  String? details;
  String? mapsUrl;
  String? placeId;
  String? latitude;
  String? longitude;
  LocationPoint? locationPoint;
  String? rating;
  String? phoneNumber;
  String? website;
  String? type;
  String? status;
  bool? isActive;
  bool? isDeleted;
  String? slotDuration;
  String? createdAt;
  String? updatedAt;

  Producer({
    this.id,
    this.userId,
    this.name,
    this.companyEmail,
    this.address,
    this.city,
    this.country,
    this.details,
    this.mapsUrl,
    this.placeId,
    this.latitude,
    this.longitude,
    this.locationPoint,
    this.rating,
    this.phoneNumber,
    this.website,
    this.type,
    this.status,
    this.isActive,
    this.isDeleted,
    this.slotDuration,
    this.createdAt,
    this.updatedAt,
  });

  Producer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    name = json['name'];
    companyEmail = json['companyEmail'];
    address = json['address'];
    city = json['city'];
    country = json['country'];
    details = json['details'];
    mapsUrl = json['mapsUrl'];
    placeId = json['placeId'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    locationPoint = json['locationPoint'] != null ? LocationPoint.fromJson(json['locationPoint']) : null;
    rating = json['rating'];
    phoneNumber = json['phoneNumber'];
    website = json['website'];
    type = json['type'];
    status = json['status'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    slotDuration = json['slotDuration'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}

class LocationPoint {
  String? type;
  List<double>? coordinates;

  LocationPoint({this.type, this.coordinates});

  LocationPoint.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'] != null ? List<double>.from(json['coordinates']) : null;
  }
}

class EventType {
  int? id;
  String? name;
  List<String>? criteria;
  String? createdAt;
  String? updatedAt;

  EventType({this.id, this.name, this.criteria, this.createdAt, this.updatedAt});

  EventType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    criteria = json['criteria'] != null ? List<String>.from(json['criteria']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}
