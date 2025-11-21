class SimpleBookingDetailsResponse {
  final SimpleBookingData? booking;

  SimpleBookingDetailsResponse({this.booking});

  factory SimpleBookingDetailsResponse.fromJson(Map<String, dynamic> json) {
    return SimpleBookingDetailsResponse(
      booking: json["booking"] != null
          ? SimpleBookingData.fromJson(json["booking"])
          : null,
    );
  }
}

class SimpleBookingData {
  final int id;
  final String startDateTime;
  final String endDateTime;
  final String slotStartTime;
  final String slotEndTime;
  final String bookingDate;
  final String status;
  final String location;
  final String customerName;
  final bool reviewAdded;
  final double latitude;
  final double longitude;
  final int guestCount;
  final String internalNotes;

  final RestaurantWrapper? restaurant;

  SimpleBookingData({
    required this.id,
    required this.guestCount,
    required this.startDateTime,
    required this.endDateTime,
    required this.slotStartTime,
    required this.slotEndTime,
    required this.bookingDate,
    required this.status,
    required this.internalNotes,
    required this.location,
    required this.customerName,
    required this.reviewAdded,
    required this.latitude,
    required this.longitude,
    this.restaurant,
  });

  factory SimpleBookingData.fromJson(Map<String, dynamic> json) {
    return SimpleBookingData(
      id: json["id"] ?? 0,
      guestCount: json["guestCount"] ?? 0,
      startDateTime: json["startDateTime"] ?? "",
      endDateTime: json["endDateTime"] ?? "",
      slotStartTime: json["slotStartTime"] ?? "",
      slotEndTime: json["slotEndTime"] ?? "",
      bookingDate: json["bookingDate"] ?? "",
      status: json["status"] ?? "",
      internalNotes: json["internalNotes"] ?? "",
      location: json["location"] ?? "",
      customerName: json["customerName"] ?? "",
      reviewAdded: json["reviewAdded"] ?? false,
      latitude: (json["latitude"] ?? 0).toDouble(),
      longitude: (json["longitude"] ?? 0).toDouble(),
      restaurant: json["restaurant"] != null
          ? RestaurantWrapper.fromJson(json["restaurant"])
          : null,
    );
  }
}

class RestaurantWrapper {
  final int id;
  final RestaurantData? restaurant;

  RestaurantWrapper({required this.id, this.restaurant});

  factory RestaurantWrapper.fromJson(Map<String, dynamic> json) {
    return RestaurantWrapper(
      id: json["id"] ?? 0,
      restaurant: json["restaurant"] != null
          ? RestaurantData.fromJson(json["restaurant"])
          : null,
    );
  }
}

class RestaurantData {
  final int id;
  final String restaurantName;
  final String restaurantDetails;
  final String address;

  RestaurantData({
    required this.id,
    required this.restaurantName,
    required this.restaurantDetails,
    required this.address,
  });

  factory RestaurantData.fromJson(Map<String, dynamic> json) {
    return RestaurantData(
      id: json["id"] ?? 0,
      restaurantName: json["restaurantName"] ?? "",
      restaurantDetails: json["restaurantDetails"] ?? "",
      address: json["address"] ?? "",
    );
  }
}
