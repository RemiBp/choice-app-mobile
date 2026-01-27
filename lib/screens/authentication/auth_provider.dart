import 'package:choice_app/common/utils.dart';
import 'package:choice_app/data/services/api_service.dart';
import 'package:choice_app/userRole/role_provider.dart';
import 'package:choice_app/userRole/user_role.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  bool loginPassVisibility = false;
  bool signupPassVisibility = false;

  final AuthRepository _authRepository = AuthRepository();
  bool isLoading = false;
  String? errorMessage;

  UserRole? _userRole;
  UserRole? get userRole => _userRole;

  Future<bool> login(String email, String password, RoleProvider roleProvider) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _authRepository.login(email, password, roleProvider.role);
      
      // Actual response structure: { user: { role: { name: 'user' } }, accessToken: '...' }
      // The repository returns response.data directly.
      
      final token = response['accessToken'];
      // Handle role: could be a String or an Object {name: "user"}
      final userObj = response['user'];
      final roleObj = userObj?['role'];
      
      String? roleStr;
      if (roleObj is Map) {
        roleStr = roleObj['name'];
      } else if (roleObj is String) {
        roleStr = roleObj;
      }

      if (token != null) {
        await PreferenceUtils.setToken(token);
        ApiService().setAuthToken(token);
      } else {
        debugPrint("Warning: No access token found in login response");
      }

      if (roleStr != null) {
        _userRole = _mapStringToRole(roleStr);
        roleProvider.setRole(_userRole!);
        await PreferenceUtils.setString("user_role", roleStr);
      } else {
        debugPrint("Warning: No role found in login response");
        // Fallback or critical error?
        // Default to user?
        _userRole = UserRole.user; 
      }

      debugPrint("Login Success: $response");
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(Map<String, dynamic> data) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _authRepository.signup(data);
      debugPrint("Signup Success: $response");
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  UserRole _mapStringToRole(String role) {
    switch (role.toLowerCase()) {
      case 'restaurant':
        return UserRole.restaurant;
      case 'wellness':
        return UserRole.wellness;
      case 'leisure':
        return UserRole.leisure;
      case 'user':
        return UserRole.user;
      default:
        return UserRole.user;
    }
  }

  toggleLoginPassVisibility() {
    loginPassVisibility = !loginPassVisibility;
    notifyListeners();
  }

  toggleSignupPassVisibility() {
    signupPassVisibility = !signupPassVisibility;
    notifyListeners();
  }
}