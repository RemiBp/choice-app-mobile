import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:flutter_timezone/flutter_timezone.dart';

class TimezoneHelper {
  static bool _initialized = false;
  static String? _ianaTimeZone; // Store the result

  // Call this once in your app startup
  static void initialize() {
    if (!_initialized) {
      tzdata.initializeTimeZones();
      _initialized = true;
    }
  }

  // New asynchronous method to fetch the IANA timezone name
  static Future<String> fetchCurrentTimeZone() async {
    initialize();
    if (_ianaTimeZone != null) {
      return _ianaTimeZone!; // Return cached result if available
    }

    try {
      final TimezoneInfo timezoneInfo = await FlutterTimezone.getLocalTimezone();
      final String ianaTimeZoneName = timezoneInfo.identifier;

      final location = tz.getLocation(ianaTimeZoneName);
      tz.setLocalLocation(location);

      _ianaTimeZone = ianaTimeZoneName; // Cache the result
      return ianaTimeZoneName;

    } catch (e) {
      // Fallback in case of platform error
      print("Error fetching IANA timezone: $e");
      _ianaTimeZone = 'UTC';
      return 'UTC';
    }
  }

  // For quick, non-Future access (only call AFTER fetchCurrentTimeZone is complete)
  static String? get cachedTimeZone => _ianaTimeZone;
}