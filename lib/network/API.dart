import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../common/utils.dart';
import '../l18n.dart';
import '../models/error_model.dart';
import '../res/refresh_token.dart';
import '../res/strings.dart';
import '../res/toasts.dart';
import 'models.dart';

class MyApi {
  static Future<dynamic> callGetPostApi({
    String? url,
    dynamic body,
    Map<String, dynamic>? parameters,
    Map<String, dynamic>? myHeaders,
    dynamic modelName,
    final provider,
    bool? hideBadRequestToast,
  }) async {
    try {
      var dio = Dio();
      // Temporarily bypass connectivity check - set to true
      // var connectivityResult = await (Connectivity().checkConnectivity());
      // debugPrint("Connectivity result: $connectivityResult");
      // bool hasConnection = connectivityResult.any((result) => 
      //   result == ConnectivityResult.mobile || result == ConnectivityResult.wifi);
      if (true) { // Always allow API calls for now
        Map<String, dynamic> header = {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${PreferenceUtils.getString(Strings.token)}'
        };
        Response response = await dio.get(url!,
            options: Options(headers: header), queryParameters: parameters);
        
        debugPrint("=== API RESPONSE ===");
        debugPrint("URL: $url");
        debugPrint("Status Code: ${response.statusCode}");
        debugPrint("Response Data: ${response.data}");
        debugPrint("==================");
        
        switch (response.statusCode) {
          case 200:
            debugPrint('Case 200 Come');
            dynamic getModelObj =
                await Models.getModelObject(modelName, response.data);
            // if (getModelObj.code == 1) {
            //   return getModelObj;
            // } else {
            //   Toasts.getErrorToast(text: getModelObj.message);
            // }
            // return null;
            return getModelObj;

          default:
            debugPrint("API Error - Status Code: ${response.statusCode}");
            Toasts.getErrorToast(text: Strings.badHappenedError);
            return null;
        }
      } else {
        debugPrint("No internet connection detected");
        Toasts.getErrorToast(text: "No internet");
        return null;
      }
    } on DioException catch (ex) {
      if (ex.response != null) {
        ErrorResponse errorResponse =
            await Models.getModelObject(Models.errorModel, ex.response?.data);
        switch (ex.response!.statusCode) {
          case 400:
            if (hideBadRequestToast != true) {
              Toasts.getErrorToast(text: errorResponse.data?.message);
            } else {
              provider?.handleBadRequest();
            }

            return;
          case 401:
            if (errorResponse.message ==
                "Authorization has been denied for this request.") {
              dynamic modelobj;
              await RefreshToken().onRefreshTokenApi().then((value) async {
                if (value) {
                  Map<String, dynamic> header = {
                    "Content-Type": "application/json",
                    'Authorization': PreferenceUtils.getString(Strings.token)
                  };
                  modelobj = await callGetApi(
                      parameters: parameters,
                      modelName: modelName,
                      url: url,
                      myHeaders: header);
                  return modelobj;
                }
              });
              return modelobj;
            } else {
              Toasts.getErrorToast(text: errorResponse.data?.message);
              return;
            }
          default:
            Toasts.getErrorToast(text: Strings.badHappenedError);
            return;
        }
      } else {
        Toasts.getErrorToast(text: Strings.badHappenedError);
      }
    } on Exception catch (ex) {
      debugPrint("ex is : $ex");
      Toasts.getErrorToast(text: Strings.badHappenedError);
      return;
    }
  }

