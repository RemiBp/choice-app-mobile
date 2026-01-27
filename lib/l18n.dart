import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';

import 'l10n/app_localizations_en.dart';

// AppLocalizations get al => _al!; // helper function to avoid typing '!' all the time -> Removed in favor of safe getter below
AppLocalizations _al = AppLocalizationsEn(); // global variable - package private by default, making it public-ish for this hack? 
// It is already public within the package (no underscore), wait it has underscore.
// Let's make it public setter.
set al(AppLocalizations value) {
  debugPrint("DEBUG: l18n setter called with $value");
  _al = value;
}

bool get rtlDirection =>_currentDirection!.name == "rtl";
TextDirection? _currentDirection;

class AppTranslations {
  static init(BuildContext context) {
    var loc = AppLocalizations.of(context);
    if (loc == null) {
      debugPrint("INFO: Localization lookup failed in current context. Using fallback (active: ${_al.localeName}).");
    } else {
      _al = loc;
    }
    _currentDirection = Directionality.of(context);
  }
}

AppLocalizations get al {
  return _al;
}