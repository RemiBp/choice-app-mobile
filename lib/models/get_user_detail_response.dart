class GetUserDetailResponse {
  final int? status;
  final String? message;
  final UserDetailData? data;

  GetUserDetailResponse({
    this.status,
    this.message,
    this.data,
  });

  factory GetUserDetailResponse.fromJson(Map<String, dynamic> json) {
    return GetUserDetailResponse(
      status: json['status'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? UserDetailData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class UserDetailData {
  final int? id;
  final String? email;
  final String? deviceId;
  final String? fullName;
  final String? userName;
  final String? phoneNumber;
  final bool? isActive;
  final bool? isDeleted;
  final bool? isSocialLogin;
  final bool? isVerified;
  final int? followingCount;
  final int? followersCount;
  final double? latitude;
  final double? longitude;
  final String? bio;
  final String? profileImageUrl;
  final String? createdAt;
  final String? updatedAt;
  final List<Post>? posts;
  final List<PostLike>? postLikes;
  final List<PostComment>? postComments;
  final List<PostShare>? postShares;
  final List<Follow>? follows;
  final List<FollowedByUser>? followedByUsers;
  final List<dynamic>? blockedUsers;
  final List<dynamic>? blockedBy;

  UserDetailData({
    this.id,
    this.email,
    this.deviceId,
    this.fullName,
    this.userName,
    this.phoneNumber,
    this.isActive,
    this.isDeleted,
    this.isSocialLogin,
    this.isVerified,
    this.followingCount,
    this.followersCount,
    this.latitude,
    this.longitude,
    this.bio,
    this.profileImageUrl,
    this.createdAt,
    this.updatedAt,
    this.posts,
    this.postLikes,
    this.postComments,
    this.postShares,
    this.follows,
    this.followedByUsers,
    this.blockedUsers,
    this.blockedBy,
  });

  factory UserDetailData.fromJson(Map<String, dynamic> json) {
    return UserDetailData(
      id: json['id'] as int?,
      email: json['email'] as String?,
      deviceId: json['deviceId']?.toString(),
      fullName: json['fullName'] as String?,
      userName: json['userName'] as String?,
      phoneNumber: json['phoneNumber']?.toString(),
      isActive: json['isActive'] as bool?,
      isDeleted: json['isDeleted'] as bool?,
      isSocialLogin: json['isSocialLogin'] as bool?,
      isVerified: json['isVerified'] as bool?,
      followingCount: json['followingCount'] as int?,
      followersCount: json['followersCount'] as int?,
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      bio: json['bio'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      posts: (json['posts'] as List<dynamic>?)
          ?.map((item) => Post.fromJson(item as Map<String, dynamic>))
          .toList(),
      postLikes: (json['postLikes'] as List<dynamic>?)
          ?.map((item) => PostLike.fromJson(item as Map<String, dynamic>))
          .toList(),
      postComments: (json['postComments'] as List<dynamic>?)
          ?.map((item) => PostComment.fromJson(item as Map<String, dynamic>))
          .toList(),
      postShares: (json['postShares'] as List<dynamic>?)
          ?.map((item) => PostShare.fromJson(item as Map<String, dynamic>))
          .toList(),
      follows: (json['follows'] as List<dynamic>?)
          ?.map((item) => Follow.fromJson(item as Map<String, dynamic>))
          .toList(),
      followedByUsers: (json['followedByUsers'] as List<dynamic>?)
          ?.map((item) => FollowedByUser.fromJson(item as Map<String, dynamic>))
          .toList(),
      blockedUsers: json['blockedUsers'] as List<dynamic>?,
      blockedBy: json['blockedBy'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'deviceId': deviceId,
      'fullName': fullName,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'isActive': isActive,
      'isDeleted': isDeleted,
      'isSocialLogin': isSocialLogin,
      'isVerified': isVerified,
      'followingCount': followingCount,
      'followersCount': followersCount,
      'latitude': latitude,
      'longitude': longitude,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'posts': posts?.map((item) => item.toJson()).toList(),
      'postLikes': postLikes?.map((item) => item.toJson()).toList(),
      'postComments': postComments?.map((item) => item.toJson()).toList(),
      'postShares': postShares?.map((item) => item.toJson()).toList(),
      'follows': follows?.map((item) => item.toJson()).toList(),
      'followedByUsers': followedByUsers?.map((item) => item.toJson()).toList(),
      'blockedUsers': blockedUsers,
      'blockedBy': blockedBy,
    };
  }
}

class Post {
  final int? id;
  final String? type;
  final String? status;
  final String? publishDate;
  final String? description;
  final String? coverImage;
  final String? link;
  final int? likesCount;
  final int? shareCount;
  final int? commentCount;
  final String? overallAvgRating;
  final int? userId;
  final int? producerId;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final bool? isDeleted;
  final List<PostImage>? images;
  final List<PostComment>? comments;
  final List<PostLike>? likes;

  Post({
    this.id,
    this.type,
    this.status,
    this.publishDate,
    this.description,
    this.coverImage,
    this.link,
    this.likesCount,
    this.shareCount,
    this.commentCount,
    this.overallAvgRating,
    this.userId,
    this.producerId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isDeleted,
    this.images,
    this.comments,
    this.likes,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int?,
      type: json['type'] as String?,
      status: json['status'] as String?,
      publishDate: json['publishDate'] as String?,
      description: json['description'] as String?,
      coverImage: json['coverImage'] as String?,
      link: json['link'] as String?,
      likesCount: json['likesCount'] as int?,
      shareCount: json['shareCount'] as int?,
      commentCount: json['commentCount'] as int?,
      overallAvgRating: json['overallAvgRating']?.toString(),
      userId: json['userId'] as int?,
      producerId: json['producerId'] as int?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      deletedAt: json['deletedAt'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      images: (json['images'] as List<dynamic>?)
          ?.map((item) => PostImage.fromJson(item as Map<String, dynamic>))
          .toList(),
      comments: (json['comments'] as List<dynamic>?)
          ?.map((item) => PostComment.fromJson(item as Map<String, dynamic>))
          .toList(),
      likes: (json['likes'] as List<dynamic>?)
          ?.map((item) => PostLike.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'status': status,
      'publishDate': publishDate,
      'description': description,
      'coverImage': coverImage,
      'link': link,
      'likesCount': likesCount,
      'shareCount': shareCount,
      'commentCount': commentCount,
      'overallAvgRating': overallAvgRating,
      'userId': userId,
      'producerId': producerId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'isDeleted': isDeleted,
      'images': images?.map((item) => item.toJson()).toList(),
      'comments': comments?.map((item) => item.toJson()).toList(),
      'likes': likes?.map((item) => item.toJson()).toList(),
    };
  }
}

class PostImage {
  final int? id;
  final int? postId;
  final String? url;
  final bool? isCoverImage;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final bool? isDeleted;

  PostImage({
    this.id,
    this.postId,
    this.url,
    this.isCoverImage,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isDeleted,
  });

  factory PostImage.fromJson(Map<String, dynamic> json) {
    return PostImage(
      id: json['id'] as int?,
      postId: json['postId'] as int?,
      url: json['url'] as String?,
      isCoverImage: json['isCoverImage'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      deletedAt: json['deletedAt'] as String?,
      isDeleted: json['isDeleted'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'url': url,
      'isCoverImage': isCoverImage,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'isDeleted': isDeleted,
    };
  }
}

class PostComment {
  final int? id;
  final int? userId;
  final int? postId;
  final String? comment;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final bool? isDeleted;

  PostComment({
    this.id,
    this.userId,
    this.postId,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isDeleted,
  });

  factory PostComment.fromJson(Map<String, dynamic> json) {
    return PostComment(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      postId: json['postId'] as int?,
      comment: json['comment'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      deletedAt: json['deletedAt'] as String?,
      isDeleted: json['isDeleted'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'postId': postId,
      'comment': comment,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'isDeleted': isDeleted,
    };
  }
}

class PostLike {
  final int? id;
  final int? userId;
  final int? postId;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final bool? isDeleted;

  PostLike({
    this.id,
    this.userId,
    this.postId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isDeleted,
  });

  factory PostLike.fromJson(Map<String, dynamic> json) {
    return PostLike(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      postId: json['postId'] as int?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      deletedAt: json['deletedAt'] as String?,
      isDeleted: json['isDeleted'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'postId': postId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'isDeleted': isDeleted,
    };
  }
}

class PostShare {
  final int? id;
  final int? userId;
  final int? postId;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final bool? isDeleted;

  PostShare({
    this.id,
    this.userId,
    this.postId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isDeleted,
  });

  factory PostShare.fromJson(Map<String, dynamic> json) {
    return PostShare(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      postId: json['postId'] as int?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      deletedAt: json['deletedAt'] as String?,
      isDeleted: json['isDeleted'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'postId': postId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'isDeleted': isDeleted,
    };
  }
}

class Follow {
  final int? id;
  final int? followerId;
  final int? producerId;
  final int? followedUserId;
  final String? status;
  final String? createdAt;

  Follow({
    this.id,
    this.followerId,
    this.producerId,
    this.followedUserId,
    this.status,
    this.createdAt,
  });

  factory Follow.fromJson(Map<String, dynamic> json) {
    return Follow(
      id: json['id'] as int?,
      followerId: json['followerId'] as int?,
      producerId: json['producerId'] as int?,
      followedUserId: json['followedUserId'] as int?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'followerId': followerId,
      'producerId': producerId,
      'followedUserId': followedUserId,
      'status': status,
      'createdAt': createdAt,
    };
  }
}

class FollowedByUser {
  final int? id;
  final int? followerId;
  final int? producerId;
  final int? followedUserId;
  final String? status;
  final String? createdAt;

  FollowedByUser({
    this.id,
    this.followerId,
    this.producerId,
    this.followedUserId,
    this.status,
    this.createdAt,
  });

  factory FollowedByUser.fromJson(Map<String, dynamic> json) {
    return FollowedByUser(
      id: json['id'] as int?,
      followerId: json['followerId'] as int?,
      producerId: json['producerId'] as int?,
      followedUserId: json['followedUserId'] as int?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'followerId': followerId,
      'producerId': producerId,
      'followedUserId': followedUserId,
      'status': status,
      'createdAt': createdAt,
    };
  }
}

double? _toDouble(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is double) {
    return value;
  }
  if (value is int) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value);
  }
  return null;
}
