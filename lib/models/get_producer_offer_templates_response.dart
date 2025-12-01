class GetProducerOfferTemplatesResponse {
  final int status;
  final String message;
  final List<OfferTemplateItem> data;

  GetProducerOfferTemplatesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetProducerOfferTemplatesResponse.fromJson(Map<String, dynamic> json) {
    return GetProducerOfferTemplatesResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List?)
          ?.map((e) => OfferTemplateItem.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

class OfferTemplateItem {
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
  final DateTime? scheduledAt;
  final DateTime? expiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  OfferTemplateItem({
    required this.id,
    required this.producerId,
    required this.title,
    required this.message,
    required this.discountPercent,
    required this.validityMinutes,
    required this.maxRecipients,
    required this.radiusMeters,
    required this.imageUrl,
    required this.timeOfDay,
    required this.daysOfWeek,
    required this.status,
    required this.isTemplate,
    required this.scheduledAt,
    required this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OfferTemplateItem.fromJson(Map<String, dynamic> json) {
    return OfferTemplateItem(
      id: json['id'] ?? 0,
      producerId: json['producerId'] ?? json['producerId'] ?? 0,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      discountPercent: json['discountPercent'] ?? json['discountPercent'] ?? 0,
      validityMinutes: json['validityMinutes'] ?? 0,
      maxRecipients: json['maxRecipients'] ?? 0,
      radiusMeters: json['radiusMeters'] ?? 0,
      imageUrl: json['imageUrl'],
      timeOfDay: json['timeOfDay'] ?? 'ALL_DAY',
      daysOfWeek:
      (json['daysOfWeek'] as List?)?.map((e) => e.toString()).toList() ?? [],
      status: json['status'] ?? 'ACTIVE',
      isTemplate: json['isTemplate'] ?? json['isTemplate'] ?? false,
      scheduledAt: json['scheduledAt'] != null
          ? DateTime.parse(json['scheduledAt'])
          : null,
      expiresAt:
      json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'producerId': producerId,
    'title': title,
    'message': message,
    'discountPercent': discountPercent,
    'validityMinutes': validityMinutes,
    'maxRecipients': maxRecipients,
    'radiusMeters': radiusMeters,
    'imageUrl': imageUrl,
    'timeOfDay': timeOfDay,
    'daysOfWeek': daysOfWeek,
    'status': status,
    'isTemplate': isTemplate,
    'scheduledAt': scheduledAt?.toIso8601String(),
    'expiresAt': expiresAt?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}
