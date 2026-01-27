import 'dart:async' show Future;

import 'package:shared_preferences/shared_preferences.dart';

import '../res/strings.dart';

class PreferenceUtils {
  static String? userImage;
  var time = DateTime;

  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  static Future<SharedPreferences?> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance;
  }

  static String? getString(String key, [String? defValue]) {
    if (PreferenceUtils._prefsInstance != null) {
      return _prefsInstance?.getString(key) ?? defValue ?? "";
    } else {
      return null;
    }
  }

  static Future<bool> setString(String key, String value) async {
    var prefs = await _instance;

    return prefs.setString(key, value); //?? Future.value(null);
  }

  static Future<bool> setBool(String key, bool value) async {
    var prefs = await _instance;
    return prefs.setBool(key, value); //?? Future.value(null);
  }

  static bool getBool(String key, [bool? defValue]) {
    return _prefsInstance?.getBool(key) ?? defValue ?? false;
  }

  static Future<void> reload() async {
    var prefs = await _instance;
    return prefs.reload();
  }

  static Future<bool> setInt(String key, int value) async {
    var prefs = await _instance;

    return prefs.setInt(key, value); //?? Future.value(null);
  }

  static int getInt(String key, [int? defValue]) {
    return _prefsInstance?.getInt(key) ?? defValue ?? 0;
  }

  static String get userId {
    return _prefsInstance?.getInt(Strings.userId).toString() ?? "";
  }

  static String get name {
    return _prefsInstance?.getString(Strings.name) ?? "";
  }

  static String get email {
    return _prefsInstance?.getString(Strings.email) ?? "";
  }

  static String get phone {
    return _prefsInstance?.getString(Strings.phoneNumber) ?? "";
  }

  static String get location {
    return _prefsInstance?.getString(Strings.cityName) ?? "";
  }

  static String get bio {
    return _prefsInstance?.getString(Strings.bio) ?? "";
  }

  static String get dob {
    return _prefsInstance?.getString(Strings.dateOfBirth) ?? "";
  }

  static String get role {
    return _prefsInstance?.getString(Strings.userRole) ?? "";
  }

  static String get profilePicture {
    final image = _prefsInstance?.getString(Strings.profilePicture);
    return image == "http://18.136.223.180/storage" ? "" : image ?? "";
  }

  static bool get isSubscriber {
    return _prefsInstance?.getString(Strings.subscriptionStatus) == "Paid";
  }

  static String get token {
    return _prefsInstance?.getString(Strings.accessToken) ?? "";
  }

  static Future<bool> setToken(String value) async {
    var prefs = await _instance;
    return prefs.setString(Strings.accessToken, value);
  }

  static clearPreferences() {
    _prefsInstance?.clear();
  }
}
