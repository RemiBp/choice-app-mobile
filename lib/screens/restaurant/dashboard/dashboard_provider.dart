import 'package:flutter/material.dart';
import '../../../data/services/dashboard_service.dart';

class DashboardProvider extends ChangeNotifier {
  final DashboardService _service = DashboardService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Map<String, dynamic>? _overview;
  Map<String, dynamic>? get overview => _overview;

  Map<String, dynamic>? _userInsights;
  Map<String, dynamic>? get userInsights => _userInsights;

  Map<String, dynamic>? _trends;
  Map<String, dynamic>? get trends => _trends;

  Map<String, dynamic>? _ratings;
  Map<String, dynamic>? get ratings => _ratings;

  Map<String, dynamic>? _feedback;
  Map<String, dynamic>? get feedback => _feedback;

  Map<String, dynamic>? _benchmark;
  Map<String, dynamic>? get benchmark => _benchmark;

  Map<String, dynamic>? _bookingTrends;
  Map<String, dynamic>? get bookingTrends => _bookingTrends;
  bool _isBookingLoading = false;
  bool get isBookingLoading => _isBookingLoading;

  Map<String, dynamic>? _customerTrends;
  Map<String, dynamic>? get customerTrends => _customerTrends;
  bool _isCustomerLoading = false;
  bool get isCustomerLoading => _isCustomerLoading;

  Future<void> fetchDashboardData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _service.getOverview(),
        _service.getUserInsights(),
        _service.getRatings(),
        _service.getBenchmark(),
      ]);

      _overview = results[0];
      _userInsights = results[1];
      _ratings = results[2];
      _benchmark = results[3];
      
      // Fetch initial trends
      fetchBookingTrends('week'); 
      fetchCustomerTrends('week');

    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBookingTrends(String period) async {
    _isBookingLoading = true;
    notifyListeners();
    try {
      // Calculate from/to based on period if needed, or backend handles it
      // For now assuming backend accepts 'period' or we send dates.
      // adapting to existing service which takes metric, from, to.
      // Let's assume we map 'week' -> last 7 days.
      
      String? from;
      String? to;
      final now = DateTime.now();
      if (period == 'week') {
         from = now.subtract(const Duration(days: 7)).toIso8601String();
      } else if (period == 'month') {
         from = now.subtract(const Duration(days: 30)).toIso8601String();
      }
      to = now.toIso8601String();

      _bookingTrends = await _service.getTrends(metric: 'bookings', from: from, to: to);
    } catch (e) {
      print("Error fetching booking trends: $e");
    } finally {
      _isBookingLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> fetchCustomerTrends(String period) async {
    _isCustomerLoading = true;
    notifyListeners();
    try {
      String? from;
      String? to;
      final now = DateTime.now();
      if (period == 'week') {
         from = now.subtract(const Duration(days: 7)).toIso8601String();
      } else if (period == 'month') {
         from = now.subtract(const Duration(days: 30)).toIso8601String();
      }
      to = now.toIso8601String();

      _customerTrends = await _service.getTrends(metric: 'customers', from: from, to: to);
    } catch (e) {
      print("Error fetching customer trends: $e");
    } finally {
      _isCustomerLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTrends(String metric, {String? from, String? to}) async {
    try {
      _trends = await _service.getTrends(metric: metric, from: from, to: to);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
