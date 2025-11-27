import 'package:choice_app/models/get_event_booking_details_response.dart';
import 'package:choice_app/models/get_user_bookings_response.dart';
import 'package:choice_app/network/API.dart';
import 'package:choice_app/network/api_url.dart';
import 'package:choice_app/res/loader.dart';
import 'package:choice_app/res/toasts.dart';
import 'package:flutter/material.dart';
import 'package:choice_app/network/models.dart';

import '../../l18n.dart';
import '../../models/get_normal_booking_details_response.dart';

enum BookingStatus { scheduled, inProgress, completed, cancelled }

extension BookingStatusExtension on BookingStatus {
  String toName() => name;
}

class BookingsProvider extends ChangeNotifier {
  BuildContext? context;
  final Loader _loader = Loader();

  GetUserBookingsResponse? getUpcomingBookingsResponse;
  GetUserBookingsResponse? getInProgressBookingsResponse;
  GetUserBookingsResponse? getCompletedBookingsResponse;
  GetUserBookingsResponse? getCancelledBookingsResponse;

  init(context) {
    this.context = context;
  }

  Future<void> getBookings({required BookingStatus status}) async {
    try {
      _loader.showLoader(context: context);

      final params = {'status': status.toName(), 'timeZone': 'Asia/Karachi'};

      final response = await MyApi.callGetApi(
        url: getUserBookingsApiUrl,
        modelName: Models.getBookingsModel,
        parameters: params,
      );

      debugPrint("Get bookings response: $response");

      //todo dummy data do not remove for now
      final json = {
        "data": {
          "eventBookings": [
            {
              "booking": {
                "id": 23,
                "numberOfPersons": 2,
                "totalPrice": "30.00",
                "status": "scheduled",
                "internalNotes": null,
                "createdAt": "2025-11-06T08:16:00.352Z",
                "event": {
                  "id": 46,
                  "title": "Italian Food Festival",
                  "description":
                      "A weekend of authentic Italian flavors, live music, and wine tasting.",
                  "date": "2025-11-06",
                  "startTime": "12:00",
                  "endTime": "22:00",
                  "timeZone": "Europe/Paris",
                  "venueName": "PizzTown",
                  "location": "Downtown Piazza",
                  "latitude": "41.902800",
                  "longitude": "12.496400",
                  "serviceType": "Restaurant",
                  "pricePerGuest": "15.00",
                  "maxCapacity": 100,
                  "eventImages": [
                    "events/food-festival/food1.jpg",
                    "events/food-festival/food2.jpg",
                  ],
                  "status": "Active",
                  "slug": null,
                  "leisureId": null,
                  "eventTypeId": null,
                  "rating": null,
                  "producerId": 28,
                  "isActive": true,
                  "isDeleted": false,
                  "createdAt": "2025-11-06T07:31:41.352Z",
                  "updatedAt": "2025-11-06T07:31:41.352Z",
                  "producer": {
                    "id": 28,
                    "userId": 58,
                    "name": "New restaurant",
                    "companyEmail": null,
                    "address": "123 Java Street, Remote City",
                    "city": null,
                    "country": null,
                    "details": null,
                    "mapsUrl": null,
                    "placeId": "58",
                    "latitude": "48.856600",
                    "longitude": "2.352200",
                    "locationPoint": {
                      "type": "Point",
                      "coordinates": [2.3522, 48.8566],
                    },
                    "rating": null,
                    "phoneNumber": "+335551234567",
                    "website": "https://umaircoffee.com",
                    "totalSeats": null,
                    "noOfTables": null,
                    "maxPartySize": null,
                    "type": "restaurant",
                    "status": "pending",
                    "isActive": true,
                    "isDeleted": false,
                    "document1": null,
                    "document2": null,
                    "document1Expiry": null,
                    "document2Expiry": null,
                    "slotDuration": "2.00",
                    "createdAt": "2025-08-27T06:52:43.745Z",
                    "updatedAt": "2025-11-11T08:18:40.937Z",
                    "user": {
                      "id": 58,
                      "email": "restaurantowner@example.com",
                      "deviceId": "",
                      "fullName": null,
                      "userName": null,
                      "phoneNumber": "+335551234567",
                      "isActive": true,
                      "isDeleted": false,
                      "isSocialLogin": false,
                      "isVerified": true,
                      "followingCount": 0,
                      "followersCount": 0,
                      "latitude": null,
                      "longitude": null,
                      "bio": null,
                      "profileImageUrl": null,
                      "createdAt": "2025-08-27T06:52:43.745Z",
                      "updatedAt": "2025-11-07T06:28:04.895Z",
                    },
                  },
                },
                "canCheckIn": false,
                "canCancel": true,
              },
              "producer": {
                "id": 28,
                "userId": 58,
                "name": "New restaurant",
                "companyEmail": null,
                "address": "123 Java Street, Remote City",
                "city": null,
                "country": null,
                "details": null,
                "mapsUrl": null,
                "placeId": "58",
                "latitude": "48.856600",
                "longitude": "2.352200",
                "locationPoint": {
                  "type": "Point",
                  "coordinates": [2.3522, 48.8566],
                },
                "rating": null,
                "phoneNumber": "+335551234567",
                "website": "https://umaircoffee.com",
                "totalSeats": null,
                "noOfTables": null,
                "maxPartySize": null,
                "type": "restaurant",
                "status": "pending",
                "isActive": true,
                "isDeleted": false,
                "document1": null,
                "document2": null,
                "document1Expiry": null,
                "document2Expiry": null,
                "slotDuration": "2.00",
                "createdAt": "2025-08-27T06:52:43.745Z",
                "updatedAt": "2025-11-11T08:18:40.937Z",
                "user": {
                  "id": 58,
                  "email": "restaurantowner@example.com",
                  "deviceId": "",
                  "fullName": null,
                  "userName": null,
                  "phoneNumber": "+335551234567",
                  "isActive": true,
                  "isDeleted": false,
                  "isSocialLogin": false,
                  "isVerified": true,
                  "followingCount": 0,
                  "followersCount": 0,
                  "latitude": null,
                  "longitude": null,
                  "bio": null,
                  "profileImageUrl": null,
                  "createdAt": "2025-08-27T06:52:43.745Z",
                  "updatedAt": "2025-11-07T06:28:04.895Z",
                },
              },
            },
            {
              "booking": {
                "id": 12,
                "numberOfPersons": 4,
                "totalPrice": null,
                "status": "scheduled",
                "internalNotes": null,
                "createdAt": "2025-08-27T07:05:57.715Z",
                "event": {
                  "id": 25,
                  "title": "Italian Food Festival",
                  "description":
                      "A weekend of authentic Italian flavors, live music, and wine tasting.",
                  "date": "2025-10-05",
                  "startTime": "12:00",
                  "endTime": "22:00",
                  "timeZone": "UTC",
                  "venueName": null,
                  "location": "Downtown Piazza",
                  "latitude": null,
                  "longitude": null,
                  "serviceType": "Restaurant",
                  "pricePerGuest": "25.00",
                  "maxCapacity": 100,
                  "eventImages": [
                    "events/food-festival/food1.jpg",
                    "events/food-festival/food2.jpg",
                  ],
                  "status": "Active",
                  "slug": null,
                  "leisureId": null,
                  "eventTypeId": 10,
                  "rating": null,
                  "producerId": 28,
                  "isActive": true,
                  "isDeleted": false,
                  "createdAt": "2025-08-27T07:04:01.921Z",
                  "updatedAt": "2025-08-27T07:04:01.921Z",
                  "producer": {
                    "id": 28,
                    "userId": 58,
                    "name": "New restaurant",
                    "companyEmail": null,
                    "address": "123 Java Street, Remote City",
                    "city": null,
                    "country": null,
                    "details": null,
                    "mapsUrl": null,
                    "placeId": "58",
                    "latitude": "48.856600",
                    "longitude": "2.352200",
                    "locationPoint": {
                      "type": "Point",
                      "coordinates": [2.3522, 48.8566],
                    },
                    "rating": null,
                    "phoneNumber": "+335551234567",
                    "website": "https://umaircoffee.com",
                    "totalSeats": null,
                    "noOfTables": null,
                    "maxPartySize": null,
                    "type": "restaurant",
                    "status": "pending",
                    "isActive": true,
                    "isDeleted": false,
                    "document1": null,
                    "document2": null,
                    "document1Expiry": null,
                    "document2Expiry": null,
                    "slotDuration": "2.00",
                    "createdAt": "2025-08-27T06:52:43.745Z",
                    "updatedAt": "2025-11-11T08:18:40.937Z",
                    "user": {
                      "id": 58,
                      "email": "restaurantowner@example.com",
                      "deviceId": "",
                      "fullName": null,
                      "userName": null,
                      "phoneNumber": "+335551234567",
                      "isActive": true,
                      "isDeleted": false,
                      "isSocialLogin": false,
                      "isVerified": true,
                      "followingCount": 0,
                      "followersCount": 0,
                      "latitude": null,
                      "longitude": null,
                      "bio": null,
                      "profileImageUrl": null,
                      "createdAt": "2025-08-27T06:52:43.745Z",
                      "updatedAt": "2025-11-07T06:28:04.895Z",
                    },
                  },
                },
                "canCheckIn": false,
                "canCancel": true,
              },
              "producer": {
                "id": 28,
                "userId": 58,
                "name": "New restaurant",
                "companyEmail": null,
                "address": "123 Java Street, Remote City",
                "city": null,
                "country": null,
                "details": null,
                "mapsUrl": null,
                "placeId": "58",
                "latitude": "48.856600",
                "longitude": "2.352200",
                "locationPoint": {
                  "type": "Point",
                  "coordinates": [2.3522, 48.8566],
                },
                "rating": null,
                "phoneNumber": "+335551234567",
                "website": "https://umaircoffee.com",
                "totalSeats": null,
                "noOfTables": null,
                "maxPartySize": null,
                "type": "restaurant",
                "status": "pending",
                "isActive": true,
                "isDeleted": false,
                "document1": null,
                "document2": null,
                "document1Expiry": null,
                "document2Expiry": null,
                "slotDuration": "2.00",
                "createdAt": "2025-08-27T06:52:43.745Z",
                "updatedAt": "2025-11-11T08:18:40.937Z",
                "user": {
                  "id": 58,
                  "email": "restaurantowner@example.com",
                  "deviceId": "",
                  "fullName": null,
                  "userName": null,
                  "phoneNumber": "+335551234567",
                  "isActive": true,
                  "isDeleted": false,
                  "isSocialLogin": false,
                  "isVerified": true,
                  "followingCount": 0,
                  "followersCount": 0,
                  "latitude": null,
                  "longitude": null,
                  "bio": null,
                  "profileImageUrl": null,
                  "createdAt": "2025-08-27T06:52:43.745Z",
                  "updatedAt": "2025-11-07T06:28:04.895Z",
                },
              },
            },
          ],
          "restaurantBookings": [
            {
              "booking": {
                "id": 5,
                "startDateTime": "2026-08-29T10:00:00.000Z",
                "endDateTime": "2026-08-29T11:00:00.000Z",
                "checkInAt": null,
                "cancelAt": null,
                "slotStartTime": "10:00",
                "slotEndTime": "11:00",
                "bookingDate": "2025-08-29",
                "status": "scheduled",
                "location": "",
                "customerName": "jhon due",
                "reviewAdded": false,
                "latitude": 31.470405,
                "longitude": 74.389292,
                "locationPoint": {
                  "type": "Point",
                  "coordinates": [74.389292, 31.470405],
                },
                "timeZone": "Asia/Karachi",
                "cancelBy": null,
                "cancelReason":
                    "Cancelled by system because its overdue and no action was taken",
                "guestCount": 5,
                "specialRequest": "i want peace",
                "day": "Friday",
                "date": "2026-08-29",
                "isActive": true,
                "isDeleted": false,
                "createdAt": "2025-08-29T00:33:57.810Z",
                "updatedAt": "2025-11-05T14:00:54.626Z",
                "customer": {
                  "id": 2,
                  "email": "jhon@example.com",
                  "deviceId": "adjlkdjldjlkdc",
                  "fullName": "Umair Dev 12",
                  "userName": "umairdev12",
                  "phoneNumber": "+92 300 1234501",
                  "isActive": false,
                  "isDeleted": true,
                  "isSocialLogin": false,
                  "isVerified": true,
                  "followingCount": 6,
                  "followersCount": 0,
                  "latitude": 24.8607,
                  "longitude": 67.0011,
                  "bio": "Full-stack dev, coffee lover ☕, and indie hacker.",
                  "profileImageUrl":
                      "https://cdn.yourapp.com/images/profile-umair.jpg",
                  "createdAt": "2025-06-24T06:44:05.944Z",
                  "updatedAt": "2025-10-08T07:05:32.171Z",
                },
                "restaurant": {
                  "id": 58,
                  "email": "restaurantowner@example.com",
                  "deviceId": "",
                  "fullName": null,
                  "userName": null,
                  "phoneNumber": "+335551234567",
                  "isActive": true,
                  "isDeleted": false,
                  "isSocialLogin": false,
                  "isVerified": true,
                  "followingCount": 0,
                  "followersCount": 0,
                  "latitude": null,
                  "longitude": null,
                  "bio": null,
                  "profileImageUrl": null,
                  "createdAt": "2025-08-27T06:52:43.745Z",
                  "updatedAt": "2025-11-07T06:28:04.895Z",
                  "producer": {
                    "id": 28,
                    "userId": 58,
                    "name": "New restaurant",
                    "companyEmail": null,
                    "address": "123 Java Street, Remote City",
                    "city": null,
                    "country": null,
                    "details": null,
                    "mapsUrl": null,
                    "placeId": "58",
                    "latitude": "48.856600",
                    "longitude": "2.352200",
                    "locationPoint": {
                      "type": "Point",
                      "coordinates": [2.3522, 48.8566],
                    },
                    "rating": null,
                    "phoneNumber": "+335551234567",
                    "website": "https://umaircoffee.com",
                    "totalSeats": null,
                    "noOfTables": null,
                    "maxPartySize": null,
                    "type": "restaurant",
                    "status": "pending",
                    "isActive": true,
                    "isDeleted": false,
                    "document1": null,
                    "document2": null,
                    "document1Expiry": null,
                    "document2Expiry": null,
                    "slotDuration": "2.00",
                    "createdAt": "2025-08-27T06:52:43.745Z",
                    "updatedAt": "2025-11-11T08:18:40.937Z",
                    "user": {
                      "id": 58,
                      "email": "restaurantowner@example.com",
                      "deviceId": "",
                      "fullName": null,
                      "userName": null,
                      "phoneNumber": "+335551234567",
                      "isActive": true,
                      "isDeleted": false,
                      "isSocialLogin": false,
                      "isVerified": true,
                      "followingCount": 0,
                      "followersCount": 0,
                      "latitude": null,
                      "longitude": null,
                      "bio": null,
                      "profileImageUrl": null,
                      "createdAt": "2025-08-27T06:52:43.745Z",
                      "updatedAt": "2025-11-07T06:28:04.895Z",
                    },
                  },
                },
                "canCancel": true,
                "canCheckIn": false,
              },
              "producer": {
                "id": 28,
                "userId": 58,
                "name": "New restaurant",
                "companyEmail": null,
                "address": "123 Java Street, Remote City",
                "city": null,
                "country": null,
                "details": null,
                "mapsUrl": null,
                "placeId": "58",
                "latitude": "48.856600",
                "longitude": "2.352200",
                "locationPoint": {
                  "type": "Point",
                  "coordinates": [2.3522, 48.8566],
                },
                "rating": null,
                "phoneNumber": "+335551234567",
                "website": "https://umaircoffee.com",
                "totalSeats": null,
                "noOfTables": null,
                "maxPartySize": null,
                "type": "restaurant",
                "status": "pending",
                "isActive": true,
                "isDeleted": false,
                "document1": null,
                "document2": null,
                "document1Expiry": null,
                "document2Expiry": null,
                "slotDuration": "2.00",
                "createdAt": "2025-08-27T06:52:43.745Z",
                "updatedAt": "2025-11-11T08:18:40.937Z",
                "user": {
                  "id": 58,
                  "email": "restaurantowner@example.com",
                  "deviceId": "",
                  "fullName": null,
                  "userName": null,
                  "phoneNumber": "+335551234567",
                  "isActive": true,
                  "isDeleted": false,
                  "isSocialLogin": false,
                  "isVerified": true,
                  "followingCount": 0,
                  "followersCount": 0,
                  "latitude": null,
                  "longitude": null,
                  "bio": null,
                  "profileImageUrl": null,
                  "createdAt": "2025-08-27T06:52:43.745Z",
                  "updatedAt": "2025-11-07T06:28:04.895Z",
                },
              },
            },
            {
              "booking": {
                "id": 4,
                "startDateTime": "2026-08-29T10:00:00.000Z",
                "endDateTime": "2026-08-29T11:00:00.000Z",
                "checkInAt": null,
                "cancelAt": null,
                "slotStartTime": "10:00",
                "slotEndTime": "11:00",
                "bookingDate": "2025-08-29",
                "status": "scheduled",
                "location": "",
                "customerName": "jhon due",
                "reviewAdded": false,
                "latitude": 31.470405,
                "longitude": 74.389292,
                "locationPoint": {
                  "type": "Point",
                  "coordinates": [74.389292, 31.470405],
                },
                "timeZone": "Asia/Karachi",
                "cancelBy": null,
                "cancelReason":
                    "Cancelled by system because its overdue and no action was taken",
                "guestCount": 5,
                "specialRequest": "i want peace",
                "day": "Friday",
                "date": "2026-08-29",
                "isActive": true,
                "isDeleted": false,
                "createdAt": "2025-08-29T00:20:55.943Z",
                "updatedAt": "2025-11-05T14:00:54.626Z",
                "customer": {
                  "id": 2,
                  "email": "jhon@example.com",
                  "deviceId": "adjlkdjldjlkdc",
                  "fullName": "Umair Dev 12",
                  "userName": "umairdev12",
                  "phoneNumber": "+92 300 1234501",
                  "isActive": false,
                  "isDeleted": true,
                  "isSocialLogin": false,
                  "isVerified": true,
                  "followingCount": 6,
                  "followersCount": 0,
                  "latitude": 24.8607,
                  "longitude": 67.0011,
                  "bio": "Full-stack dev, coffee lover ☕, and indie hacker.",
                  "profileImageUrl":
                      "https://cdn.yourapp.com/images/profile-umair.jpg",
                  "createdAt": "2025-06-24T06:44:05.944Z",
                  "updatedAt": "2025-10-08T07:05:32.171Z",
                },
                "restaurant": {
                  "id": 58,
                  "email": "restaurantowner@example.com",
                  "deviceId": "",
                  "fullName": null,
                  "userName": null,
                  "phoneNumber": "+335551234567",
                  "isActive": true,
                  "isDeleted": false,
                  "isSocialLogin": false,
                  "isVerified": true,
                  "followingCount": 0,
                  "followersCount": 0,
                  "latitude": null,
                  "longitude": null,
                  "bio": null,
                  "profileImageUrl": null,
                  "createdAt": "2025-08-27T06:52:43.745Z",
                  "updatedAt": "2025-11-07T06:28:04.895Z",
                  "producer": {
                    "id": 28,
                    "userId": 58,
                    "name": "New restaurant",
                    "companyEmail": null,
                    "address": "123 Java Street, Remote City",
                    "city": null,
                    "country": null,
                    "details": null,
                    "mapsUrl": null,
                    "placeId": "58",
                    "latitude": "48.856600",
                    "longitude": "2.352200",
                    "locationPoint": {
                      "type": "Point",
                      "coordinates": [2.3522, 48.8566],
                    },
                    "rating": null,
                    "phoneNumber": "+335551234567",
                    "website": "https://umaircoffee.com",
                    "totalSeats": null,
                    "noOfTables": null,
                    "maxPartySize": null,
                    "type": "restaurant",
                    "status": "pending",
                    "isActive": true,
                    "isDeleted": false,
                    "document1": null,
                    "document2": null,
                    "document1Expiry": null,
                    "document2Expiry": null,
                    "slotDuration": "2.00",
                    "createdAt": "2025-08-27T06:52:43.745Z",
                    "updatedAt": "2025-11-11T08:18:40.937Z",
                    "user": {
                      "id": 58,
                      "email": "restaurantowner@example.com",
                      "deviceId": "",
                      "fullName": null,
                      "userName": null,
                      "phoneNumber": "+335551234567",
                      "isActive": true,
                      "isDeleted": false,
                      "isSocialLogin": false,
                      "isVerified": true,
                      "followingCount": 0,
                      "followersCount": 0,
                      "latitude": null,
                      "longitude": null,
                      "bio": null,
                      "profileImageUrl": null,
                      "createdAt": "2025-08-27T06:52:43.745Z",
                      "updatedAt": "2025-11-07T06:28:04.895Z",
                    },
                  },
                },
                "canCancel": true,
                "canCheckIn": false,
              },
              "producer": {
                "id": 28,
                "userId": 58,
                "name": "New restaurant",
                "companyEmail": null,
                "address": "123 Java Street, Remote City",
                "city": null,
                "country": null,
                "details": null,
                "mapsUrl": null,
                "placeId": "58",
                "latitude": "48.856600",
                "longitude": "2.352200",
                "locationPoint": {
                  "type": "Point",
                  "coordinates": [2.3522, 48.8566],
                },
                "rating": null,
                "phoneNumber": "+335551234567",
                "website": "https://umaircoffee.com",
                "totalSeats": null,
                "noOfTables": null,
                "maxPartySize": null,
                "type": "restaurant",
                "status": "pending",
                "isActive": true,
                "isDeleted": false,
                "document1": null,
                "document2": null,
                "document1Expiry": null,
                "document2Expiry": null,
                "slotDuration": "2.00",
                "createdAt": "2025-08-27T06:52:43.745Z",
                "updatedAt": "2025-11-11T08:18:40.937Z",
                "user": {
                  "id": 58,
                  "email": "restaurantowner@example.com",
                  "deviceId": "",
                  "fullName": null,
                  "userName": null,
                  "phoneNumber": "+335551234567",
                  "isActive": true,
                  "isDeleted": false,
                  "isSocialLogin": false,
                  "isVerified": true,
                  "followingCount": 0,
                  "followersCount": 0,
                  "latitude": null,
                  "longitude": null,
                  "bio": null,
                  "profileImageUrl": null,
                  "createdAt": "2025-08-27T06:52:43.745Z",
                  "updatedAt": "2025-11-07T06:28:04.895Z",
                },
              },
            },
            {
              "booking": {
                "id": 3,
                "startDateTime": "2026-08-29T10:00:00.000Z",
                "endDateTime": "2026-08-29T11:00:00.000Z",
                "checkInAt": null,
                "cancelAt": "2025-08-29T05:20:16.562Z",
                "slotStartTime": "10:00",
                "slotEndTime": "11:00",
                "bookingDate": "2025-08-29",
                "status": "scheduled",
                "location": "",
                "customerName": "jhon due",
                "reviewAdded": false,
                "latitude": 31.470405,
                "longitude": 74.389292,
                "locationPoint": {
                  "type": "Point",
                  "coordinates": [74.389292, 31.470405],
                },
                "timeZone": "Asia/Karachi",
                "cancelBy": "user",
                "cancelReason": "i dont want to book currently",
                "guestCount": 5,
                "specialRequest": "i want peace",
                "day": "Friday",
                "date": "2026-08-29",
                "isActive": true,
                "isDeleted": false,
                "createdAt": "2025-08-29T00:19:13.252Z",
                "updatedAt": "2025-08-29T00:20:17.381Z",
                "customer": {
                  "id": 2,
                  "email": "jhon@example.com",
                  "deviceId": "adjlkdjldjlkdc",
                  "fullName": "Umair Dev 12",
                  "userName": "umairdev12",
                  "phoneNumber": "+92 300 1234501",
                  "isActive": false,
                  "isDeleted": true,
                  "isSocialLogin": false,
                  "isVerified": true,
                  "followingCount": 6,
                  "followersCount": 0,
                  "latitude": 24.8607,
                  "longitude": 67.0011,
                  "bio": "Full-stack dev, coffee lover ☕, and indie hacker.",
                  "profileImageUrl":
                      "https://cdn.yourapp.com/images/profile-umair.jpg",
                  "createdAt": "2025-06-24T06:44:05.944Z",
                  "updatedAt": "2025-10-08T07:05:32.171Z",
                },
                "restaurant": {
                  "id": 58,
                  "email": "restaurantowner@example.com",
                  "deviceId": "",
                  "fullName": null,
                  "userName": null,
                  "phoneNumber": "+335551234567",
                  "isActive": true,
                  "isDeleted": false,
                  "isSocialLogin": false,
                  "isVerified": true,
                  "followingCount": 0,
                  "followersCount": 0,
                  "latitude": null,
                  "longitude": null,
                  "bio": null,
                  "profileImageUrl": null,
                  "createdAt": "2025-08-27T06:52:43.745Z",
                  "updatedAt": "2025-11-07T06:28:04.895Z",
                  "producer": {
                    "id": 28,
                    "userId": 58,
                    "name": "New restaurant",
                    "companyEmail": null,
                    "address": "123 Java Street, Remote City",
                    "city": null,
                    "country": null,
                    "details": null,
                    "mapsUrl": null,
                    "placeId": "58",
                    "latitude": "48.856600",
                    "longitude": "2.352200",
                    "locationPoint": {
                      "type": "Point",
                      "coordinates": [2.3522, 48.8566],
                    },
                    "rating": null,
                    "phoneNumber": "+335551234567",
                    "website": "https://umaircoffee.com",
                    "totalSeats": null,
                    "noOfTables": null,
                    "maxPartySize": null,
                    "type": "restaurant",
                    "status": "pending",
                    "isActive": true,
                    "isDeleted": false,
                    "document1": null,
                    "document2": null,
                    "document1Expiry": null,
                    "document2Expiry": null,
                    "slotDuration": "2.00",
                    "createdAt": "2025-08-27T06:52:43.745Z",
                    "updatedAt": "2025-11-11T08:18:40.937Z",
                    "user": {
                      "id": 58,
                      "email": "restaurantowner@example.com",
                      "deviceId": "",
                      "fullName": null,
                      "userName": null,
                      "phoneNumber": "+335551234567",
                      "isActive": true,
                      "isDeleted": false,
                      "isSocialLogin": false,
                      "isVerified": true,
                      "followingCount": 0,
                      "followersCount": 0,
                      "latitude": null,
                      "longitude": null,
                      "bio": null,
                      "profileImageUrl": null,
                      "createdAt": "2025-08-27T06:52:43.745Z",
                      "updatedAt": "2025-11-07T06:28:04.895Z",
                    },
                  },
                },
                "canCancel": true,
                "canCheckIn": false,
              },
              "producer": {
                "id": 28,
                "userId": 58,
                "name": "New restaurant",
                "companyEmail": null,
                "address": "123 Java Street, Remote City",
                "city": null,
                "country": null,
                "details": null,
                "mapsUrl": null,
                "placeId": "58",
                "latitude": "48.856600",
                "longitude": "2.352200",
                "locationPoint": {
                  "type": "Point",
                  "coordinates": [2.3522, 48.8566],
                },
                "rating": null,
                "phoneNumber": "+335551234567",
                "website": "https://umaircoffee.com",
                "totalSeats": null,
                "noOfTables": null,
                "maxPartySize": null,
                "type": "restaurant",
                "status": "pending",
                "isActive": true,
                "isDeleted": false,
                "document1": null,
                "document2": null,
                "document1Expiry": null,
                "document2Expiry": null,
                "slotDuration": "2.00",
                "createdAt": "2025-08-27T06:52:43.745Z",
                "updatedAt": "2025-11-11T08:18:40.937Z",
                "user": {
                  "id": 58,
                  "email": "restaurantowner@example.com",
                  "deviceId": "",
                  "fullName": null,
                  "userName": null,
                  "phoneNumber": "+335551234567",
                  "isActive": true,
                  "isDeleted": false,
                  "isSocialLogin": false,
                  "isVerified": true,
                  "followingCount": 0,
                  "followersCount": 0,
                  "latitude": null,
                  "longitude": null,
                  "bio": null,
                  "profileImageUrl": null,
                  "createdAt": "2025-08-27T06:52:43.745Z",
                  "updatedAt": "2025-11-07T06:28:04.895Z",
                },
              },
            },
          ],
        },
      };

      // final GetUserBookingsResponse? upcomingBookings = GetUserBookingsResponse.fromJson(json);

      _loader.hideLoader(context!);

      if (response != null) {
        if (status == BookingStatus.scheduled) {
          getUpcomingBookingsResponse = response;
          // getUpcomingBookingsResponse = upcomingBookings;
        } else if (status == BookingStatus.inProgress) {
          getInProgressBookingsResponse = response;
        } else if (status == BookingStatus.completed) {
          getCompletedBookingsResponse = response;
        } else if (status == BookingStatus.cancelled) {
          getCancelledBookingsResponse = response;
        }
        notifyListeners();
      } else {
        Toasts.getErrorToast(text: 'Failed to fetch bookings');
      }
    } catch (err) {
      debugPrint("Error getting bookings: $err");
      _loader.hideLoader(context!);
      Toasts.getErrorToast(text: 'Failed to fetch bookings');
    }
  }