  static Future<dynamic> callPostApi(
      {String? url,
      dynamic body,
      Map<String, dynamic>? parameters,
      Map<String, dynamic>? myHeaders,
      dynamic modelName}) async {
    try {
      var dio = Dio();
      // Temporarily bypass connectivity check - set to true
      // var connectivityResult = await (Connectivity().checkConnectivity());
      // debugPrint("Connectivity result: $connectivityResult");
      // bool hasConnection = connectivityResult.any((result) => 
      //   result == ConnectivityResult.mobile || result == ConnectivityResult.wifi);
      if (true) { // Always allow API calls for now
        Map<String, dynamic> header = {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${PreferenceUtils.getString(Strings.token)}'
        };
        debugPrint("headers are : $header");
        debugPrint("Request Body: $body");
        Response response = await dio.post(url!,
            options: Options(headers: header),
            data: body,
            queryParameters: parameters);
        
        debugPrint("=== POST API RESPONSE ===");
        debugPrint("URL: $url");
        debugPrint("Status Code: ${response.statusCode}");
        debugPrint("Response Data: ${response.data}");
        debugPrint("========================");
        
        switch (response.statusCode) {
          case 200||201:
            if(modelName!=null){
             return await Models.getModelObject(modelName, response.data);
            }else{
              return response.data;
            }


          default:
            debugPrint("POST API Error - Status Code: ${response.statusCode}");
            Toasts.getErrorToast(text: Strings.badHappenedError);
            return null;
        }
      } else {
        Toasts.getErrorToast(text: Strings.noInternetError);
        return null;
      }
    } on DioException catch (ex) {
      debugPrint("=== POST API ERROR ===");
      debugPrint("Error: $ex");
      debugPrint("Status Code: ${ex.response?.statusCode}");
      debugPrint("Error Data: ${ex.response?.data}");
      debugPrint("=====================");
      
      if (ex.response != null) {
        ErrorResponse errorResponse =
            await Models.getModelObject(Models.errorModel, ex.response?.data);
        switch (ex.response!.statusCode) {
          case 401:
            Toasts.getErrorToast(text: errorResponse.message);
            return null;

          case 404:
            Toasts.getErrorToast(text: errorResponse.message??al.genericError);
            return null;
          case 400:
            if (errorResponse.message ==
                "Authorization has been denied for this request.") {
              dynamic modelobj;
              await RefreshToken().onRefreshTokenApi().then((value) async {
                if (value) {
                  Map<String, dynamic> header = {
                    "Content-Type": "application/json",
                    'Authorization': PreferenceUtils.getString(Strings.token)
                  };
                  modelobj = await callPostApi(
                      parameters: parameters,
                      modelName: modelName,
                      body: body,
                      url: url,
                      myHeaders: header);
                  return modelobj;
                }
              });
              return modelobj;
            } else {
              Toasts.getErrorToast(text: errorResponse.message??al.genericError);
              return null;
            }
          default:
            Toasts.getErrorToast(text: al.genericError);
            return null;
        }
      } else {
        Toasts.getErrorToast(text: al.genericError);
      }
    } on Exception catch (ex) {
      debugPrint("ex is : $ex");
      Toasts.getErrorToast(text: al.genericError);
      return null;
    }
  }

  static Future<dynamic> callPatchApi(
      {String? url,
      dynamic body,
      Map<String, dynamic>? parameters,
      Map<String, dynamic>? myHeaders,
      dynamic modelName}) async {
    try {
      var dio = Dio();
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (!connectivityResult.contains(ConnectivityResult.none) ) {
        Map<String, dynamic> header = {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${PreferenceUtils.getString(Strings.token)}'
        };
        debugPrint("PATCH Request Body: $body");
        Response response = await dio.patch(url!,
            options: Options(headers: header),
            data: body,
            queryParameters: parameters);
        
        debugPrint("=== PATCH API RESPONSE ===");
        debugPrint("URL: $url");
        debugPrint("Status Code: ${response.statusCode}");
        debugPrint("Response Data: ${response.data}");
        debugPrint("=========================");
        
        switch (response.statusCode) {
          case 200:

            if (modelName == null) {
              return response.data; // <--- return raw response
            }
            dynamic modelObj =
                await Models.getModelObject(modelName, response.data);
            // if (modelObj.code == 1) {
            //   return modelObj;
            // } else {
            //   Toasts.getErrorToast(text: modelObj.message);
            // }
            // return null;
            return modelObj;

          default:
            debugPrint("PATCH API Error - Status Code: ${response.statusCode}");
            Toasts.getErrorToast(text: al.genericError);
            return null;
        }
      } else {
        Toasts.getErrorToast(text: al.noInternetConnection);
        return null;
      }
    } on DioException catch (ex) {
      if (ex.response != null) {
        ErrorResponse errorResponse =
            await Models.getModelObject(Models.errorModel, ex.response?.data);
        switch (ex.response!.statusCode) {
          case 400:
            Toasts.getErrorToast(text: errorResponse.data?.message);
            return null;
          case 401:
            if (errorResponse.message ==
                "Authorization has been denied for this request.") {
              dynamic modelobj;
              await RefreshToken().onRefreshTokenApi().then((value) async {
                if (value) {
                  Map<String, dynamic> header = {
                    "Content-Type": "application/json",
                    'Authorization': PreferenceUtils.getString(Strings.token)
                  };
                  modelobj = await callPatchApi(
                      parameters: parameters,
                      modelName: modelName,
                      url: url,
                      myHeaders: header);
                  return modelobj;
                }
              });
              return modelobj;
            } else {
              Toasts.getErrorToast(text: errorResponse.data?.message);
              return;
            }
          default:
            Toasts.getErrorToast(text: al.genericError);
            return null;
        }
      } else {
        Toasts.getErrorToast(text: al.genericError);
      }
    } on Exception catch (ex) {
      debugPrint("ex is : $ex");
      Toasts.getErrorToast(text: al.genericError);
      return null;
    }
  }

