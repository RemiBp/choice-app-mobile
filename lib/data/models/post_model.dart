import 'package:choice_app/data/models/rating_model.dart';

class PostModel {
  final int? id;
  final String type;
  final String status;
  final String description;
  final String? coverImage;
  final String? link;
  final int? userId;
  final int? producerId;
  final List<String>? images;
  final List<String>? tags;
  final DateTime? createdAt;
  final Map<String, dynamic>? statistics;
  final List<RatingModel>? ratings;
  final Map<String, dynamic>? criteriaRatings;
  final double? globalRating;
  final String? userName;
  final String? userImage;

  PostModel({
    this.id,
    required this.type,
    this.status = 'DRAFT',
    required this.description,
    this.coverImage,
    this.link,
    this.userId,
    this.producerId,
    this.images,
    this.tags,
    this.createdAt,
    this.statistics,
    this.ratings,
    this.criteriaRatings,
    this.globalRating,
    this.userName,
    this.userImage,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      type: json['type'] ?? '',
      status: json['status'] ?? 'DRAFT',
      description: json['description'] ?? '',
      coverImage: json['coverImage'],
      link: json['link'],
      userId: json['userId'],
      producerId: json['producerId'],
      images: (json['images'] as List?)?.map((e) => e['url'].toString()).toList(),
      tags: (json['tags'] as List?)?.map((e) => e['name'].toString()).toList(),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      statistics: json['statistics'],
      criteriaRatings: json['criteriaRatings'],
      globalRating: json['globalRating'] != null ? double.tryParse(json['globalRating'].toString()) : null,
      userName: json['user']?['userName'] ?? json['user']?['fullName'],
      userImage: json['user']?['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'status': status,
      'description': description,
      'coverImage': coverImage,
      'link': link,
      'producerId': producerId,
      'imageUrls': images,
      'tags': tags,
    };
  }
}