  Future<bool> cancelBooking({
    required String reason,
    required int bookingId,
  }) async {
    try {
      final body = {"reason": reason};

      debugPrint("📝 EVENT cancel Body: $body");

      final response = await MyApi.callPutApi(
        url: '$userCancelBookingApiUrl/$bookingId',
        body: body,
      );

      final status = response?['status'] ?? 0;
      final message = response?['message'] ?? '';

      if (status == 200) {
        Toasts.getSuccessToast(text: message.isNotEmpty ? message : "Booking cancelled");
        return true;
      }

      Toasts.getErrorToast(text: message.isNotEmpty ? message : "Failed to cancel");
      return false;

    } catch (e) {
      debugPrint("❌ EVENT cancel ERROR: $e");
      Toasts.getErrorToast(text: "Something went wrong");
      return false;
    }
  }


  Future<bool> cancelBookingForProducer({
    required String reason,
    required int bookingId,
    required String timeZone,
  }) async {
    try {
      final body = {
        "cancelReason": reason,
        "timeZone": timeZone,
      };

      debugPrint("📝 NON-EVENT cancel Body: $body");

      final response = await MyApi.callPutApi(
        url: '$producerCancelBookingApiUrl/$bookingId',
        body: body,
      );

      // non-event returns { booking: {...} }
      if (response != null && response['booking'] != null) {
        Toasts.getSuccessToast(text: "Booking cancelled successfully");
        return true;
      }

      Toasts.getErrorToast(text: "Failed to cancel booking");
      return false;

    } catch (e) {
      debugPrint("❌ NON-EVENT cancel ERROR: $e");
      Toasts.getErrorToast(text: al.somethingWentWrong);
      return false;
    }
  }



