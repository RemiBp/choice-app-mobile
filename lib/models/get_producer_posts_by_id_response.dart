class GetProducerPostsByIdResponse {
  int id;
  String type;
  String status;
  String? publishDate;
  String description;
  String? coverImage;
  String? link;
  int producerId;
  List<PostImage> images;
  Producer producer;

  GetProducerPostsByIdResponse({
    required this.id,
    required this.type,
    required this.status,
    this.publishDate,
    required this.description,
    this.coverImage,
    this.link,
    required this.producerId,
    required this.images,
    required this.producer,
  });

  factory GetProducerPostsByIdResponse.fromJson(Map<String, dynamic> json) {
    return GetProducerPostsByIdResponse(
      id: json['id'],
      type: json['type'],
      status: json['status'],
      publishDate: json['publishDate'],
      description: json['description'],
      coverImage: json['coverImage'],
      link: json['link'],
      producerId: json['producerId'],
      images: (json['images'] as List<dynamic>)
          .map((e) => PostImage.fromJson(e))
          .toList(),
      producer: Producer.fromJson(json['producer']),
    );
  }
}

class PostImage {
  int id;
  int postId;
  String url;
  bool isCoverImage;

  PostImage({
    required this.id,
    required this.postId,
    required this.url,
    required this.isCoverImage,
  });

  factory PostImage.fromJson(Map<String, dynamic> json) {
    return PostImage(
      id: json['id'],
      postId: json['postId'],
      url: json['url'],
      isCoverImage: json['isCoverImage'],
    );
  }
}

class Producer {
  int id;
  String name;
  String address;
  String? website;

  Producer({
    required this.id,
    required this.name,
    required this.address,
    this.website,
  });

  factory Producer.fromJson(Map<String, dynamic> json) {
    return Producer(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      website: json['website'],
    );
  }
}
