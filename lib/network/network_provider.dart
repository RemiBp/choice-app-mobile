import 'dart:io';

import 'package:choice_app/network/API.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../l18n.dart';
import '../res/loader.dart';
import '../res/toasts.dart';
import 'api_url.dart';
import 'package:path/path.dart';

class  NetworkProvider extends ChangeNotifier{


  String case400Error = "";
  bool isSubscriber = false;
  BuildContext? context;
  File? image;
  String? imageUrl;

  final Loader _loader = Loader();


  Future<File?> getImage({required bool isCamera}) async {
    final photo = await ImagePicker().pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      maxHeight: 480,
      maxWidth: 640,
      imageQuality: 50,
    );
    if (photo != null) {
      final image  = File(photo.path);
      notifyListeners();
      return image;
    }
    return null;
  }


  Future<String?> getUrlForFileUpload(Uint8List? imageBytes,{
    bool? hideLoader,
    bool? startLoader,
  }) async {
    try {
      if (startLoader != false) {
        _loader.showLoader(context: context);
      }
      Map<String, dynamic> header = {"Content-Type": "application/json"};
      Map<String, dynamic> body = {
        "fileName": "image${DateTime.now().millisecondsSinceEpoch}.${getImageType(imageBytes!)}",
        "contentType": "image/${getImageType(imageBytes)}",
        "folderName": "GalleryImage"
      };
      debugPrint("body is ...............>$body");
      final response = await MyApi.callPostApi(
        url: preSignedFileUploadApiUrl,
        myHeaders: header,
        body: body,
      );
      if (response?["url"] != null) {
        debugPrint("url for file upload is : ${response?["url"]}");
        imageUrl = response?["keyName"] ;
        await uploadImageByUrl(response?["url"], imageBytes);

        if (hideLoader != false) {
          _loader.hideLoader(context!);
        }
        notifyListeners();
        return imageUrl;
      } else {
        _loader.hideLoader(context!);
        notifyListeners();
        return null;
      }
    } catch (err) {
      debugPrint("error while getting url for file is : $err");
      _loader.hideLoader(context!);
      return null;
    }
  }

  Future<bool> uploadImageByUrl(
      String apiUrl,
      Uint8List imageBytes, {
        Function(int sent, int total)? onSendProgress,
      }) async {
    try {
      final Dio dio = Dio();

      final response = await dio.put(
        apiUrl,
        data: Stream.fromIterable(imageBytes.map((e) => [e])), // stream upload
        options: Options(
          headers: {
            'Content-Length': imageBytes.length.toString(),
            'Content-Type': 'application/pdf',
          },
        ),
        onSendProgress: onSendProgress, // ✅ progress callback
      );

      if (response.statusCode == 200) {
        debugPrint("✅ Upload successful!");
        return true;
      } else {
        debugPrint("❌ Upload failed: ${response.statusCode}");
        return false;
      }
    } catch (err) {
      debugPrint("⚠️ Error while uploading file: $err");
      return false;
    }
  }

  String? getImageType(Uint8List bytes) {
    // PNG signature: 89 50 4E 47 0D 0A 1A 0A
    if (bytes.length > 4 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return 'png';
    }

    // JPEG signature: FF D8 FF
    if (bytes.length > 2 && bytes[0] == 0xFF && bytes[1] == 0xD8) {
      return 'jpeg';
    }

    // GIF signature: 47 49 46 38 (GIF89a) or 47 49 46 37 (GIF87a)
    if (bytes.length > 6 &&
        bytes[0] == 0x47 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        (bytes[4] == 0x38 || bytes[4] == 0x37)) {
      return 'gif';
    }

    // BMP signature: 42 4D
    if (bytes.length > 2 && bytes[0] == 0x42 && bytes[1] == 0x4D) {
      return 'bmp';
    }

    // WebP signature: 52 49 46 46 (RIFF) + 87 65 62 50 (WEBP)
    if (bytes.length > 12 &&
        bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46 &&
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50) {
      return 'webp';
    }

    return null; // Unknown format
  }


  Future<String?> getUrlForDocumentUpload(
      File file,
      BuildContext context, {
        Function(int sent, int total)? onSendProgress,
      }) async {
    try {
      _loader.showLoader(context: context);

      final String fileName = basename(file.path);
      final body = {
        "fileName": fileName,
        "contentType": "application/pdf",
        "folderName": "BusinessDocuments",
      };

      debugPrint("📄 PreSigned Document Upload Body: $body");

      final response = await MyApi.callPostApi(
        url: preSignedFileUploadApiUrl,
        myHeaders: {"Content-Type": "application/json"},
        body: body,
      );

      final preSignedUrl = response?["url"];
      final keyName = response?["keyName"];

      if (preSignedUrl == null || keyName == null) {
        _loader.hideLoader(context);
        Toasts.getErrorToast(text: "Failed to get PreSigned URL");
        return null;
      }

      debugPrint("✅ Got PreSigned URL: $preSignedUrl");
      debugPrint("🗝️ KeyName: $keyName");

      final dio = Dio();

      // IMPORTANT: S3 only expects content-type header, nothing else.
      final headers = {"Content-Type": "application/pdf",};

      final uploadResponse = await dio.put(
        preSignedUrl,
        data: await file.readAsBytes(),
        options: Options(headers: headers),
        onSendProgress: (sent, total) {
          if (onSendProgress != null) onSendProgress(sent, total);
          final progress = total > 0 ? (sent / total * 100).toStringAsFixed(1) : "0";
          debugPrint("📤 Uploading... $progress%");
        },
      );

      _loader.hideLoader(context);

      if (uploadResponse.statusCode == 200) {
        debugPrint("✅ Document uploaded successfully to S3");
        return keyName; // return to be used in PUT API
      } else {
        debugPrint("❌ Upload failed. Status: ${uploadResponse.statusCode}");
        Toasts.getErrorToast(text: "Failed to upload document");
        return null;
      }
    } catch (e) {
      debugPrint("❌ Error in getUrlForDocumentUpload: $e");
      _loader.hideLoader(context);
      Toasts.getErrorToast(text: "Error uploading document");
      return null;
    }
  }

  static String extractS3Key(String fullUrl) {
    try {
      final uri = Uri.parse(fullUrl);
      String path = uri.path;

      // Remove leading slash if present
      if (path.startsWith('/')) {
        path = path.substring(1);
      }

      return path;
    } catch (e) {
      print("Error extracting S3 key: $e");
      return fullUrl;
    }
  }



}