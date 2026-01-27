
import 'package:flutter/material.dart';
import '../data/models/post_model.dart';
import '../data/models/rating_model.dart';
import '../data/services/post_service.dart';

class PostProvider extends ChangeNotifier {
  final PostService _service = PostService();

  List<PostModel> _feed = [];
  List<PostModel> get feed => _feed;

  List<dynamic> _producerMenu = [];
  List<dynamic> get producerMenu => _producerMenu;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchProducerMenu(int producerId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _producerMenu = await _service.getProducerMenu(producerId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchFeed() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _feed = await _service.getFeed();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createChoice({
    required PostModel post,
    required List<RatingModel> ratings,
    List<Map<String, dynamic>>? dishRatings,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 1. Create the Post
      final createdPost = await _service.createPost(post);
      
      // 2. Save the Overall Ratings
      if (ratings.isNotEmpty) {
        await _service.saveRatings(createdPost.id!, post.type, ratings);
      }

      // 3. Save Dish Ratings if any
      if (dishRatings != null && dishRatings.isNotEmpty) {
        await _service.saveDishRatings(createdPost.id!, dishRatings);
      }

      await fetchFeed(); // Refresh feed
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
