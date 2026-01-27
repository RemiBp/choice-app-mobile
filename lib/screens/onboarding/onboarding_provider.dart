import 'package:flutter/material.dart';
import '../../data/models/cuisine_type.dart';
import '../../../data/services/onboarding_service.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

class OnboardingProvider extends ChangeNotifier {
  final OnboardingService _service = OnboardingService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<CuisineType> _cuisineTypes = [];
  List<CuisineType> get cuisineTypes => _cuisineTypes;

  List<CuisineType> _serviceTypes = [];
  List<CuisineType> get serviceTypes => _serviceTypes;

  List<dynamic> _menu = [];
  List<dynamic> get menu => _menu;

  List<dynamic> _restaurantImages = [];
  List<dynamic> get restaurantImages => _restaurantImages;

  List<dynamic> _operationalHours = [];
  List<dynamic> get operationalHours => _operationalHours;

  int? _slotDuration;
  int? get slotDuration => _slotDuration;

  List<dynamic> _producerSlots = [];
  List<dynamic> get producerSlots => _producerSlots;

  List<dynamic> _paymentMethods = [];
  List<dynamic> get paymentMethods => _paymentMethods;

  List<dynamic> _slotsByDate = [];
  List<dynamic> get slotsByDate => _slotsByDate;

  List<dynamic> _unavailableSlots = [];
  List<dynamic> get unavailableSlots => _unavailableSlots;

  Future<void> fetchCuisineTypes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _cuisineTypes = await _service.getCuisineTypes();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveCuisineType(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _service.setCuisineType(id);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchServiceTypes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _serviceTypes = await _service.getAllServiceTypes();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveServiceTypes(List<int> ids) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _service.setServiceTypes(ids);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMenu() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _menu = await _service.getMenu();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addMenuCategory(String name) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _service.addMenuCategory(name);
      await fetchMenu();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addMenuDish({
    required String name,
    required double price,
    required int categoryId,
    String? description,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _service.addMenuDish(
        name: name,
        price: price,
        categoryId: categoryId,
        description: description,
      );
      await fetchMenu();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRestaurantImages() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _restaurantImages = await _service.getRestaurantImages();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> uploadRestaurantImages(List<File> files) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      // 1. Get Presigned URLs
      final List<Map<String, String>> fileData = files.map((file) {
        final extension = p.extension(file.path).replaceAll('.', '');
        return {
          'fileName': p.basename(file.path),
          'contentType': 'image/$extension',
          'folderName': 'restaurant_images',
        };
      }).toList();

      final presignedData = await _service.getPreSignedUrls(fileData);

      // 2. Upload to S3
      final List<String> uploadedUrls = [];
      for (int i = 0; i < files.length; i++) {
        final url = presignedData[i]['url'];
        final keyName = presignedData[i]['keyName'];
        final contentType = fileData[i]['contentType']!;
        await _service.uploadFileToS3(url, files[i], contentType);
        uploadedUrls.add('https://choice-app-bucket.s3.amazonaws.com/$keyName'); // Adjust based on your bucket URL
      }

      // 3. Save to Backend
      await _service.uploadRestaurantImages(
        uploadedUrls.map((url) => {'url': url, 'isMain': false}).toList(),
      );

      await fetchRestaurantImages();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> setMainImage(int imageId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _service.setMainImage(imageId);
      await fetchRestaurantImages();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteRestaurantImage(int imageId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _service.deleteRestaurantImage(imageId);
      await fetchRestaurantImages();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Business Hours
  Future<void> fetchOperationalHours() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _operationalHours = await _service.getOperationalHours();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveOperationalHours(List<Map<String, dynamic>> hours) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _service.setOperationalHours(hours);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Slots
  Future<void> fetchSlotDuration() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _slotDuration = await _service.getSlotDuration();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveSlotDuration(int duration) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _service.setSlotDuration(duration);
      _slotDuration = duration;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProducerSlots() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _producerSlots = await _service.getProducerSlots();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateRestaurantSlots(List<Map<String, dynamic>> slots) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _service.updateRestaurantSlots(slots);
      await fetchProducerSlots();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Payment Methods
  Future<void> fetchPaymentMethods() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _paymentMethods = await _service.getPaymentMethods();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> savePaymentMethods(List<int> paymentMethodIds) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _service.addPaymentMethods(paymentMethodIds);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Unavailability
  Future<void> fetchSlotsByDate(String date) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _slotsByDate = await _service.getSlotsByDate(date);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addUnavailableSlot(String date, List<int> slotIds) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _service.addUnavailableSlot(date, slotIds);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUnavailableSlots(String timezone) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _unavailableSlots = await _service.getUnavailableSlots(timezone);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Documents
  bool _isDocsUploaded = false;
  bool get isDocsUploaded => _isDocsUploaded;

  Future<void> fetchOnBoardingDetail() async {
    // Only fetch silently or with loading depending on usage.
    // Assuming this is called to check status.
    try {
      final detail = await _service.getOnBoardingDetail();
      _isDocsUploaded = detail['addDocuments'] == true;
      notifyListeners();
    } catch (e) {
      print("Error fetching onboarding detail: $e");
    }
  }

  Future<bool> uploadDocuments(File hospitality, File tourism) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final files = [hospitality, tourism];
       final List<Map<String, String>> fileData = files.map((file) {
        final extension = p.extension(file.path).replaceAll('.', '');
        return {
          'fileName': p.basename(file.path),
          'contentType': extension == 'pdf' ? 'application/pdf' : 'image/$extension',
          'folderName': 'restaurant_docs',
        };
      }).toList();

      final presignedData = await _service.getPreSignedUrls(fileData);

      final List<String> uploadedUrls = [];
      for (int i = 0; i < files.length; i++) {
        final url = presignedData[i]['url'];
        final keyName = presignedData[i]['keyName'];
        final contentType = fileData[i]['contentType']!;
        await _service.uploadFileToS3(url, files[i], contentType);
        uploadedUrls.add('https://choice-app-bucket.s3.amazonaws.com/$keyName');
      }

      await _service.uploadDocuments(
        hospitalityUrl: uploadedUrls[0],
        tourismUrl: uploadedUrls[1],
      );
      
      _isDocsUploaded = true;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
