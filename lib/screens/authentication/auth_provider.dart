import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  // UI visibility toggles
  bool loginPassVisibility = false;
  bool signupPassVisibility = false;

  // Loading + error state
  bool isLoading = false;
  String? errorMessage;

  // Persisted after successful register/forgot-password for the OTP screen
  String? pendingEmail;
  bool isForgotPasswordFlow = false;

  void toggleLoginPassVisibility() {
    loginPassVisibility = !loginPassVisibility;
    notifyListeners();
  }

  void toggleSignupPassVisibility() {
    signupPassVisibility = !signupPassVisibility;
    notifyListeners();
  }

  void setLoading(bool value) {
    isLoading = value;
    errorMessage = null;
    notifyListeners();
  }

  void setError(String? msg) {
    isLoading = false;
    errorMessage = msg;
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  void setPendingEmail(String email, {bool forgotFlow = false}) {
    pendingEmail = email;
    isForgotPasswordFlow = forgotFlow;
    notifyListeners();
  }
}
