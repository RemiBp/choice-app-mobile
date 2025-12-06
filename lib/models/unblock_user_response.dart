class UnblockUserResponse {
  final int? status;
  final String? message;
  final UnblockUserData? data;

  UnblockUserResponse({
    this.status,
    this.message,
    this.data,
  });

  factory UnblockUserResponse.fromJson(Map<String, dynamic> json) {
    return UnblockUserResponse(
      status: json['status'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? UnblockUserData.fromJson(json['data'] as Map<String, dynamic>)
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

class UnblockUserData {
  final int? blockerId;
  final int? blockedUserId;
  final String? createdAt;

  UnblockUserData({
    this.blockerId,
    this.blockedUserId,
    this.createdAt,
  });

  factory UnblockUserData.fromJson(Map<String, dynamic> json) {
    return UnblockUserData(
      blockerId: json['blockerId'] as int?,
      blockedUserId: json['blockedUserId'] as int?,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'blockerId': blockerId,
      'blockedUserId': blockedUserId,
      'createdAt': createdAt,
    };
  }
}
