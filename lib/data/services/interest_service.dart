
import 'package:choice_app/data/services/api_service.dart';
import 'package:dio/dio.dart';

class InterestService {
  final Dio _dio = ApiService().client;

  // Create Interest
  Future<Map<String, dynamic>> createInterest({
    required int producerId,
    required String date,
    required String timeSlot,
    String? message,
    List<int>? inviteeIds,
  }) async {
    try {
      final response = await _dio.post('/api/app/interest/createInterest', data: {
        'producerId': producerId,
        'date': date,
        'timeSlot': timeSlot,
        'message': message,
        'inviteeIds': inviteeIds ?? [],
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Get Producer Slots (to see availability)
  Future<List<dynamic>> getProducerSlots(int producerId) async {
    try {
      final response = await _dio.get('/api/app/interest/producer-slots/$producerId');
      return response.data['data'] ?? [];
    } catch (e) {
      rethrow;
    }
  }

  // Get My Interests (Sent)
  Future<List<dynamic>> getMyInterests() async {
    try {
      final response = await _dio.get('/api/app/interest/myInterests');
      return response.data['data'] ?? [];
    } catch (e) {
      rethrow;
    }
  }

  // Get Invites (Received)
  Future<List<dynamic>> getInvites() async {
    try {
      final response = await _dio.get('/api/app/interest/getInvited');
      return response.data['data'] ?? [];
    } catch (e) {
      rethrow;
    }
  }

  // Respond to Invite
  Future<void> respondToInvite(int interestId, bool accept) async {
    try {
      final endpoint = accept ? 'acceptInterestInvite' : 'declineInterestInvite';
      await _dio.post('/api/app/interest/$endpoint', data: {
        'interestId': interestId,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Suggest New Time
  Future<void> suggestNewTime({
    required int interestId,
    required String newDate,
    required String newTimeSlot,
    String? reason,
  }) async {
    try {
      await _dio.post('/api/app/interest/suggestNewTime', data: {
        'interestId': interestId,
        'newDate': newDate,
        'newTimeSlot': newTimeSlot,
        'reason': reason,
      });
    } catch (e) {
      rethrow;
    }
  }
}
