import 'dart:io';

import 'package:choice_app/models/customer_all_posts_response.dart';
import 'package:choice_app/models/customer_profile_response.dart';
import 'package:choice_app/models/get_user_detail_response.dart';
import 'package:choice_app/network/API.dart';
import 'package:choice_app/network/api_url.dart';
import 'package:choice_app/network/models.dart';
import 'package:choice_app/res/loader.dart';
import 'package:choice_app/res/toasts.dart';
import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';

import '../../../../common/utils.dart';
import '../../../restaurant/profile/profile_widgets.dart';
import 'package:geolocator/geolocator.dart';

class CustomerProfileProvider extends ChangeNotifier {
  CustomerProfileResponse customerProfileResponse = CustomerProfileResponse();
  CustomerAllPostsResponse postsResponse = CustomerAllPostsResponse();
  BuildContext? context;
  final Loader _loader = Loader();
  File? profileImage;
  String? profileImageUrl;
  PhoneNumber? phoneNumber;

  GetUserDetailResponse? getUserDetailResponse;

  init(context) {
    this.context = context;
  }

  void setPhoneNumber(PhoneNumber? number) {
    phoneNumber = number;
    notifyListeners();
  }

  reset() {
    profileImageUrl = null;
    profileImage = null;
  }

  User? get user => {customerProfileResponse.user}.firstOrNull;

  List<Data>? get userPosts => {postsResponse.data}.firstOrNull;

  pickProfileImage() async {
    profileImage = await bottomSheet(context!);
    notifyListeners();
  }

  Future<void> getProfile() async {
    try {
      _loader.showLoader(context: context);
      customerProfileResponse = await MyApi.callGetApi(
        url: userProfileApiUrl,
        modelName: Models.customerProfileModel,
      );
      debugPrint("profile response is : ${customerProfileResponse.toJson()}");
      if (customerProfileResponse.user != null) {
        final user = customerProfileResponse.user!;
        debugPrint("✅ profile response: ${customerProfileResponse.toJson()}");

        //  Store lat/lng for Explore screen use
        await PreferenceUtils.setString(
          "latitude",
          user.latitude?.toString() ?? "",
        );
        await PreferenceUtils.setString(
          "longitude",
          user.longitude?.toString() ?? "",
        );
      }

      _loader.hideLoader(context!);
    } catch (err) {
      debugPrint("error while getting profile is : $err");
      _loader.hideLoader(context!);
    }
    notifyListeners();
  }

  Future<void> getCustomerPosts() async {
    try {
      _loader.showLoader(context: context);
      postsResponse = await MyApi.callGetApi(
        url: userPostsApiUrl,
        modelName: Models.customerAllPostsModel,
      );
      debugPrint("user posts response is : ${postsResponse.status}");
      _loader.hideLoader(context!);
    } catch (err) {
      debugPrint("error while getting user posts is : $err");
      _loader.hideLoader(context!);
    }
    notifyListeners();
  }

  Future<void> updateCustomerProfile({
    required String name,
    required String username,
    required String bio,
  }) async {
    try {
      _loader.showLoader(context: context);
      final body = {
        "fullName": name,
        "userName": username,
        "bio": bio,
        "phoneNumber": phoneNumber!.international, // added phone
        "profileImageUrl": profileImageUrl,
        "latitude": 24.8607,
        "longitude": 67.0011,
      };
      final response = await MyApi.callPutApi(
        url: userUpdateProfileApiUrl,
        body: body,
      );
      debugPrint("updating profile response : $response");
      Toasts.getSuccessToast(text: response?["message"]);
      await getProfile();
      _loader.hideLoader(context!);
      Navigator.pop(context!);
    } catch (err) {
      debugPrint("error while updating profile is : $err");
      _loader.hideLoader(context!);
    }
    notifyListeners();
  }

  Future<void> getUserDetails({required int userId}) async {
    try {
      _loader.showLoader(context: context);
      getUserDetailResponse = await MyApi.callGetApi(
        url: '$getUserDetailApiUrl$userId',
        modelName: Models.getUserDetailModel,
      );
      debugPrint(
        "get user detail response is : ${getUserDetailResponse?.data?.toJson()}",
      );
      _loader.hideLoader(context!);
      notifyListeners();
    } catch (err) {
      debugPrint("error while getting user details is : $err");
      _loader.hideLoader(context!);
    }
  }

  Future<void> reportUser({
    required int userId,
    required String userName,
    required String reason,
  }) async {
    try {
      _loader.showLoader(context: context);
      final body = {
        "reportedUserId": userId,
        "reason": reason,
      };
      final response = await MyApi.callPostApi(
        url: reportUserApiUrl,
        body: body,
      );
      Toasts.getSuccessToast(text: '$userName reported successfully');
      _loader.hideLoader(context!);
      Navigator.pop(context!);
    } catch (err) {
      debugPrint("error while reporting user is : $err");
      _loader.hideLoader(context!);
      Toasts.getErrorToast(text: 'Unable to report $userName');
    }
  }

  Future<void> blockUser({
    required int userId,
    required String userName,
  }) async {
    try {
      _loader.showLoader(context: context);
      final body = {
        "blockedUserId": userId,
      };
      await MyApi.callPostApi(
        url: blockUserApiUrl,
        body: body,
      );
      Toasts.getSuccessToast(text: '$userName blocked successfully');
      _loader.hideLoader(context!);
      Navigator.pop(context!);
    } catch (err) {
      debugPrint("error while blocking user is : $err");
      _loader.hideLoader(context!);
      Toasts.getErrorToast(text: 'Unable to block $userName');
    }

    Future<void> updateUserCoordinatesOnLoginOrAppStart() async {
      try {
        // 1. Ensure location permissions
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) return;

        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          return;
        }

        // 2. Get current location
        final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        final body = {
          "latitude": pos.latitude,
          "longitude": pos.longitude,
        };

        debugPrint("📍 Sending Location Update: $body");

        // 3. Hit POST API — MyApi will automatically attach auth token
        final response = await MyApi.callPostApi(
          url: updateUserCoordinatesApiUrl,
          body: body,
        );

        debugPrint("📍 Location Update Response: $response");

        // 4. Save locally
        await PreferenceUtils.setString("latitude", pos.latitude.toString());
        await PreferenceUtils.setString("longitude", pos.longitude.toString());

      } catch (e) {
        debugPrint("❌ Error sending location: $e");
      }
    }



  }
