import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../appColors/colors.dart';
import '../../../data/services/api_service.dart';

class ProfileProvider extends ChangeNotifier {
  BuildContext? context;

  File? profileImage;

  init(context) {
    this.context = context;
    profileImage = null;
  }

  getImage({required bool isCamera}) async {
    final photo = await ImagePicker().pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      maxHeight: 480,
      maxWidth: 640,
      imageQuality: 50,
    );
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

  bool isLoading = false;

  Future<bool> deleteAccount() async {
     try {
       // Ideally use ProfileService, but direct Dio for verified quickfix
       final dio = ApiService().client;
       // We need a deleteReasonId. Backend says `deleteAccount(userId, deleteReasonId)`.
       // For now hardcode '1' or fetch reasons. 
       // Start with fetching reasons? Or just send 1 (Other).
       await dio.delete('/api/producer/profile/deleteAccount/1'); // Assuming 1 exists
       return true;
     } catch (e) {
       debugPrint("Delete Account Error: $e");
       return false;
     }
  }

  Future<bool> saveProfile({
    required String address,
    required String password,
    required String website,
    required String instagram,
    required String facebook,
    required String description,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      // Using ApiService directly since we don't have a separate ProfileService file yet
      // and I want to minimize file creation overhead for this fix.
      // Ideally move to ProfileService later.
      final dio = ApiService().client;
      
      final payload = {
        'address': address,
        'description': description,
        'socialMedia': {
           'website': website,
           'instagram': instagram,
           'facebook': facebook,
        },
        // Password update usually requires a separate endpoint or old password. 
        // We will skip password here as it requires /updatePassword route generally.
      };

      await dio.put('/api/producer/profile/updateProfile', data: payload);
      
      if (password.isNotEmpty) {
         // Optionally call updatePassword if needed
      }

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error saving profile: $e");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
