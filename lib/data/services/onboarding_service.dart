import 'package:choice_app/data/models/cuisine_type.dart';
import 'package:choice_app/data/services/api_service.dart';
import 'package:dio/dio.dart';
import 'dart:io';

class OnboardingService {
  final Dio _dio = ApiService().client;

  // Cuisine
  Future<List<CuisineType>> getCuisineTypes() async {
    try {
      final response = await _dio.get('/api/producer/profile/getCuisineTypes');
      final List<dynamic> list = response.data['data']['cuisineTypes'] ?? [];
      return list.map((e) => CuisineType.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setCuisineType(int cuisineTypeId) async {
    try {
      await _dio.post('/api/producer/profile/setCuisineType', data: {
        'cuisineTypeId': cuisineTypeId,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Services (Wellness)
  Future<List<CuisineType>> getAllServiceTypes() async {
    try {
      final response = await _dio.get('/api/producer/profile/getAllServiceType');
      final List<dynamic> list = response.data['eventTypes'] ?? [];
      return list.map((e) => CuisineType.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setServiceTypes(List<int> serviceTypeIds) async {
    try {
      await _dio.post('/api/producer/profile/setServiceType', data: {
        'serviceTypeIds': serviceTypeIds,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Gallery / Restaurant Images
  Future<List<dynamic>> getPreSignedUrls(List<Map<String, String>> files) async {
    try {
      final response = await _dio.post('/api/producer/profile/getMultiplePreSignedUrl', data: {
        'files': files,
      });
      return response.data['data'] ?? [];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> uploadFileToS3(String url, File file, String contentType) async {
    try {
      await Dio().put(
        url,
        data: file.openRead(),
        options: Options(
          headers: {
            'Content-Type': contentType,
            'Content-Length': file.lengthSync(),
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> uploadRestaurantImages(List<Map<String, dynamic>> images) async {
    try {
      await _dio.post('/api/producer/profile/uploadRestaurantImages', data: {
        'images': images,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getRestaurantImages() async {
    try {
      final response = await _dio.get('/api/producer/profile/getRestaurantImages');
      return response.data['images'] ?? [];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setMainImage(int imageId) async {
    try {
      await _dio.post('/api/producer/profile/setMainImage', data: {
        'imageId': imageId,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteRestaurantImage(int imageId) async {
    try {
      await _dio.post('/api/producer/profile/deleteRestaurantImage', data: {
        'imageId': imageId,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Menu
  Future<void> addMenuCategory(String categoryName) async {
    try {
      await _dio.post('/api/producer/profile/addMenuCategory', data: {
        'menuCategory': categoryName,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addMenuDish({
    required String name,
    required double price,
    required int categoryId,
    String? description,
  }) async {
    try {
      await _dio.post('/api/producer/profile/addMenuDish', data: {
        'name': name,
        'price': price,
        'categoryId': categoryId,
        'description': description ?? '',
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getMenu() async {
    try {
      final response = await _dio.get('/api/producer/profile/getMenu');
      return response.data['menu'] ?? [];
    } catch (e) {
      rethrow;
    }
  }

  // Business Hours
  Future<List<dynamic>> getOperationalHours() async {
    try {
      final response = await _dio.get('/api/producer/profile/getOperationalHours');
      return response.data['data'] ?? [];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setOperationalHours(List<Map<String, dynamic>> hours) async {
    try {
      await _dio.post('/api/producer/profile/setOperationalHours', data: {
        'hours': hours,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Slots
  Future<int?> getSlotDuration() async {
    try {
      final response = await _dio.get('/api/producer/profile/getSlotDuration');
      return response.data['slotDuration'] != null ? int.tryParse(response.data['slotDuration'].toString()) : null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setSlotDuration(int duration) async {
    try {
      await _dio.post('/api/producer/profile/setSlotDuration', data: {
        'slotDuration': duration,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getProducerSlots() async {
    try {
      final response = await _dio.get('/api/producer/profile/getProducerSlots');
      return response.data['data'] ?? [];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateRestaurantSlots(List<Map<String, dynamic>> slots) async {
    try {
      await _dio.post('/api/producer/profile/updateRestaurantSlots', data: {
        'slots': slots,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Payment Methods
  Future<List<dynamic>> getPaymentMethods() async {
    try {
      final response = await _dio.get('/api/producer/profile/getPaymentMethods');
      return response.data['paymentMethods'] ?? [];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addPaymentMethods(List<int> paymentMethodIds) async {
    try {
      await _dio.post('/api/producer/profile/addPaymentMethods', data: {
        'paymentMethods': paymentMethodIds,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Unavailability (Specific Dates)
  Future<List<dynamic>> getSlotsByDate(String date) async {
    try {
      final response = await _dio.post('/api/producer/profile/getRestaurantSlotsByDate', data: {
        'date': date,
      });
      return response.data['data'] ?? [];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addUnavailableSlot(String date, List<int> slotIds) async {
    try {
      await _dio.post('/api/producer/profile/addUnavailableSlot', data: {
        'date': date,
        'slotIds': slotIds,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getUnavailableSlots(String timezone) async {
    try {
      final response = await _dio.get('/api/producer/profile/getUnavailableSlots', queryParameters: {
        'timeZone': timezone,
      });
      return response.data['data'] ?? [];
    } catch (e) {
      rethrow;
    }
  }

  // Documents & Onboarding Detail
  Future<Map<String, dynamic>> getOnBoardingDetail() async {
    try {
      final response = await _dio.get('/api/producer/profile/onBoardingDetail');
      return response.data['onBoardingDetail'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  Future<void> uploadDocuments({required String hospitalityUrl, required String tourismUrl}) async {
    try {
      await _dio.post('/api/producer/profile/uploadDocuments', data: {
        'certificateOfHospitality': hospitalityUrl,
        'certificateOfTourism': tourismUrl,
      });
    } catch (e) {
      rethrow;
    }
  }
}
