class ProducerPostsResponse {
  int? status;
  String? message;
  List<Data>? data;

  ProducerPostsResponse({this.status, this.message, this.data});

  ProducerPostsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add( Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? type;
  String? status;
  String? publishDate;
  String? description;
  String? coverImage;
  String? link;
  int? likesCount;
  int? shareCount;
  int? commentCount;
  String? overallAvgRating;
  String? userId;
  int? producerId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  bool? isDeleted;
  List<Images>? images;
  List<PostTags>? postTags;

  Data(
      {this.id,
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
        this.postTags});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    status = json['status'];
    publishDate = json['publishDate'];
    description = json['description'];
    coverImage = json['coverImage'];
    link = json['link'];
    likesCount = json['likesCount'];
    shareCount = json['shareCount'];
    commentCount = json['commentCount'];
    overallAvgRating = json['overallAvgRating'];
    userId = json['userId'];
    producerId = json['producerId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    isDeleted = json['isDeleted'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
    if (json['postTags'] != null) {
      postTags = <PostTags>[];
      json['postTags'].forEach((v) {
        postTags!.add(PostTags.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['type'] = type;
    data['status'] = status;
    data['publishDate'] = publishDate;
    data['description'] = description;
    data['coverImage'] = coverImage;
    data['link'] = link;
    data['likesCount'] = likesCount;
    data['shareCount'] = shareCount;
    data['commentCount'] = commentCount;
    data['overallAvgRating'] = overallAvgRating;
    data['userId'] = userId;
    data['producerId'] = producerId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    data['isDeleted'] = isDeleted;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    if (postTags != null) {
      data['postTags'] = postTags!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PostTags {
  int? id;
  int? userId;
  int? postId;
  int? tagId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  bool? isDeleted;
  Tag? tag;

  PostTags({
    this.id,
    this.userId,
    this.postId,
    this.tagId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isDeleted,
    this.tag,
  });

  PostTags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    postId = json['postId'];
    tagId = json['tagId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    isDeleted = json['isDeleted'];

    tag = json['tag'] != null ? Tag.fromJson(json['tag']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['postId'] = postId;
    data['tagId'] = tagId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    data['isDeleted'] = isDeleted;

    if (tag != null) {
      data['tag'] = tag!.toJson();
    }
    return data;
  }
}
class Tag {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  Tag({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  Tag.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}



class Images {
  int? id;
  int? postId;
  String? url;
  bool? isCoverImage;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  bool? isDeleted;

  Images(
      {this.id,
        this.postId,
        this.url,
        this.isCoverImage,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.isDeleted});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['postId'];
    url = json['url'];
    isCoverImage = json['isCoverImage'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    isDeleted = json['isDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['postId'] = postId;
    data['url'] = url;
    data['isCoverImage'] = isCoverImage;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    data['isDeleted'] = isDeleted;
    return data;
  }
}
