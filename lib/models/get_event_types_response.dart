class GetEventTypesResponse {
  final String? message;
  final List<EventType> data;

  GetEventTypesResponse({this.message, List<EventType>? data})
      : data = data ?? [];

  factory GetEventTypesResponse.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List<dynamic>? ?? [];
    return GetEventTypesResponse(
      message: json['message'],
      data: list.map((e) => EventType.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class EventType {
  final int id;
  final String name;
  final List<String> criteria;
  final DateTime createdAt;
  final DateTime updatedAt;

  EventType({
    required this.id,
    required this.name,
    List<String>? criteria,
    required this.createdAt,
    required this.updatedAt,
  }) : criteria = criteria ?? [];


  factory EventType.fromJson(Map<String, dynamic> json) {
    return EventType(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      criteria: List<String>.from(json['criteria'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'criteria': criteria,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