  static Future<dynamic> callGetApi({
    String? url,
    dynamic body,
    Map<String, dynamic>? parameters,
    Map<String, dynamic>? myHeaders,
    dynamic modelName,
    bool? showToast,
  }) async {
    try {
      var dio = Dio();
      // Temporarily bypass connectivity check - set to true
      // var connectivityResult = await (Connectivity().checkConnectivity());
      // debugPrint("Connectivity result: $connectivityResult");
      // bool hasConnection = connectivityResult.any((result) => 
      //   result == ConnectivityResult.mobile || result == ConnectivityResult.wifi);
      if (true) { // Always allow API calls for now
        Map<String, dynamic> header = {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${PreferenceUtils.getString(Strings.token)}'
        };
        debugPrint("GET Request Body: $body");
        Response response = await dio.get(url!,
            data: body,
            options: Options(headers: header),
            queryParameters: parameters);
        
        debugPrint("=== GET API RESPONSE ===");
        debugPrint("URL: $url");
        debugPrint("Status Code: ${response.statusCode}");
        debugPrint("Response Data: ${response.data}");
        debugPrint("=======================");
        
        switch (response.statusCode) {
          case 200||201:
            if(modelName!=null){
              return await Models.getModelObject(modelName, response.data);
            }else{
              return response.data;
            }
            // if (getModelObj.code == 1) {
            //   return getModelObj;
            // } else {
            //   Toasts.getErrorToast(text: getModelObj.message);
            // }
            // return null;

          default:
            debugPrint("GET API Error - Status Code: ${response.statusCode}");
            Toasts.getErrorToast(text: al.genericError);
            return null;
        }
      } else {
        Toasts.getErrorToast(text: al.noInternet);
        return null;
      }
    } on DioException catch (ex) {
      debugPrint("=== GET API ERROR ===");
      debugPrint("Error: $ex");
      debugPrint("Status Code: ${ex.response?.statusCode}");
      debugPrint("Error Data: ${ex.response?.data}");
      debugPrint("====================");

      if (ex.response != null) {
        ErrorResponse errorResponse = ex.response?.data is! String
            ? await Models.getModelObject(Models.errorModel, ex.response?.data)
            : ErrorResponse();
        switch (ex.response!.statusCode) {
          case 400:
            if (showToast == null) {
              Toasts.getErrorToast(text: errorResponse.message);
            }
            return;
          case 401:
            dynamic modelobj;
            await RefreshToken().onRefreshTokenApi().then((value) async {
              if (value) {
                Map<String, dynamic> header = {
                  "Content-Type": "application/json",
                  'Authorization': PreferenceUtils.getString(Strings.token)
                };
                modelobj = await callGetApi(
                    parameters: parameters,
                    modelName: modelName,
                    url: url,
                    myHeaders: header);
                return modelobj;
              }
            });
            return modelobj;

          default:
            Toasts.getErrorToast(text: al.genericError);
            return;
        }
      } else {
        Toasts.getErrorToast(text: al.genericError);
        return null;
      }
    } on Exception catch (ex) {
      debugPrint("ex is : $ex");
      Toasts.getErrorToast(text: al.genericError);
      return;
    }
  }

  static Future<dynamic> callPutApi(
      {String? url,
      dynamic body,
      Map<String, dynamic>? parameters,
      Map<String, dynamic>? myHeaders,
      dynamic modelName}) async {
    try {
      var dio = Dio();
      // Temporarily bypass connectivity check - set to true
      // var connectivityResult = await (Connectivity().checkConnectivity());
      // debugPrint("Connectivity result: $connectivityResult");
      // bool hasConnection = connectivityResult.any((result) => 
      //   result == ConnectivityResult.mobile || result == ConnectivityResult.wifi);
      if (true) { // Always allow API calls for now
        Map<String, dynamic> header = {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${PreferenceUtils.getString(Strings.token)}'
        };
        debugPrint("PUT Request Body: $body");
        Response response = await dio.put(url!,
            options: Options(headers: header),
            data: body,
            queryParameters: parameters);
        
        debugPrint("=== PUT API RESPONSE ===");
        debugPrint("URL: $url");
        debugPrint("Status Code: ${response.statusCode}");
        debugPrint("Response Data: ${response.data}");
        debugPrint("======================");
        
        switch (response.statusCode) {
          case 200:
            if(modelName!=null){
              return await Models.getModelObject(modelName, response.data);
            }else{
              return response.data;
            }

          default:
            debugPrint("PUT API Error - Status Code: ${response.statusCode}");
            Toasts.getErrorToast(text: Strings.badHappenedError);
            return null;
        }
      } else {
        Toasts.getErrorToast(text: Strings.noInternetError);
        return null;
      }
    } on DioException catch (ex) {
      if (ex.response != null) {
        ErrorResponse errorResponse =
            await Models.getModelObject(Models.errorModel, ex.response?.data);
        switch (ex.response!.statusCode) {
          case 400:
            Toasts.getErrorToast(text: errorResponse.data?.message);
            return null;
          case 401:
            if (errorResponse.message ==
                "Authorization has been denied for this request.") {
              dynamic modelobj;
              await RefreshToken().onRefreshTokenApi().then((value) async {
                if (value) {
                  Map<String, dynamic> header = {
                    "Content-Type": "application/json",
                    'Authorization': PreferenceUtils.getString(Strings.token)
                  };
                  modelobj = await callPutApi(
                      parameters: parameters,
                      modelName: modelName,
                      body: body,
                      url: url,
                      myHeaders: header);
                  return modelobj;
                }
              });
              return modelobj;
            } else {
              Toasts.getErrorToast(text: errorResponse.data?.message);
              return null;
            }
          default:
            Toasts.getErrorToast(text: Strings.badHappenedError);
            return null;
        }
      } else {
        Toasts.getErrorToast(text: Strings.badHappenedError);
      }
    } on Exception catch (ex) {
      debugPrint("ex is : $ex");
      Toasts.getErrorToast(text: Strings.badHappenedError);
      return null;
    }
  }