  Future<bool> checkInBooking({required int bookingId}) async {
    try {
      debugPrint("📝 check-in booking id: $bookingId");

      final response = await MyApi.callPutApi(
        url: '$checkInBookingApiUrl/$bookingId',
      );

      if (response == null) {
        debugPrint("❌ API returned null");
        Toasts.getErrorToast(text: "Something went wrong");
        return false;
      }

      // response is a Map<String, dynamic>
      final status = response["status"];
      final message = response["message"];

      if (status == 200) {
        debugPrint("✅ Booking checked-in successfully");
        Toasts.getSuccessToast(text: message ?? 'Checked-in successfully');
        return true;
      } else {
        debugPrint("❌ Failed to check-in: $response");
        Toasts.getErrorToast(text: message ?? "Failed to check-in");
        return false;
      }
    } catch (e) {
      debugPrint("❌ Exception in check-in booking: $e");
      Toasts.getErrorToast(text: "Something went wrong");
      return false;
    }
  }
  Future<bool> checkInSimpleBooking({required int bookingId, required String timeZone}) async {
    try {
      debugPrint("📝 Check-in simple booking id: $bookingId with timeZone: $timeZone");

      final response = await MyApi.callPutApi(
        url: '$checkInSimpleBookingApiUrl/$bookingId',
        body: {
          "timeZone": timeZone,
        },
      );

      if (response != null && response['status'] == 200) {
        final booking = response['data']?['booking']; // optional if you want booking
        debugPrint("✅ Simple booking checked-in successfully | Booking: $booking");
        Toasts.getSuccessToast(text: 'Booking checked-in successfully');
        return true;
      }

      Toasts.getErrorToast(text: "Failed to check-in booking");
      return false;

    } catch (e) {
      debugPrint("❌ Error in check-in simple booking: $e");
      Toasts.getErrorToast(text: "Something went wrong");
      return false;
    }
  }

