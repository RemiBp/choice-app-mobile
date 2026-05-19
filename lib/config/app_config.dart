import 'package:flutter/foundation.dart' show kIsWeb;

class AppConfig {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:6543';
    return 'http://10.0.2.2:6543';
  }

  // Producer
  static const String producerAuthPath = '/api/producer/auth';
  static const String producerProfilePath = '/api/producer/profile';
  static const String producerPostPath = '/api/producer/post';
  static const String producerEventPath = '/api/producer/event';
  static const String producerBookingPath = '/api/producer/booking';
  static const String producerDashboardPath = '/api/producer/dashboard';
  static const String producerMapsPath = '/api/producer/maps';

  // Customer (app)
  static const String appAuthPath = '/api/app/auth';
  static const String appProfilePath = '/api/app/profile';
  static const String appBookingPath = '/api/app/booking';
  static const String appMapsPath = '/api/app/maps';
  static const String appPostPath = '/api/app/post';
  static const String appInterestPath = '/api/app/interest';
  static const String appCopilotPath = '/api/app/copilot';
}
