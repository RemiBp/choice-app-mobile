import 'package:choice_app/models/get_my_blocks_response.dart';
import 'package:choice_app/models/unblock_user_response.dart';
import 'package:choice_app/network/API.dart';
import 'package:choice_app/network/api_url.dart';
import 'package:choice_app/network/models.dart';
import 'package:choice_app/res/loader.dart';
import 'package:choice_app/res/toasts.dart';
import 'package:flutter/cupertino.dart';

class ProfileMenuProvider extends ChangeNotifier {
  BuildContext? context;
  final Loader _loader = Loader();

  GetMyBlocksResponse? getMyBlocksResponse;
  UnblockUserResponse? unblockUserResponse;

  Future<void> getMyBlocks() async {
    try {
      _loader.showLoader(context: context);

      final response = await MyApi.callGetApi(
        url: getMyBlocksApiUrl,
        modelName: Models.getMyBlocksModel,
      );

      debugPrint("Get my blocks response: $response");

      _loader.hideLoader(context!);

      if (response != null) {
        getMyBlocksResponse = response;
        notifyListeners();
      } else {
        Toasts.getErrorToast(text: 'Failed to fetch my blocks');
      }
    } catch (err) {
      debugPrint("Error getting my blocks: $err");
      _loader.hideLoader(context!);
      Toasts.getErrorToast(text: 'Failed to fetch my blocks');
    }
  }

  Future<bool> unblockUser({required int id}) async {
    try {
      _loader.showLoader(context: context);

      final response = await MyApi.callDeleteApi(
        url: '$unblockUserApiUrl$id',
        modelName: Models.unblockUserModel,
      );

      _loader.hideLoader(context!);

      if (response != null) {
        unblockUserResponse = response;
        Toasts.getSuccessToast(text: unblockUserResponse?.message ?? '');
        if(unblockUserResponse?.status == 200) {
          return true;
        } else {
          return false;
        }
      } else {
        Toasts.getErrorToast(text: 'Failed to unblock user');
        return false;
      }
    } catch (err) {
      debugPrint("Error unblocking user: $err");
      _loader.hideLoader(context!);
      Toasts.getErrorToast(text: 'Failed to unblock user');
      return false;
    }
  }
}