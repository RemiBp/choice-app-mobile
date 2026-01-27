
import 'package:flutter/material.dart';
import '../../../data/services/producer_post_service.dart';

class ProducerPostProvider extends ChangeNotifier {
  final ProducerPostService _service = ProducerPostService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<dynamic> _posts = [];
  List<dynamic> get posts => _posts;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchMyPosts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _posts = await _service.getMyPosts();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createPost({
    required String description,
    List<String>? images,
    List<String>? tags,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Construct payload according to what Backend likely expects
      final payload = {
        'description': description,
        'images': images ?? [], // Assuming backend handles list of URLs
        'tags': tags ?? [],
        'status': 'PUBLIC', // Default
        'type': 'RESTAURANT', // Or 'WELLNESS', ideally inferred from role but we can send default or let backend handle
      };

      await _service.createProducerPost(payload);
      await fetchMyPosts(); // Refresh list
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleLike(int postId) async {
    try {
      await _service.togglePostLike(postId);
      // Optimistically update or refresh if needed
      // For now, just refreshing my posts to see updated like counts/states
      await fetchMyPosts();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleFollow(int producerId) async {
    try {
      await _service.toggleFollowProducer(producerId);
      // Refresh to see updated follow state
      await fetchMyPosts();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
