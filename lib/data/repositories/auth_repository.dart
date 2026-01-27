import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:choice_app/userRole/user_role.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> login(String email, String password, UserRole role) async {
    try {
      final endpoint = role == UserRole.user ? '/api/app/auth/login' : '/api/producer/auth/login';
      final response = await _apiService.client.post(endpoint, data: {
        'email': email,
        'password': password,
        'deviceId': 'mobile-device-id-123', // Hardcoded for now as package is missing
      });
      return response.data;
    } on DioException catch (e) {
      debugPrint("Login Error: ${e.response?.data ?? e.message}");
      throw e.response?.data['message'] ?? 'Login failed';
    } catch (e) {
      throw 'An unexpected error occurred';
    }
  }

  Future<Map<String, dynamic>> signup(Map<String, dynamic> data) async {
     try {
      final response = await _apiService.client.post('/api/producer/auth/signup', data: data);
      return response.data;
    } on DioException catch (e) {
      debugPrint("Signup Error: ${e.response?.data ?? e.message}");
      throw e.response?.data['message'] ?? 'Signup failed';
    } catch (e) {
      throw 'An unexpected error occurred';
    }
  }
}
