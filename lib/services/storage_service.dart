import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _nativeStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userRoleKey = 'user_role';
  static const _userEmailKey = 'user_email';

  static Future<void> _write(String key, String? value) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      if (value == null) {
        await prefs.remove(key);
      } else {
        await prefs.setString(key, value);
      }
    } else {
      await _nativeStorage.write(key: key, value: value);
    }
  }

  static Future<String?> _read(String key) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    }
    return _nativeStorage.read(key: key);
  }

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _write(_accessTokenKey, accessToken),
      _write(_refreshTokenKey, refreshToken),
    ]);
  }

  static Future<String?> getAccessToken() => _read(_accessTokenKey);

  static Future<String?> getRefreshToken() => _read(_refreshTokenKey);

  static Future<void> saveUserRole(String role) => _write(_userRoleKey, role);

  static Future<String?> getUserRole() => _read(_userRoleKey);

  static Future<void> saveUserEmail(String email) =>
      _write(_userEmailKey, email);

  static Future<String?> getUserEmail() => _read(_userEmailKey);

  static Future<void> clearAll() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.remove(_accessTokenKey),
        prefs.remove(_refreshTokenKey),
        prefs.remove(_userRoleKey),
        prefs.remove(_userEmailKey),
      ]);
    } else {
      await _nativeStorage.deleteAll();
    }
  }
}
