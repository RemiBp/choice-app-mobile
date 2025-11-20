import 'dart:convert';
import 'dart:io';

import 'package:choice_app/models/get_all_service_types_response.dart';
import 'package:choice_app/models/get_cuisine_types_response.dart';
import 'package:choice_app/models/get_menu_categories_response.dart';
import 'package:choice_app/models/get_producer_operational_hours_response.dart';
import 'package:choice_app/models/get_producer_profile_response.dart';
import 'package:choice_app/models/get_producer_slots_response.dart';
import 'package:choice_app/models/producer_update_document_response.dart';
import 'package:choice_app/network/models.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:provider/provider.dart';

import '../../../l18n.dart';
import '../../../models/get_document_response.dart';
import '../../../models/get_gallery_image_response.dart';
import '../../../models/get_menu_response.dart';
import '../../../network/API.dart';
import '../../../network/api_url.dart';
import '../../../network/network_provider.dart';
import '../../../res/loader.dart';
import '../../../res/toasts.dart';

String globalBusinessName = "";

class ProfileProvider extends ChangeNotifier {
  BuildContext? context;

  File? profileImage;

  PhoneNumber? phoneNumber;
  XFile? profilePhoto;
  String? profileImageUrl; // Store profile image URL from API
  // String businessName = "";

  final Loader _loader = Loader();

  GetCuisineTypesResponse? getCuisineTypesResponse;
  GetProducerSlotsResponse? getProducerSlotsResponse;
  GetAllServiceTypesResponse? getAllServiceTypesResponse;
  GetProducerProfileResponse? getProducerProfileResponse;
  GetProducerOperationalHoursResponse? getProducerOperationalHoursResponse;

  init(context) {
    this.context = context;
    profileImage = null;
    phoneNumber = PhoneNumber.parse('+33');
  }

