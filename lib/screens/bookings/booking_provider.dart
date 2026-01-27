
import 'package:flutter/material.dart';
import '../../data/services/booking_service.dart';

class Booking {
  final int id;
  final String status;
  final String? startDateTime;
  final String? endDateTime;
  final int guestCount;
  final String customerName;
  final String customerImage;
  final double totalPrice;

  Booking({
    required this.id,
    required this.status,
    this.startDateTime,
    this.endDateTime,
    required this.guestCount,
    required this.customerName,
    required this.customerImage,
    required this.totalPrice,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    // Note: Backend structure might vary slightly between schemas, 
    // adjusting to the most likely common structure found in producer service.
    
    final customer = json['customer'] ?? {};
    final restaurant = json['restaurant']?.containsKey('restaurant') == true 
        ? json['restaurant']['restaurant'] 
        : (json['restaurant'] ?? {});

    return Booking(
      id: json['id'],
      status: json['status'] ?? 'scheduled',
      startDateTime: json['startDateTime'] ?? json['start'],
      endDateTime: json['endDateTime'],
      guestCount: json['numberOfPersons'] ?? 0,
      customerName: "${customer['firstName'] ?? ''} ${customer['lastName'] ?? ''}".trim(),
      customerImage: customer['profilePicture'] ?? '',
      totalPrice: (json['price'] ?? 0).toDouble(),
    );
  }
}

class BookingProvider extends ChangeNotifier {
  final BookingService _service = BookingService();

  List<Booking> _upcomingBookings = [];
  List<Booking> _inProgressBookings = [];
  List<Booking> _completedBookings = [];
  List<Booking> _cancelledBookings = [];

  bool _isLoading = false;

  List<Booking> get upcomingBookings => _upcomingBookings;
  List<Booking> get inProgressBookings => _inProgressBookings;
  List<Booking> get completedBookings => _completedBookings;
  List<Booking> get cancelledBookings => _cancelledBookings;
  bool get isLoading => _isLoading;

  Future<void> fetchBookings(String type) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _service.getBookings(type: type);
      final List<dynamic> data = response['bookings'] ?? [];
      final List<Booking> fetched = data.map((json) => Booking.fromJson(json)).toList();

      switch (type) {
        case 'scheduled':
          _upcomingBookings = fetched;
          break;
        case 'inProgress':
          _inProgressBookings = fetched;
          break;
        case 'completed':
          _completedBookings = fetched;
          break;
        case 'cancelled':
          _cancelledBookings = fetched;
          break;
      }
    } catch (e) {
      debugPrint('Error fetching $type bookings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkIn(int id) async {
    try {
      await _service.checkInBooking(id);
      await fetchBookings('scheduled');
      await fetchBookings('inProgress');
      return true;
    } catch (e) {
      debugPrint('Error checking in: $e');
      return false;
    }
  }

  Future<bool> cancel(int id, String reason) async {
    try {
      await _service.cancelBooking(id, reason);
      await fetchBookings('scheduled');
      await fetchBookings('cancelled');
      return true;
    } catch (e) {
      debugPrint('Error cancelling booking: $e');
      return false;
    }
  }
}
