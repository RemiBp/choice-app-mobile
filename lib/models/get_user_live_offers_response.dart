class LiveOffer {
  final int id;
  final int producerId;
  final String title;
  final String message;
  final int discountPercent;
  final int validityMinutes;
  final int maxRecipients;
  final int radiusMeters;
  final String? imageUrl;
  final String timeOfDay;
  final List<String> daysOfWeek;
  final String status;
  final bool isTemplate;
  final String scheduledAt;
  final String expiresAt;
  final String createdAt;
  final String updatedAt;

  // New fields
  final String producerName;
  final String producerImage;

  LiveOffer({
    required this.id,
    required this.producerId,
    required this.title,
    required this.message,
    required this.discountPercent,
    required this.validityMinutes,
    required this.maxRecipients,
    required this.radiusMeters,
    this.imageUrl,
    required this.timeOfDay,
    required this.daysOfWeek,
    required this.status,
    required this.isTemplate,
    required this.scheduledAt,
    required this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
    required this.producerName,
    required this.producerImage,
  });

  factory LiveOffer.fromJson(Map<String, dynamic> json) {
    return LiveOffer(
      id: json["id"],
      producerId: json["producerId"],
      title: json["title"],
      message: json["message"],
      discountPercent: json["discountPercent"],
      validityMinutes: json["validityMinutes"],
      maxRecipients: json["maxRecipients"],
      radiusMeters: json["radiusMeters"],
      imageUrl: json["imageUrl"],
      timeOfDay: json["timeOfDay"],
      daysOfWeek: List<String>.from(json["daysOfWeek"]),
      status: json["status"],
      isTemplate: json["isTemplate"],
      scheduledAt: json["scheduledAt"],
      expiresAt: json["expiresAt"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      producerName: json["producerName"],
      producerImage: json["producerImage"],
    );
  }
}


class GetUserLiveOffersResponse {
  final int status;
  final String message;
  final List<LiveOffer> data;

  GetUserLiveOffersResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetUserLiveOffersResponse.fromJson(Map<String, dynamic> json) {
    return GetUserLiveOffersResponse(
      status: json["status"],
      message: json["message"],
      data: (json["data"] as List)
          .map((item) => LiveOffer.fromJson(item))
          .toList(),
    );
  }
}