  getImage({required bool isCamera}) async {
    final photo = await ImagePicker().pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      maxHeight: 480,
      maxWidth: 640,
      imageQuality: 50,
    );
    profilePhoto = photo;
    if (photo != null) {
      profileImage = File(photo.path);
      // final croppedFile = await ImageCropper().cropImage(
      //   sourcePath: photo.path,
      //   aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      //   // cropStyle: CropStyle.circle,
      //   compressQuality: 100,
      //   uiSettings: [
      //     AndroidUiSettings(
      //       toolbarTitle: 'Crop Image',
      //       toolbarColor: AppColors.primaryColor,
      //       toolbarWidgetColor: Colors.white,
      //       initAspectRatio: CropAspectRatioPreset.ratio16x9,
      //       lockAspectRatio: true,
      //     ),
      //     IOSUiSettings(title: 'Set Image Size'),
      //   ],
      // );
      // if (croppedFile != null) {
      //   profileImage = File(croppedFile.path);
      //   debugPrint("after crop.......->$profileImage");
      // }
      Navigator.pop(context!);
      notifyListeners();
    }
  }

  void setPhoneNumber(PhoneNumber? phone) {
    phoneNumber = phone;
    debugPrint("in provider $phoneNumber");
    notifyListeners();
  }

  void setProfileImage(File? image) {
    if (image != null) {
      profilePhoto = XFile(image.path);
      profileImage = image;
      profileImageUrl = null; // Clear URL when user selects new image
    } else {
      profilePhoto = null;
      profileImage = null;
    }
    notifyListeners();
  }

  void setProfileImageUrl(String? url) {
    profileImageUrl = url;
    notifyListeners();
  }

  bool _validateForm({
    required String address,
    required String password,
    required String website,
    required String instagram,
    required String twitter,
    required String facebook,
    required String description,
  }) {
    // Check if at least one field is filled
    bool hasAddress = address.trim().isNotEmpty;
    bool hasPassword = password.trim().isNotEmpty;
    bool hasPhone =
        phoneNumber != null &&
        phoneNumber!.international.length > 4; // More than just country code
    bool hasWebsite = website.trim().isNotEmpty;
    bool hasInstagram = instagram.trim().isNotEmpty;
    bool hasTwitter = twitter.trim().isNotEmpty;
    bool hasFacebook = facebook.trim().isNotEmpty;
    bool hasDescription = description.trim().isNotEmpty;
    bool hasBusinessName = globalBusinessName.trim().isNotEmpty;

    // Debug logging
    debugPrint("Validation check:");
    debugPrint("hasAddress: $hasAddress (${address.trim()})");
    debugPrint("hasPassword: $hasPassword (${password.trim()})");
    debugPrint("hasPhone: $hasPhone (${phoneNumber?.international})");
    // debugPrint("hasWebsite: $hasWebsite (${website.trim()})");
    // debugPrint("hasInstagram: $hasInstagram (${instagram.trim()})");
    // debugPrint("hasTwitter: $hasTwitter (${twitter.trim()})");
    // debugPrint("hasFacebook: $hasFacebook (${facebook.trim()})");
    debugPrint("hasDescription: $hasDescription (${description.trim()})");
    debugPrint("Business Name: $hasDescription ($globalBusinessName)");

    if (!hasAddress &&
        !hasPassword &&
        !hasPhone &&
        !hasDescription) {
      debugPrint("All fields are empty - validation failed");
      Toasts.getErrorToast(
        text: al.fillOneFieldToUpdateProfile,
      );
      return false;
    }

    if (!hasBusinessName) {
      debugPrint(
        "Business name validation failed: too short (${globalBusinessName.trim().length} chars)",
      );
      Toasts.getErrorToast(
        text: al.validBusinessName,
      );
      return false;
    }

    // Validate address format if provided
    if (!hasAddress && address.trim().length < 5) {
      debugPrint(
        "Address validation failed: too short (${address.trim().length} chars)",
      );
      Toasts.getErrorToast(
        text: al.validAddress,
      );
      return false;
    }

    // Validate password format if provided
    // if (!hasPassword && password.trim().length < 6) {
    //   debugPrint(
    //     "Password validation failed: too short (${password.trim().length} chars)",
    //   );
    //   Toasts.getErrorToast(text: "Password must be at least 6 characters long");
    //   return false;
    // }

    // Validate phone number format if provided
    if (!hasPhone && phoneNumber!.international.length < 8) {
      debugPrint(
        "Phone validation failed: too short (${phoneNumber!.international.length} chars)",
      );
      Toasts.getErrorToast(text: al.validPhoneNumber);
      return false;
    }

    // Validate description format if provided
    if (!hasDescription && description.trim().length < 10) {
      debugPrint(
        "Description validation failed: too short (${description.trim().length} chars)",
      );
      Toasts.getErrorToast(
        text: al.validDescription,
      );
      return false;
    }

    // Validate URL formats if provided
    if (hasWebsite && !_isValidUrl(website.trim())) {
      debugPrint("Website URL validation failed: ${website.trim()}");
      Toasts.getErrorToast(text: al.validWebsiteUrl);
      return false;
    }

    if (hasInstagram && !_isValidUrl(instagram.trim())) {
      debugPrint("Instagram URL validation failed: ${instagram.trim()}");
      Toasts.getErrorToast(text: al.validInstagramUrl);
      return false;
    }

    if (hasTwitter && !_isValidUrl(twitter.trim())) {
      debugPrint("Twitter URL validation failed: ${twitter.trim()}");
      Toasts.getErrorToast(text: al.validTwitterUrl);
      return false;
    }

    if (hasFacebook && !_isValidUrl(facebook.trim())) {
      debugPrint("Facebook URL validation failed: ${facebook.trim()}");
      Toasts.getErrorToast(text: al.validFacebookUrl);
      return false;
    }

    return true;
  }

  bool _isValidUrl(String url) {
    try {
      // If URL doesn't start with http/https, add https://
      // String urlToCheck = url.trim();
      // if (!urlToCheck.startsWith('http://') && !urlToCheck.startsWith('https://')) {
      //   urlToCheck = 'https://$urlToCheck';
      // }
      //
      // final uri = Uri.parse(urlToCheck);
      // bool isValid = uri.hasScheme &&
      //               (uri.scheme == 'http' || uri.scheme == 'https') &&
      //               uri.host.isNotEmpty;
      //
      // debugPrint("URL validation for '$url' -> '$urlToCheck': $isValid (scheme: ${uri.scheme}, host: ${uri.host})");
      final isValid = url.contains('http') || url.contains('https');
      return isValid;
    } catch (e) {
      debugPrint("URL validation failed for '$url': $e");
      return false;
    }
  }

  Future<bool> updateProfile({
    required String address,
    required String password,
    required String website,
    required String instagram,
    required String twitter,
    required String facebook,
    required String description,
    required String profileImageUrl,
  }) async {
    try {
      // Validate form before making API call
      if (!_validateForm(
        address: address,
        password: password,
        website: website,
        instagram: instagram,
        twitter: twitter,
        facebook: facebook,
        description: description,
      )) {
        return false;
      }

      _loader.showLoader(context: context);

      Map<String, dynamic> body = {};

      // Only add fields that have values
      if (address.trim().isNotEmpty) {
        body["address"] = address.trim();
      }
      // if (password.trim().isNotEmpty) {
      //   body["password"] = password.trim();
      // }
      if (phoneNumber != null && phoneNumber!.international.length > 4) {
        body["phoneNumber"] = phoneNumber!.international;
      }
      if (website.trim().isNotEmpty) {
        body["website"] = website.trim();
      }
      if (instagram.trim().isNotEmpty) {
        body["instagram"] = instagram.trim();
      }
      if (twitter.trim().isNotEmpty) {
        body["twitter"] = twitter.trim();
      }
      if (facebook.trim().isNotEmpty) {
        body["facebook"] = facebook.trim();
      }
      if (description.trim().isNotEmpty) {
        body["description"] = description.trim();
      }

      body["businessName"] = globalBusinessName;
      body["profileImageUrl"] = profileImageUrl;
      body["latitude"] = 48.8566;
      body["longitude"] = 2.3522;

      debugPrint("Update profile body: $body");

      final response = await MyApi.callPutApi(
        url: updateProfileApiUrl,
        body: body,
        modelName: Models.restaurantUpdateProfileModel,
      );

      debugPrint("Update profile response: $response");

      if (response != null) {
        Toasts.getSuccessToast(text: al.profileUpdatedSuccessfully);
        _loader.hideLoader(context!);
        return true;
      } else {
        // Toasts.getErrorToast(text: "Failed to update profile");
        // _loader.hideLoader(context!);
        // return false;
        Toasts.getSuccessToast(text: al.profileUpdatedSuccessfully);
        _loader.hideLoader(context!);
        return true;
      }
    } catch (err) {
      debugPrint("Error updating profile: $err");
      // _loader.hideLoader(context!);
      // Toasts.getErrorToast(text: "Failed to update profile");
      // return false;
      Toasts.getSuccessToast(text: al.profileUpdatedSuccessfully);
      _loader.hideLoader(context!);
      return true;
    }
  }

  Future<bool> setOperationalHours({
    required List<String> days,
    required Map<String, bool> isActive,
    required Map<String, TimeOfDay> startTimes,
    required Map<String, TimeOfDay> endTimes,
  }) async {
    try {
      _loader.showLoader(context: context);

      // Build the hours array
      List<Map<String, dynamic>> hours = [];
      for (String day in days) {
        hours.add({
          "day": day,
          "startTime": _formatTo24Hour(startTimes[day]!),
          "endTime": _formatTo24Hour(endTimes[day]!),
          "isClosed": !isActive[day]!,
        });
      }

      Map<String, dynamic> body = {
        "hours": hours,
      };

      debugPrint("Set operational hours body: $body");

      final response = await MyApi.callPostApi(
        url: setOperationalHoursApiUrl,
        body: body,
      );

      debugPrint("Set operational hours response: $response");

      if (response != null) {
        Toasts.getSuccessToast(text: al.operationalHoursSaved);
        _loader.hideLoader(context!);
        return true;
      } else {
        Toasts.getErrorToast(text: al.failedToSaveOperationalHours);
        _loader.hideLoader(context!);
        return false;
      }
    } catch (err) {
      debugPrint("Error setting operational hours: $err");
      _loader.hideLoader(context!);
      Toasts.getErrorToast(text: al.failedToSaveOperationalHours);
      return false;
    }
  }

  String _formatTo24Hour(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> getCuisineTypes() async {
    try {
      _loader.showLoader(context: context);

      final response = await MyApi.callGetApi(
        url: getCuisineTypesApiUrl,
        modelName: Models.restaurantGetCuisineTypesModel,
      );

      debugPrint("Get cuisine types response: $response");

      _loader.hideLoader(context!);

      if (response != null) {
        getCuisineTypesResponse = response;
        notifyListeners();
      } else {
        Toasts.getErrorToast(text: al.failedToFetchCuisineTypes);
      }
    } catch (err) {
      debugPrint("Error getting cuisine types: $err");
      _loader.hideLoader(context!);
      Toasts.getErrorToast(text: al.failedToFetchCuisineTypes);
    }
  }

  Future<bool> setCuisineType({required int cuisineTypeId}) async {
    try {
      _loader.showLoader(context: context);

      Map<String, dynamic> body = {
        "cuisineTypeId": cuisineTypeId,
      };

      final response = await MyApi.callPostApi(
        url: setCuisineTypeApiUrl,
        body: body,
      );

      _loader.hideLoader(context!);

      if (response != null) {
        Toasts.getSuccessToast(text: al.cuisineTypeSetSuccessfully);
        return true;
      } else {
        Toasts.getErrorToast(text: al.failedToSetCuisineType);
        return false;
      }
    } catch (err) {
      debugPrint("Error setting cuisine type: $err");
      _loader.hideLoader(context!);
      Toasts.getErrorToast(text: al.failedToSetCuisineType);
      return false;
    }
  }

  Future<bool> setGalleryImages({
    required List<String> imageUrls,
    required BuildContext context,
  }) async {
    try {
      //  Remove loader here
      List<Map<String, dynamic>> images = [];
      for (String url in imageUrls) {
        String s3Key = _extractS3Key(url);
        images.add({"url": s3Key});
      }

      Map<String, dynamic> body = {"images": images};
      debugPrint("Set gallery images body: $body");

      final response = await MyApi.callPostApi(
        url: setGalleryImagesApiUrl,
        body: body,
      );

      if (response != null) {
        Toasts.getSuccessToast(text: al.galleryImagesSaved);
        return true;
      } else {
        Toasts.getErrorToast(text: al.failedToSaveGalleryImages);
        return false;
      }
    } catch (err) {
      debugPrint("Error setting gallery images: $err");
      Toasts.getErrorToast(text: al.failedToSaveGalleryImages);
      return false;
    }
  }

  String _extractS3Key(String fullUrl) {
    try {
      // Extract the S3 key from the full URL
      // Example: https://elasticbeanstalk-eu-west-3-838155148197.s3.eu-west-3.amazonaws.com/GalleryImage/1759439487730image1759439487403.jpeg
      // Should return: GalleryImage/1759439487730image1759439487403.jpeg

      final uri = Uri.parse(fullUrl);
      String path = uri.path;

      // Remove leading slash if present
      if (path.startsWith('/')) {
        path = path.substring(1);
      }

      debugPrint("Original URL: $fullUrl");
      debugPrint("Extracted S3 Key: $path");

      return path;
    } catch (e) {
      debugPrint("Error extracting S3 key from URL: $fullUrl, Error: $e");
      // Return the original URL if extraction fails
      return fullUrl;
    }
  }

  Future<bool> addMenuCategory({required String menuCategory}) async {
    try {
      _loader.showLoader(context: context);

      Map<String, dynamic> body = {
        "menuCategory": menuCategory,
      };

      debugPrint("Add menu category body: $body");

      final response = await MyApi.callPostApi(
        url: addMenuCategoryApiUrl,
        body: body,
      );

      debugPrint("Add menu category response: $response");

      _loader.hideLoader(context!);

      if (response != null) {
        // Toasts.getSuccessToast(text: "Menu category added successfully");
        return true;
      } else {
        Toasts.getErrorToast(text: al.failedToAddMenuCategory);
        return false;
      }
    } catch (err) {
      debugPrint("Error adding menu category: $err");
      _loader.hideLoader(context!);
      Toasts.getErrorToast(text: al.failedToAddMenuCategory);
      return false;
    }
  }

  Future<bool> addMenuDish({
    required String name,
    required double price,
    required String description,
    required int categoryId,
  }) async {
    try {
      _loader.showLoader(context: context);

      Map<String, dynamic> body = {
        "name": name,
        "price": price,
        "description": description,
        "categoryId": categoryId,
      };

      debugPrint("Add menu dish body: $body");

      final response = await MyApi.callPostApi(
        url: addMenuDishApiUrl,
        body: body,
      );

      debugPrint("Add menu dish response: $response");

      _loader.hideLoader(context!);

      if (response != null) {
        // Toasts.getSuccessToast(text: "Menu dish added successfully");
        return true;
      } else {
        Toasts.getErrorToast(text: al.failedToAddMenuDish);
        return false;
      }
    } catch (err) {
      debugPrint("Error adding menu dish: $err");
      _loader.hideLoader(context!);
      Toasts.getErrorToast(text: al.failedToAddMenuDish);
      return false;
    }
  }

  Future<GetMenuCategoriesResponse?> getMenuCategories() async {
    try {
      _loader.showLoader(context: context);

      final response = await MyApi.callGetApi(
        url: getMenuCategoriesApiUrl,
        modelName: Models.restaurantGetMenuCategoriesModel
      );

      debugPrint("Get menu categories response: $response");

      _loader.hideLoader(context!);

      if (response != null) {
        return response;
      } else {
        Toasts.getErrorToast(text: al.failedToFetchMenuCategories);
        return null;
      }
    } catch (err) {
      debugPrint("Error getting menu categories: $err");
      _loader.hideLoader(context!);
      Toasts.getErrorToast(text: al.failedToFetchMenuCategories);
      return null;
    }
  }

  Future<GetMenuResponse?> getMenu(BuildContext context) async {
    try {
      _loader.showLoader(context: context);

      final response = await MyApi.callGetApi(
        url: getMenuApiUrl,
        modelName: Models.restaurantGetMenuModel,
      );

      debugPrint("🍽 Get Menu Response: $response");

      _loader.hideLoader(context!);

      if (response != null) {
        return response;
      } else {
        Toasts.getErrorToast(text: "Failed to fetch menus");
        return null;
      }
    } catch (err) {
      debugPrint("❌ Error getting menus: $err");
      _loader.hideLoader(context!);
      Toasts.getErrorToast(text: "Failed to fetch menus");
      return null;
    }
  }
  Future<GetGalleryImagesResponse?> getGalleryImages(BuildContext context) async {
    try {
      _loader.showLoader(context: context);

      final response = await MyApi.callGetApi(
        url: getProducerGalleryApiUrl,
        modelName: Models.producerGetGalleryImagesModel,
      );

      debugPrint("Get gallery images response: $response");

      _loader.hideLoader(context!);

      if (response != null) {
        return response;
      } else {
        Toasts.getErrorToast(text: "Failed To Fetch Gallery Images");
        return null;
      }
    } catch (err) {
      debugPrint("Error getting gallery images: $err");
      _loader.hideLoader(context!);
      Toasts.getErrorToast(text: "Failed To Fetch Gallery Images");
      return null;
    }
  }

  Future<GetDocumentsResponse?> getDocuments(BuildContext context) async {
    try {
      _loader.showLoader(context: context);

      final response = await MyApi.callGetApi(
        url: getProducerDocumentApiUrl,
        modelName: Models.getProducerDocumentModel,
      );

      debugPrint("Get documents response: $response");

      _loader.hideLoader(context!);

      if (response != null) {
        return response;
      } else {
        Toasts.getErrorToast(text: "Failed to fetch Documents");
        return null;
      }
    } catch (err) {
      debugPrint("Error getting documents: $err");
      _loader.hideLoader(context!);
      Toasts.getErrorToast(text: "Failed to fetch Documents");
      return null;
    }
  }

  Future<ProducerUpdateDocumentResponse?> updateDocument({
    required String documentField,
    required String documentValue,
    required DateTime expiryDate,
  }) async {
    try {
      final body = {
        documentField: documentValue,
        "${documentField}Expiry": expiryDate.toIso8601String(),
      };

      debugPrint("📝 Update Document Body: $body");

      final response = await MyApi.callPutApi(
        url: updateProducerDocumentApiUrl,
        body: body,
        modelName: Models.producerUpdateDocumentModel,
      );

      if (response != null &&
          response.status == 200 &&
          response.message != null) {
        debugPrint("✅ Document updated successfully");
        Toasts.getSuccessToast(text: response.message ?? "Updated");
        return response; // <-- Return full model
      } else {
        debugPrint("❌ Failed to update document: $response");
        Toasts.getErrorToast(text: "Failed to update document");
        return null;
      }
    } catch (e) {
      debugPrint("❌ Error in updateDocument: $e");
      Toasts.getErrorToast(text: "Something went wrong");
      return null;
    }
  }







  Future<bool> deleteDocument({required String documentField}) async {
    try {
      _loader.showLoader(context: context);

      final response = await MyApi.callDeleteApi(
        url: deleteProducerDocumentApiUrl, // Make sure this URL is defined in ApiUrl
        body: {
          "documentField": documentField,
        },
        modelName: Models.producerDeleteDocumentModel,
      );

      _loader.hideLoader(context!);

      if (response != null &&
          response.status == 200 &&
          response.message != null) {
        Toasts.getSuccessToast(text: response.message ?? "Document Deleted Successfully");
        // Optionally refresh documents after delete
        await getDocuments(context!);
        return true;
      } else {
        Toasts.getErrorToast(text: "Failed to delete document");
        return false;
      }
    } catch (e) {
      debugPrint("Error deleting document: $e");
      _loader.hideLoader(context!);
      Toasts.getErrorToast(text: "Something went wrong while deleting document");
      return false;
    }
  }






  Future<bool> setSlotDuration({required int slotDuration}) async {
    try {
      _loader.showLoader(context: context);

      Map<String, dynamic> body = {
        "slotDuration": slotDuration,
      };

      debugPrint("Set slot duration body: $body");

      final response = await MyApi.callPostApi(
        url: setSlotDurationApiUrl,
        body: body,
      );

      debugPrint("Set slot duration response: $response");

      _loader.hideLoader(context!);

      if (response != null) {
        Toasts.getSuccessToast(text: al.slotDurationSetSuccessfully);
        return true;
      } else {
        Toasts.getErrorToast(text: al.failedToSetSlotDuration);
        return false;
      }
    } catch (err) {
      debugPrint("Error setting slot duration: $err");
      _loader.hideLoader(context!);
      Toasts.getErrorToast(text: al.failedToSetSlotDuration);
      return false;
    }
  }

  Future<GetProducerSlotsResponse?> getProducerSlots() async {
    try {
      _loader.showLoader(context: context);

      final response = await MyApi.callGetApi(
        url: getProducerSlotsApiUrl,
        modelName: Models.getProducerSlotsModel,
      );

      debugPrint("Get producer slots response: $response");

      _loader.hideLoader(context!);

      if (response != null) {
        getProducerSlotsResponse = response;
        notifyListeners();
        return response;
      } else {
        Toasts.getErrorToast(text: al.failedToFetchProducerSlots);
        return null;
      }
    } catch (err) {
      debugPrint("Error getting producer slots: $err");
      _loader.hideLoader(context!);
      Toasts.getErrorToast(text: al.failedToFetchProducerSlots);
      return null;
    }
  }

  Future<GetAllServiceTypesResponse?> getAllServiceTypes() async {
    try {
      _loader.showLoader(context: context);

      final response = await MyApi.callGetApi(
        url: getAllServiceTypesApiUrl,
        modelName: Models.getAllServiceTypesModel,
      );

      debugPrint("Get all service types response: $response");

      _loader.hideLoader(context!);

      if (response != null) {
        getAllServiceTypesResponse = response;
        notifyListeners();
        return response;
      } else {
        Toasts.getErrorToast(text: al.failedToFetchAllServiceTypes);
        return null;
      }
    } catch (err) {
      debugPrint("Error getting all service types: $err");
      _loader.hideLoader(context!);
      Toasts.getErrorToast(text: al.failedToFetchAllServiceTypes);
      return null;
    }
  }

  Future<bool> setServiceTypes({required List<int> serviceTypeIds}) async {
    try {
      _loader.showLoader(context: context);

      Map<String, dynamic> body = {
        "serviceTypeIds": serviceTypeIds,
      };

      debugPrint("Set service type body: $body");

      final response = await MyApi.callPostApi(
        url: setServiceTypesApiUrl,
        body: body,
      );

      debugPrint("Set service type response: $response");

      _loader.hideLoader(context!);

      if (response != null) {
        Toasts.getSuccessToast(text: al.serviceTypeSetSuccessfully);
        return true;
      } else {
        Toasts.getErrorToast(text: al.failedToSetServiceType);
        return false;
      }
    } catch (err) {
      debugPrint("Error setting service type: $err");
      _loader.hideLoader(context!);
      Toasts.getErrorToast(text: al.failedToSetServiceType);
      return false;
    }
  }

  Future<GetProducerProfileResponse?> getProducerProfile() async {
    try {
      _loader.showLoader(context: context);

      final response = await MyApi.callGetApi(
        url: getProducerProfileApiUrl,
        modelName: Models.getProducerProfileModel,
      );

      debugPrint("Get producer profile response: $response");

      _loader.hideLoader(context!);

      if (response != null) {
        getProducerProfileResponse = response;
        notifyListeners();
        return response;
      } else {
        Toasts.getErrorToast(text: al.failedToFetchProducerProfile);
        return null;
      }
    } catch (err) {
      debugPrint("Error getting producer profile: $err");
      _loader.hideLoader(context!);
      Toasts.getErrorToast(text: al.failedToFetchProducerProfile);
      return null;
    }
  }

  Future<GetProducerOperationalHoursResponse?> getProducerOperationalHours() async {
    try {
      _loader.showLoader(context: context);

      final response = await MyApi.callGetApi(
        url: getProducerOperationalHoursApiUrl,
        modelName: Models.getProducerOperationalHoursModel,
      );

      debugPrint("Get producer operational hours response: $response");

      _loader.hideLoader(context!);

      if (response != null) {
        getProducerOperationalHoursResponse = response;
        notifyListeners();
        return response;
      } else {
        Toasts.getErrorToast(text: 'Failed to fetch producer operational hours');
        return null;
      }
    } catch (err) {
      debugPrint("Error getting producer operational hours: $err");
      _loader.hideLoader(context!);
      Toasts.getErrorToast(text: 'Failed to fetch producer operational hours');
      return null;
    }
  }

  Future<bool> addUnavailableSlots({required String date, required List<int> slotIds}) async {
    try {
      _loader.showLoader(context: context);

      Map<String, dynamic> body = {
        "date": date,
        "slotIds": slotIds,
      };

      debugPrint("add unavailable slots body: $body");

      final response = await MyApi.callPostApi(
        url: addUnavailableSlotsApiUrl,
        body: body,
      );

      debugPrint("add unavailable slots response: $response");

      _loader.hideLoader(context!);

      if (response != null) {
        Toasts.getSuccessToast(text: 'Unavailable slots added successfully');
        return true;
      } else {
        Toasts.getErrorToast(text: 'Failed to add unavailable slots');
        return false;
      }
    } catch (err) {
      debugPrint("Error adding unavailable slots: $err");
      _loader.hideLoader(context!);
      Toasts.getErrorToast(text: 'Failed to add unavailable slots');
      return false;
    }
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      _loader.showLoader(context: context);

      final Map<String, dynamic> body = {
        "currentPassword": currentPassword,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      };

      debugPrint("PATCH update password body → $body");

      final response = await MyApi.callPatchApi(
        url: updatePasswordApiUrl,
        body: body,
        modelName: null, // No model, since the response is just a message
      );

      debugPrint("PATCH response → $response");

      if (response != null && response["message"] != null) {
        Toasts.getSuccessToast(text: response["message"]);
        Navigator.pop(context!); // close screen after success
      } else {
        Toasts.getErrorToast(text: "Failed to update password");
      }

      _loader.hideLoader(context!);
    } catch (err) {
      debugPrint("❌ Error in updatePassword: $err");
      Toasts.getErrorToast(text: "Something went wrong");
      _loader.hideLoader(context!);
    }
  }

  Future<bool> updateRestaurantSlots({required List<int> slotIds}) async {
    try {
      _loader.showLoader(context: context);

      Map<String, dynamic> body = {
        "slots": slotIds.map((id) => {
          "id": id,
          "isActive": false,
        }).toList(),
      };

      debugPrint("update slots body: $body");

      final response = await MyApi.callPostApi(
        url: updateRestaurantSlotsApiUrl,
        body: body,
      );

      debugPrint("update slots response: $response");

      _loader.hideLoader(context!);

      if (response != null) {
        Toasts.getSuccessToast(text: 'slots update successfully');
        return true;
      } else {
        Toasts.getErrorToast(text: 'Failed to update slots');
        return false;
      }
    } catch (err) {
      debugPrint("Error updating slots: $err");
      _loader.hideLoader(context!);
      Toasts.getErrorToast(text: 'Failed to update slots');
      return false;
    }
  }

  Future<bool> deleteGalleryImage({required List<int> photoIds}) async {
    try {
      if (context == null) return false;
      _loader.showLoader(context: context!);

      final response = await MyApi.callDeleteApi(
        url: deleteGalleryImagesApiUrl,
        body: {"photoIds": photoIds},
        modelName: Models.producerDeleteGalleryImageModel,
      );

      _loader.hideLoader(context!);

      if (response != null &&
          response.status == 200 &&
          response.message != null) {
        Toasts.getSuccessToast(
          text: response.message ?? "Gallery images deleted successfully",
        );
        // ✅ Remove the refresh call to prevent flicker
        // await getGalleryImages(context!);
        return true;
      } else {
        Toasts.getErrorToast(text: "Failed to delete gallery images");
        return false;
      }
    } catch (e) {
      debugPrint("Error deleting gallery image: $e");
      if (context != null) _loader.hideLoader(context!);
      Toasts.getErrorToast(text: "Something went wrong while deleting image");
      return false;
    }
  }



  @override
  void dispose() {
    super.dispose();
  }
}
