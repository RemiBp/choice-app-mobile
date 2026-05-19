import 'package:flutter/material.dart';
import '../services/producer_service.dart';
import '../services/auth_service.dart';

class ProducerProvider extends ChangeNotifier {
  // ── Profile ───────────────────────────────────
  Map<String, dynamic>? profile;
  bool isLoadingProfile = false;

  // ── Posts / Feed ─────────────────────────────
  List<Map<String, dynamic>> posts = [];
  bool isLoadingPosts = false;
  bool hasMorePosts = true;
  int _postPage = 1;

  // ── Events ────────────────────────────────────
  List<Map<String, dynamic>> events = [];
  bool isLoadingEvents = false;

  // ── Bookings ──────────────────────────────────
  List<Map<String, dynamic>> bookings = [];
  bool isLoadingBookings = false;

  // ── Dashboard ─────────────────────────────────
  Map<String, dynamic>? dashboardOverview;
  bool isLoadingDashboard = false;

  // ── Notifications ─────────────────────────────
  List<Map<String, dynamic>> notifications = [];

  String? error;

  // ─────────────────────────────────────────────
  // Profile
  // ─────────────────────────────────────────────

  Future<void> loadProfile() async {
    isLoadingProfile = true;
    error = null;
    notifyListeners();
    final r = await ProducerProfileService.getProfile();
    isLoadingProfile = false;
    if (r.success) {
      profile = r.data?['data'] as Map<String, dynamic>? ?? r.data;
    } else {
      error = r.message;
    }
    notifyListeners();
  }

  Future<AuthResult> updateProfile(Map<String, dynamic> body) async {
    final r = await ProducerProfileService.updateProfile(body);
    if (r.success) await loadProfile();
    return r;
  }

  Future<AuthResult> changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return ProducerProfileService.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  Future<void> loadNotifications() async {
    final r = await ProducerProfileService.getNotifications();
    if (r.success) {
      final raw = r.data?['data'];
      notifications = raw is List
          ? raw.map((e) => e as Map<String, dynamic>).toList()
          : [];
      notifyListeners();
    }
  }

  // ─────────────────────────────────────────────
  // Posts
  // ─────────────────────────────────────────────

  Future<void> loadPosts({bool refresh = false}) async {
    if (refresh) {
      _postPage = 1;
      posts = [];
      hasMorePosts = true;
    }
    if (!hasMorePosts || isLoadingPosts) return;
    isLoadingPosts = true;
    notifyListeners();

    final r = await ProducerPostService.getUserPosts(page: _postPage);
    isLoadingPosts = false;

    if (r.success) {
      final raw = r.data?['data'];
      final newItems = raw is List
          ? raw.map((e) => e as Map<String, dynamic>).toList()
          : <Map<String, dynamic>>[];
      posts.addAll(newItems);
      hasMorePosts = newItems.isNotEmpty;
      _postPage++;
    }
    notifyListeners();
  }

  Future<AuthResult> createPost(Map<String, dynamic> body) async {
    final r = await ProducerPostService.createProducerPost(body);
    if (r.success) await loadPosts(refresh: true);
    return r;
  }

  Future<void> toggleLike(int postId) async {
    await ProducerPostService.toggleLike(postId);
    // Optimistic: flip liked state locally
    final idx = posts.indexWhere((p) => p['id'] == postId);
    if (idx != -1) {
      final cur = posts[idx]['isLiked'] as bool? ?? false;
      posts[idx] = {...posts[idx], 'isLiked': !cur};
      notifyListeners();
    }
  }

  Future<void> deletePost(int postId) async {
    await ProducerPostService.deletePost(postId);
    posts.removeWhere((p) => p['id'] == postId);
    notifyListeners();
  }

  // ─────────────────────────────────────────────
  // Events
  // ─────────────────────────────────────────────

  Future<void> loadEvents() async {
    isLoadingEvents = true;
    notifyListeners();
    final r = await ProducerEventService.getMyEvents();
    isLoadingEvents = false;
    if (r.success) {
      final raw = r.data?['data'];
      events = raw is List
          ? raw.map((e) => e as Map<String, dynamic>).toList()
          : [];
    }
    notifyListeners();
  }

  Future<AuthResult> createEvent(Map<String, dynamic> body) async {
    final r = await ProducerEventService.createEvent(body);
    if (r.success) await loadEvents();
    return r;
  }

  Future<AuthResult> updateEvent(int eventId, Map<String, dynamic> body) async {
    final r = await ProducerEventService.updateEvent(eventId, body);
    if (r.success) await loadEvents();
    return r;
  }

  Future<AuthResult> deleteEvent(int eventId) async {
    final r = await ProducerEventService.deleteEvent(eventId);
    if (r.success) events.removeWhere((e) => e['id'] == eventId);
    notifyListeners();
    return r;
  }

  // ─────────────────────────────────────────────
  // Bookings
  // ─────────────────────────────────────────────

  Future<void> loadBookings({String? status}) async {
    isLoadingBookings = true;
    notifyListeners();
    final r = await ProducerBookingService.getBookings(status: status);
    isLoadingBookings = false;
    if (r.success) {
      final raw = r.data?['data'];
      bookings = raw is List
          ? raw.map((e) => e as Map<String, dynamic>).toList()
          : [];
    }
    notifyListeners();
  }

  Future<AuthResult> cancelBooking(int bookingId) async {
    final r = await ProducerBookingService.cancelBooking(bookingId);
    if (r.success) await loadBookings();
    return r;
  }

  Future<AuthResult> checkIn(int bookingId) async {
    final r = await ProducerBookingService.checkIn(bookingId);
    if (r.success) await loadBookings();
    return r;
  }

  // ─────────────────────────────────────────────
  // Dashboard
  // ─────────────────────────────────────────────

  Future<void> loadDashboard() async {
    isLoadingDashboard = true;
    notifyListeners();
    final r = await ProducerDashboardService.getOverview();
    isLoadingDashboard = false;
    if (r.success) {
      dashboardOverview = r.data?['data'] as Map<String, dynamic>? ?? r.data;
    }
    notifyListeners();
  }
}
