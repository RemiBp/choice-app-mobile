class GetMyBlocksResponse {
  final int? status;
  final String? message;
  final List<BlockItem>? data;

  GetMyBlocksResponse({
    this.status,
    this.message,
    this.data,
  });

  factory GetMyBlocksResponse.fromJson(Map<String, dynamic> json) {
    return GetMyBlocksResponse(
      status: json['status'] as int?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => BlockItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

class BlockItem {
  final int? id;
  final int? blockerId;
  final int? blockedUserId;
  final String? createdAt;
  final BlockedUser? blockedUser;

  BlockItem({
    this.id,
    this.blockerId,
    this.blockedUserId,
    this.createdAt,
    this.blockedUser,
  });

  factory BlockItem.fromJson(Map<String, dynamic> json) {
    return BlockItem(
      id: json['id'] as int?,
      blockerId: json['blockerId'] as int?,
      blockedUserId: json['blockedUserId'] as int?,
      createdAt: json['createdAt'] as String?,
      blockedUser: json['blockedUser'] != null
          ? BlockedUser.fromJson(json['blockedUser'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'blockerId': blockerId,
      'blockedUserId': blockedUserId,
      'createdAt': createdAt,
      'blockedUser': blockedUser?.toJson(),
    };
  }
}

class BlockedUser {
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

  BlockedUser({
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
  });

  factory BlockedUser.fromJson(Map<String, dynamic> json) {
    return BlockedUser(
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
