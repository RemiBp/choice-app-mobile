
import 'dart:io';

import 'package:flutter/material.dart';
import '../../../data/services/event_service.dart';
import '../../../data/services/onboarding_service.dart';
import 'package:path/path.dart' as p;

class EventProvider extends ChangeNotifier {
  final EventService _service = EventService();
  final OnboardingService _onboardingService = OnboardingService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<dynamic> _eventTypes = [];
  List<dynamic> get eventTypes => _eventTypes;

  List<dynamic> _myEvents = [];
  List<dynamic> get myEvents => _myEvents;

  Future<void> fetchEventTypes() async {
    _isLoading = true;
    notifyListeners();
    try {
      _eventTypes = await _service.getEventTypes();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMyEvents() async {
    _isLoading = true;
    notifyListeners();
    try {
      _myEvents = await _service.getMyEvents();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createEvent({
    required String title,
    String? description,
    String? venueName,
    required String location,
    required double pricePerGuest,
    required int maxCapacity,
    required String date,
    required String startTime,
    required String endTime,
    required List<File> eventImages,
    int? eventTypeId,
    required String serviceType, // 'Restaurant' or 'Leisure'
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      // 1. Upload Images
      List<String> uploadedImageUrls = [];
      if (eventImages.isNotEmpty) {
        final List<Map<String, String>> fileData = eventImages.map((file) {
          final extension = p.extension(file.path).replaceAll('.', '');
          return {
            'fileName': p.basename(file.path),
            'contentType': 'image/$extension',
            'folderName': 'event_images',
          };
        }).toList();

        final presignedData = await _onboardingService.getPreSignedUrls(fileData);

        for (int i = 0; i < eventImages.length; i++) {
          final url = presignedData[i]['url'];
          final keyName = presignedData[i]['keyName'];
          final contentType = fileData[i]['contentType']!;
          await _onboardingService.uploadFileToS3(url, eventImages[i], contentType);
          uploadedImageUrls.add('https://choice-app-bucket.s3.amazonaws.com/$keyName');
        }
      }

      // 2. Create Event
      await _service.createEvent(
        title: title,
        description: description,
        venueName: venueName,
        location: location,
        pricePerGuest: pricePerGuest,
        maxCapacity: maxCapacity,
        date: date,
        startTime: startTime,
        endTime: endTime,
        eventImages: uploadedImageUrls,
        eventTypeId: eventTypeId,
        serviceType: serviceType,
        status: 'active',
      );
      
      await fetchMyEvents();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("Error creating event: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}