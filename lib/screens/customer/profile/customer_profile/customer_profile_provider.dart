  import 'dart:io';

  import 'package:choice_app/models/customer_all_posts_response.dart';
  import 'package:choice_app/models/customer_profile_response.dart';
  import 'package:choice_app/network/API.dart';
  import 'package:choice_app/network/api_url.dart';
  import 'package:choice_app/network/models.dart';
  import 'package:choice_app/res/loader.dart';
  import 'package:choice_app/res/toasts.dart';
  import 'package:flutter/material.dart';
  import 'package:phone_form_field/phone_form_field.dart';

  import '../../../../common/utils.dart';
  import '../../../restaurant/profile/profile_widgets.dart';

  class CustomerProfileProvider extends ChangeNotifier{
    CustomerProfileResponse customerProfileResponse = CustomerProfileResponse();
    CustomerAllPostsResponse postsResponse = CustomerAllPostsResponse();
    BuildContext? context;
    final Loader _loader = Loader();
    File? profileImage;
    String? profileImageUrl;
    PhoneNumber? phoneNumber;

    init(context){
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

    User? get user=>{
       customerProfileResponse.user
    }.firstOrNull;

    List<Data>? get  userPosts=>{
      postsResponse.data
    }.firstOrNull;


    pickProfileImage() async {
      profileImage = await bottomSheet(context!);
      notifyListeners();
    }

    Future<void> getProfile()async{
      try{
        _loader.showLoader(context: context);
        customerProfileResponse =await MyApi.callGetApi(
          url: userProfileApiUrl,
          modelName: Models.customerProfileModel
        );
        debugPrint("profile response is : ${customerProfileResponse.toJson()
        }");
        if (customerProfileResponse.user != null) {
          final user = customerProfileResponse.user!;
          debugPrint("✅ profile response: ${customerProfileResponse.toJson()}");

          //  Store lat/lng for Explore screen use
          await PreferenceUtils.setString("latitude", user.latitude?.toString() ?? "");
          await PreferenceUtils.setString("longitude", user.longitude?.toString() ?? "");
        }

        _loader.hideLoader(context!);

      }catch(err){
        debugPrint("error while getting profile is : $err");
        _loader.hideLoader(context!);
      }
      notifyListeners();
    }


    Future<void> getCustomerPosts()async{
      try{
        _loader.showLoader(context: context);
        postsResponse =await MyApi.callGetApi(
            url: userPostsApiUrl,
            modelName: Models.customerAllPostsModel
        );
        debugPrint("user posts response is : ${postsResponse.status
        }");
        _loader.hideLoader(context!);
      }catch(err){
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
          "longitude": 67.0011
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

  }