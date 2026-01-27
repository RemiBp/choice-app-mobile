
import 'package:flutter/material.dart';
import '../../../data/services/interest_service.dart';
import '../../../data/services/user_service.dart';

class InterestProvider extends ChangeNotifier {
  final InterestService _service = InterestService();
  final UserService _userService = UserService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<dynamic> _myInterests = [];
  List<dynamic> get myInterests => _myInterests;

  List<dynamic> _invites = [];
  List<dynamic> get invites => _invites;

  List<dynamic> _friends = [];
  List<dynamic> get friends => _friends;

  List<dynamic> _producerSlots = [];
  List<dynamic> get producerSlots => _producerSlots;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchMyInterests() async {
    setLoading(true);
    try {
      _myInterests = await _service.getMyInterests();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchInvites() async {
    setLoading(true);
    try {
      _invites = await _service.getInvites();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchProducerSlots(int producerId) async {
    setLoading(true);
    try {
      _producerSlots = await _service.getProducerSlots(producerId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchFriends() async {
    setLoading(true);
    try {
      _friends = await _userService.getMyFriends();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      setLoading(false);
    }
  }

  Future<void> searchFriends(String query) async {
    setLoading(true);
    try {
      _friends = await _userService.searchUsers(query);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      setLoading(false);
    }
  }

  Future<bool> createInterest({
    required int producerId,
    required String date,
    required String timeSlot,
    String? message,
    List<int>? inviteeIds,
  }) async {
    setLoading(true);
    try {
      final res = await _service.createInterest(
        producerId: producerId,
        date: date,
        timeSlot: timeSlot,
        message: message,
        inviteeIds: inviteeIds,
      );
      return res['success'] ?? true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<void> respondToInvite(int interestId, bool accept) async {
    setLoading(true);
    try {
      await _service.respondToInvite(interestId, accept);
      await fetchInvites(); // Refresh
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      setLoading(false);
    }
  }
}