  static Future<dynamic> callDeleteApi(
      {String? url,
      dynamic body,
      Map<String, dynamic>? parameters,
      Map<String, dynamic>? myHeaders,
      dynamic modelName}) async {
    try {
      var dio = Dio();
      // Temporarily bypass connectivity check - set to true
      // var connectivityResult = await (Connectivity().checkConnectivity());
      // debugPrint("Connectivity result: $connectivityResult");
      // bool hasConnection = connectivityResult.any((result) => 
      //   result == ConnectivityResult.mobile || result == ConnectivityResult.wifi);
      if (true) { // Always allow API calls for now
        Map<String, dynamic> header = {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${PreferenceUtils.getString(Strings.token)}'
        };
        debugPrint("DELETE Request Body: $body");
        Response response = await dio.delete(url!,
            options: Options(headers: header),
            data: body,
            queryParameters: parameters);
        
        debugPrint("=== DELETE API RESPONSE ===");
        debugPrint("URL: $url");
        debugPrint("Status Code: ${response.statusCode}");
        debugPrint("Response Data: ${response.data}");
        debugPrint("=========================");
        
        switch (response.statusCode) {
          case 200:
            if (modelName != null) {
              dynamic modelObj = await Models.getModelObject(modelName, response.data);
              return modelObj;
            } else {
              // If no modelName provided, just return the raw response as Map
              if (response.data is Map) {
                return response.data;
              } else if (response.data is String) {
                try {
                  return jsonDecode(response.data);
                } catch (_) {
                  return {'message': response.data};
                }
              } else {
                return {'message': 'Unknown response format'};
              }
            }

          default:
            debugPrint("DELETE API Error - Status Code: ${response.statusCode}");
            Toasts.getErrorToast(text: Strings.badHappenedError);
            return null;
        }
      } else {
        Toasts.getErrorToast(text: Strings.noInternetError);
        return null;
      }
    } on DioException catch (ex) {
      if (ex.response != null) {
        ErrorResponse errorResponse =
            await Models.getModelObject(Models.errorModel, ex.response?.data);
        switch (ex.response!.statusCode) {
          case 400:
            Toasts.getErrorToast(text: errorResponse.data?.message);
            return null;
          case 401:
            if (errorResponse.message ==
                "Authorization has been denied for this request.") {
              dynamic modelobj;
              await RefreshToken().onRefreshTokenApi().then((value) async {
                if (value) {
                  Map<String, dynamic> header = {
                    "Content-Type": "application/json",
                    'Authorization': PreferenceUtils.getString(Strings.token)
                  };
                  modelobj = await callPutApi(
                      parameters: parameters,
                      modelName: modelName,
                      body: body,
                      url: url,
                      myHeaders: header);
                  return modelobj;
                }
              });
              return modelobj;
            } else {
              Toasts.getErrorToast(text: errorResponse.data?.message);
              return null;
            }
          default:
            Toasts.getErrorToast(text: Strings.badHappenedError);
            return null;
        }
      } else {
        Toasts.getErrorToast(text: Strings.badHappenedError);
      }
    } on Exception catch (ex) {
      debugPrint("ex is : $ex");
      Toasts.getErrorToast(text: Strings.badHappenedError);
      return null;
    }
  }
}
