import 'package:flutter/material.dart';
import '../services/customer_service.dart';
import '../services/auth_service.dart';

class CustomerProvider extends ChangeNotifier {
  // ── Profile ───────────────────────────────────
  Map<String, dynamic>? profile;
  bool isLoadingProfile = false;

  // ── Bookings ──────────────────────────────────
  List<Map<String, dynamic>> bookings = [];
  bool isLoadingBookings = false;

  // ── Explore / Nearby ──────────────────────────
  List<Map<String, dynamic>> nearbyPlaces = [];
  bool isLoadingNearby = false;

  // ── Notifications ─────────────────────────────
  List<Map<String, dynamic>> notifications = [];

  // ── Search ────────────────────────────────────
  List<Map<String, dynamic>> searchResults = [];
  bool isSearching = false;

  // ── Producer Search ───────────────────────────
  List<Map<String, dynamic>> producerSearchResults = [];
  bool isSearchingProducers = false;

  String? error;

  // ─────────────────────────────────────────────
  // Profile
  // ─────────────────────────────────────────────

  Future<void> loadProfile() async {
    isLoadingProfile = true;
    error = null;
    notifyListeners();
    final r = await CustomerProfileService.getProfile();
    isLoadingProfile = false;
    if (r.success) {
      profile = r.data?['data'] as Map<String, dynamic>? ?? r.data;
    } else {
      error = r.message;
    }
    notifyListeners();
  }

  Future<AuthResult> updateProfile(Map<String, dynamic> body) async {
    final r = await CustomerProfileService.updateProfile(body);
    if (r.success) await loadProfile();
    return r;
  }

  // ─────────────────────────────────────────────
  // Search
  // ─────────────────────────────────────────────

  Future<void> searchUsers(String query) async {
    if (query.trim().isEmpty) {
      searchResults = [];
      isSearching = false;
      notifyListeners();
      return;
    }
    isSearching = true;
    notifyListeners();
    final r = await CustomerProfileService.searchUsers(query.trim());
    isSearching = false;
    if (r.success) {
      final raw = r.data?['data'] ?? r.data?['users'];
      searchResults = raw is List
          ? raw.map((e) => e as Map<String, dynamic>).toList()
          : [];
    }
    notifyListeners();
  }

  void clearSearch() {
    searchResults = [];
    isSearching = false;
    notifyListeners();
  }

  Future<void> searchProducers(String query, {String type = 'all'}) async {
    if (query.trim().isEmpty) {
      producerSearchResults = [];
      isSearchingProducers = false;
      notifyListeners();
      return;
    }
    isSearchingProducers = true;
    notifyListeners();
    final r = await CustomerMapsService.searchProducers(query.trim(), type: type);
    isSearchingProducers = false;
    if (r.success) {
      final dataField = r.data?['data'];
      final raw = dataField is Map
          ? dataField['producers']
          : (dataField is List ? dataField : null);
      producerSearchResults = raw is List
          ? raw.map((e) => e as Map<String, dynamic>).toList()
          : [];
    }
    notifyListeners();
  }

  void clearProducerSearch() {
    producerSearchResults = [];
    isSearchingProducers = false;
    notifyListeners();
  }

  Future<void> loadNotifications() async {
    final r = await CustomerProfileService.getNotifications();
    if (r.success) {
      final raw = r.data?['data'];
      notifications = raw is List
          ? raw.map((e) => e as Map<String, dynamic>).toList()
          : [];
      notifyListeners();
    }
  }

  // ─────────────────────────────────────────────
  // Bookings
  // ─────────────────────────────────────────────

  Future<void> loadBookings({String? status}) async {
    isLoadingBookings = true;
    notifyListeners();
    final r = await CustomerBookingService.getBookings(status: status);
    isLoadingBookings = false;
    if (r.success) {
      final raw = r.data?['data'];
      bookings = raw is List
          ? raw.map((e) => e as Map<String, dynamic>).toList()
          : [];
    }
    notifyListeners();
  }

  Future<AuthResult> createBooking(Map<String, dynamic> body) async {
    final r = await CustomerBookingService.createBooking(body);
    if (r.success) await loadBookings();
    return r;
  }

  Future<AuthResult> cancelBooking(int bookingId) async {
    final r = await CustomerBookingService.cancelBooking(bookingId);
    if (r.success) await loadBookings();
    return r;
  }

  Future<AuthResult> addReview(int bookingId, Map<String, dynamic> body) async {
    final r = await CustomerBookingService.addReview(bookingId, body);
    if (r.success) await loadBookings();
    return r;
  }

  /// Saves ratings via POST /api/app/post/saveRatings
  /// Body should include: producerId, rating, and optionally review/comment.
  Future<AuthResult> saveRatings(Map<String, dynamic> body) async {
    return CustomerPostService.saveRatings(body);
  }

  // ─────────────────────────────────────────────
  // Explore
  // ─────────────────────────────────────────────

  Future<void> loadNearby({
    required double latitude,
    required double longitude,
    String? type,
  }) async {
    isLoadingNearby = true;
    notifyListeners();
    final r = await CustomerMapsService.getNearbyProducers(
      latitude: latitude,
      longitude: longitude,
      type: type,
    );
    isLoadingNearby = false;
    if (r.success) {
      final dataField = r.data?['data'];
      List raw;
      if (dataField is List) {
        raw = dataField;
      } else if (dataField is Map) {
        // type=ALL returns { producers: [...], friends: [...] }
        raw = (dataField['producers'] as List?) ?? [];
      } else {
        raw = [];
      }
      nearbyPlaces = raw.map((e) => e as Map<String, dynamic>).toList();
    }
    notifyListeners();
  }

  // ─────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────

  List<Map<String, dynamic>> bookingsByStatus(String status) =>
      bookings.where((b) => (b['status'] as String?)?.toLowerCase() == status.toLowerCase()).toList();
}