  EventBookingDetailsResponse? eventBookingDetails;

  Future<EventBookingDetailsResponse?> fetchEventBookingDetails(
      BuildContext context,
      int bookingId,
      ) async {
    try {
      _loader.showLoader(context: context);

      final response = await MyApi.callGetApi(
        url: "$getEventBookingDetailsApiUrl/$bookingId",
        modelName: Models.getEventBookingDetailsModel,
      );

      _loader.hideLoader(context!);

      if (response != null) {
        eventBookingDetails = response;
        notifyListeners();
        return response;
      } else {
        Toasts.getErrorToast(text: "Failed to fetch booking details");
        return null;
      }
    } catch (e) {
      debugPrint("❌ Error fetching event booking details: $e");
      _loader.hideLoader(context!);
      Toasts.getErrorToast(text: "Failed to fetch booking details");
      return null;
    }
  }

  SimpleBookingDetailsResponse? simpleBookingDetails;

  Future<SimpleBookingDetailsResponse?> fetchSimpleBookingDetails(
      BuildContext context,
      int bookingId,
      ) async {
    try {
      _loader.showLoader(context: context);

      final response = await MyApi.callGetApi(
        url: "$getSimpleBookingDetailsApiUrl/$bookingId",
        modelName: Models.getSimpleBookingDetailsModel,
        parameters: {"timeZone": "Asia/Karachi"}, // FIXED
      );

      _loader.hideLoader(context);

      if (response != null) {
        simpleBookingDetails = response;
        notifyListeners();
        return response;
      } else {
        Toasts.getErrorToast(text: "Failed to fetch booking details");
        return null;
      }
    } catch (e) {
      debugPrint("❌ Error fetching simple booking details: $e");
      _loader.hideLoader(context);
      Toasts.getErrorToast(text: "Failed to fetch booking details");
      return null;
    }
  }

  Future<bool> updateBooking({
    required int bookingId,
    required int slotId,
    required int guestCount,
    required String date,
    required String specialRequest,
    required String timeZone,
  }) async {
    try {
      final body = {
        "slotId": slotId,
        "guestCount": guestCount,
        "specialRequest": specialRequest,
        "date": date,
        "timeZone": timeZone,
      };

      debugPrint("📝 UPDATE Booking Body: $body");

      final response = await MyApi.callPutApi(
        url: '$updateBookingsApiUrl/$bookingId',
        body: body,
      );

      if (response != null && response['booking'] != null) {
        Toasts.getSuccessToast(text: "Booking updated successfully");
        return true;
      }

      Toasts.getErrorToast(text: "Failed to update booking");
      return false;

    } catch (e) {
      debugPrint("❌ Update Booking Error: $e");
      Toasts.getErrorToast(text: "Something went wrong");
      return false;
    }
  }


}
