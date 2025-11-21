class EventBookingDetailsResponse {
  final int status;
  final String message;
  final BookingData data;

  EventBookingDetailsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory EventBookingDetailsResponse.fromJson(Map<String, dynamic> json) {
    return EventBookingDetailsResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: BookingData.fromJson(json['data']),
    );
  }
}

class BookingData {
  final int id;
  final int numberOfPersons;
  final String totalPrice;
  final String status;
  final String? internalNotes;
  final String createdAt;
  final UserData user;
  final EventData event;

  BookingData({
    required this.id,
    required this.numberOfPersons,
    required this.totalPrice,
    required this.status,
    required this.internalNotes,
    required this.createdAt,
    required this.user,
    required this.event,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      id: json['id'],
      numberOfPersons: json['numberOfPersons'],
      totalPrice: json['totalPrice'] ?? '0',
      status: json['status'] ?? '',
      internalNotes: json['internalNotes'],
      createdAt: json['createdAt'] ?? '',
      user: UserData.fromJson(json['user']),
      event: EventData.fromJson(json['event']),
    );
  }
}

class UserData {
  final int id;
  final String email;
  final String fullName;
  final String userName;
  final String phoneNumber;
  final String? profileImageUrl;

  UserData({
    required this.id,
    required this.email,
    required this.fullName,
    required this.userName,
    required this.phoneNumber,
    this.profileImageUrl,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      userName: json['userName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profileImageUrl: json['profileImageUrl'],
    );
  }
}

class EventData {
  final int id;
  final String title;
  final String description;
  final String date;
  final String startTime;
  final String endTime;
  final String timeZone;
  final String location;
  final String pricePerGuest;
  final int maxCapacity;
  final List<String> eventImages;

  EventData({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.timeZone,
    required this.location,
    required this.pricePerGuest,
    required this.maxCapacity,
    required this.eventImages,
  });

  factory EventData.fromJson(Map<String, dynamic> json) {
    return EventData(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      timeZone: json['timeZone'] ?? '',
      location: json['location'] ?? '',
      pricePerGuest: json['pricePerGuest'] ?? '0',
      maxCapacity: json['maxCapacity'] ?? 0,
      eventImages: List<String>.from(json['eventImages'] ?? []),
    );
  }
}
