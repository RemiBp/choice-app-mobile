import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../common/utils.dart';
import '../../res/strings.dart';

class LanguageSelectionProvider extends ChangeNotifier{
  String selectedLocal = '';

  Future<void> selectLocale(String locale) async {
    debugPrint("selectedLocal : $locale");
    await PreferenceUtils.setString(
      Strings.selectedLocale,
      locale,
    );
    selectedLocal = locale;
    notifyListeners();
  }


  String getLocale() {
    String locale = PreferenceUtils.getString(Strings.selectedLocale) ?? "";
    debugPrint("preference locale is : $locale");
    if (locale.trim().isEmpty) {
      String raw;
      if (kIsWeb) {
        raw = 'en';
      } else {
        raw = Platform.localeName;
      }
      final deviceLocale = raw.contains("_") ? raw.split("_")[0] : raw;
      debugPrint('local name is : $deviceLocale');
      locale = deviceLocale;
    }
    selectedLocal = locale;
    return selectedLocal;
  }

  Future<void> changeLocale(String locale) async {
    selectedLocal = locale;
    await PreferenceUtils.setString(Strings.selectedLocale, locale);
    notifyListeners();
  }


}