import 'package:choice_app/common/utils.dart';
import 'package:choice_app/models/get_producer_posts_by_id_response.dart';
import 'package:choice_app/models/producer_posts_response.dart';
import 'package:choice_app/network/API.dart';
import 'package:choice_app/network/api_url.dart';
import 'package:choice_app/res/loader.dart';
import 'package:choice_app/res/strings.dart';
import 'package:choice_app/res/toasts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../network/models.dart';

class  ChoiceProvider  extends ChangeNotifier{

  final Loader _loader = Loader();
  ProducerPostsResponse postsResponse = ProducerPostsResponse();
  BuildContext? context;
  GetProducerPostsByIdResponse? selectedPost;

  init(context){
    this.context = context;
  }


Future<void> createChoiceApi({
    required String title,
    required String description,
    required List<String> tags,
    required String location,
    required String type,
    required List<String> images,
}
    )async{
    try{
      _loader.showLoader(context: context);
      final body = {
        "placeId": 21,
        "title":title,
        "type": type,
        "status": "public",
        "description": description,
        "link": "https://yourrestaurant.com/sunday-brunch",
        "tags": tags,
        "coverImage": images[0],
        "imageUrls":images,
        "publishDate":"2025-08-21T11:00:00.000Z",
        // DateTime.now().toIso8601String(),
        "createdBy": PreferenceUtils.getString(Strings.email),
        "location": location,
      };
      debugPrint("body for create posst is : $body");
      final response  = await MyApi.callPostApi(
        url:createProducerPostApiUrl,
        body: body,
      );
      await getProducerPosts();
      _loader.hideLoader(context!);
      debugPrint("response is : $response");
      if(response?["message"]!=null){
        Toasts.getSuccessToast(text: response?["message"]);
        // context!.pop();
      }
      notifyListeners();
    }catch(err){
      _loader.hideLoader(context!);
      debugPrint("error while creating user post is : $err");
    }
}


  Future<void> getProducerPosts()async{
    try{
      _loader.showLoader(context: context);
      postsResponse =await MyApi.callGetApi(
          url: getProducerPostsApiUrl,
          modelName: Models.producerPostsModel
      );
      debugPrint("rest posts response is : ${postsResponse.status}");
      debugPrint("rest posts response is : ${postsResponse.data?.length??0}");
      _loader.hideLoader(context!);
      notifyListeners();
    }catch(err){
      debugPrint("error while getting rest posts is : $err");
      _loader.hideLoader(context!);
    }
    notifyListeners();
  }

  Future<void> getProducerPostById(int postId) async {
    try {
      _loader.showLoader(context: context);

      final response = await MyApi.callGetApi(
        url: '$getProducerPostsByIdApiUrl/$postId',
        modelName: Models.getProducerPostsByIdModel,
      );

      _loader.hideLoader(context!);

      if (response != null && response['data'] != null) {
        selectedPost = GetProducerPostsByIdResponse.fromJson(response['data']);
        notifyListeners();
        debugPrint("Fetched post: ${selectedPost!.description}");
      } else {
        Toasts.getErrorToast(
          text: response?['message'] ?? "Failed to fetch post",
        );
      }
    } catch (e) {
      _loader.hideLoader(context!);
      debugPrint("Error fetching post by ID: $e");
      Toasts.getErrorToast(text: "Something went wrong");
    }
  }



}