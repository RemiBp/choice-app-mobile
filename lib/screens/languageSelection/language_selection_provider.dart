import 'dart:io';

import 'package:flutter/material.dart';

import '../../common/utils.dart';
import '../../res/strings.dart';

class LanguageSelectionProvider extends ChangeNotifier{
  String selectedLocal = '';

  LanguageSelectionProvider(){
    debugPrint("Constructor Called");
   getLocale();
  }

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
      final deviceLocale = Platform.localeName.contains("_")
          ? Platform.localeName.split("_")[0]
          : Platform.localeName;
      debugPrint('local name is : $deviceLocale');
      locale = deviceLocale;
    }
    selectedLocal = locale;
    return selectedLocal;
  }

  Future<void> changeLocale(String locale) async {
    debugPrint('Selected Local $selectedLocal');
    selectedLocal = locale;
    debugPrint('Selected Local $selectedLocal');

    await PreferenceUtils.setString(Strings.selectedLocale, locale);
    notifyListeners();
  }


}