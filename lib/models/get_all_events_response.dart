class GetAllEventsResponse {
  int? status;
  String? message;
  List<Data>? data;

  GetAllEventsResponse({this.status, this.message, this.data});

  GetAllEventsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != String) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (this.data != String) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? title;
  String? description;
  String? date;
  String? startTime;
  String? endTime;
  String? venueName;
  String? location;
  String? serviceType;
  String? pricePerGuest;
  int? maxCapacity;
  List<String>? eventImages;
  String? status;
  String? slug;
  int? leisureId;
  int? eventTypeId;
  bool? isActive;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  Producer? producer;
  Leisure? leisure;
  EventType? eventType;

  Data({
    this.id,
    this.title,
    this.description,
    this.date,
    this.startTime,
    this.endTime,
    this.venueName,
    this.location,
    this.serviceType,
    this.pricePerGuest,
    this.maxCapacity,
    this.eventImages,
    this.status,
    this.slug,
    this.leisureId,
    this.eventTypeId,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.producer,
    this.leisure,
    this.eventType,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    venueName = json['venueName'];
    location = json['location'];
    serviceType = json['serviceType'];
    pricePerGuest = json['pricePerGuest'];
    maxCapacity = json['maxCapacity'];
    eventImages = json['eventImages'].cast<String>();
    status = json['status'];
    slug = json['slug'];
    leisureId = json['leisureId'];
    eventTypeId = json['eventTypeId'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    producer =
        json['producer'] != null ? Producer.fromJson(json['producer']) : null;
    leisure =
        json['leisure'] != null ? Leisure.fromJson(json['leisure']) : null;
    eventType =
        json['eventType'] != null
            ? EventType.fromJson(json['eventType'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['date'] = date;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['venueName'] = venueName;
    data['location'] = location;
    data['serviceType'] = serviceType;
    data['pricePerGuest'] = pricePerGuest;
    data['maxCapacity'] = maxCapacity;
    data['eventImages'] = eventImages;
    data['status'] = status;
    data['slug'] = slug;
    data['leisureId'] = leisureId;
    data['eventTypeId'] = eventTypeId;
    data['isActive'] = isActive;
    data['isDeleted'] = isDeleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (producer != null) {
      data['producer'] = producer!.toJson();
    }
    if(leisure != null) {
      data['leisure'] = leisure!.toJson();
    }
    if (eventType != null) {
      data['eventType'] = eventType!.toJson();
    }
    return data;
  }
}

class Producer {
  int? id;
  int? userId;
  String? name;
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
  String? totalSeats;
  String? noOfTables;
  String? maxPartySize;
  String? type;
  String? status;
  bool? isActive;
  bool? isDeleted;
  String? document1;
  String? document2;
  String? document1Expiry;
  String? document2Expiry;
  String? createdAt;
  String? updatedAt;

  Producer({
    this.id,
    this.userId,
    this.name,
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
    this.totalSeats,
    this.noOfTables,
    this.maxPartySize,
    this.type,
    this.status,
    this.isActive,
    this.isDeleted,
    this.document1,
    this.document2,
    this.document1Expiry,
    this.document2Expiry,
    this.createdAt,
    this.updatedAt,
  });

  Producer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    name = json['name'];
    address = json['address'];
    city = json['city'];
    country = json['country'];
    details = json['details'];
    mapsUrl = json['mapsUrl'];
    placeId = json['placeId'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    locationPoint =
        json['locationPoint'] != null
            ? LocationPoint.fromJson(json['locationPoint'])
            : null;
    rating = json['rating'];
    phoneNumber = json['phoneNumber'];
    website = json['website'];
    totalSeats = json['totalSeats'];
    noOfTables = json['noOfTables'];
    maxPartySize = json['maxPartySize'];
    type = json['type'];
    status = json['status'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    document1 = json['document1'];
    document2 = json['document2'];
    document1Expiry = json['document1Expiry'];
    document2Expiry = json['document2Expiry'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['userId'] = userId;
    data['name'] = name;
    data['address'] = address;
    data['city'] = city;
    data['country'] = country;
    data['details'] = details;
    data['mapsUrl'] = mapsUrl;
    data['placeId'] = placeId;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['locationPoint'] = locationPoint?.toJson();
    data['rating'] = rating;
    data['phoneNumber'] = phoneNumber;
    data['website'] = website;
    data['totalSeats'] = totalSeats;
    data['noOfTables'] = noOfTables;
    data['maxPartySize'] = maxPartySize;
    data['type'] = type;
    data['status'] = status;
    data['isActive'] = isActive;
    data['isDeleted'] = isDeleted;
    data['document1'] = document1;
    data['document2'] = document2;
    data['document1Expiry'] = document1Expiry;
    data['document2Expiry'] = document2Expiry;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class EventType {
  int? id;
  String? name;
  List<String>? criteria;
  String? createdAt;
  String? updatedAt;

  EventType({
    this.id,
    this.name,
    this.criteria,
    this.createdAt,
    this.updatedAt,
  });

  EventType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    criteria = json['criteria'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['criteria'] = criteria;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class LocationPoint {
  String? type;
  List<double>? coordinates;

  LocationPoint({this.type, this.coordinates});

  LocationPoint.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['coordinates'] != null) {
      coordinates = <double>[];
      json['coordinates'].forEach((v) {
        coordinates!.add((v as num).toDouble());
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    if (coordinates != null) {
      data['coordinates'] = coordinates;
    }
    return data;
  }
}

class Leisure {
  int? id;
  int? producerId;
  String? stageDirection;
  String? actorPerformance;
  String? textQuality;
  String? scenography;
  String? overall;
  String? aiStageDirection;
  String? aiActorPerformance;
  String? aiTextQuality;
  String? aiScenography;
  String? aiOverall;
  String? createdAt;
  String? updatedAt;

  Leisure({
    this.id,
    this.producerId,
    this.stageDirection,
    this.actorPerformance,
    this.textQuality,
    this.scenography,
    this.overall,
    this.aiStageDirection,
    this.aiActorPerformance,
    this.aiTextQuality,
    this.aiScenography,
    this.aiOverall,
    this.createdAt,
    this.updatedAt,
  });

  Leisure.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    producerId = json['producerId'];
    stageDirection = json['stageDirection'];
    actorPerformance = json['actorPerformance'];
    textQuality = json['textQuality'];
    scenography = json['scenography'];
    overall = json['overall'];
    aiStageDirection = json['ai_stageDirection'];
    aiActorPerformance = json['ai_actorPerformance'];
    aiTextQuality = json['ai_textQuality'];
    aiScenography = json['ai_scenography'];
    aiOverall = json['ai_overall'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['producerId'] = producerId;
    data['stageDirection'] = stageDirection;
    data['actorPerformance'] = actorPerformance;
    data['textQuality'] = textQuality;
    data['scenography'] = scenography;
    data['overall'] = overall;
    data['ai_stageDirection'] = aiStageDirection;
    data['ai_actorPerformance'] = aiActorPerformance;
    data['ai_textQuality'] = aiTextQuality;
    data['ai_scenography'] = aiScenography;
    data['ai_overall'] = aiOverall;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
