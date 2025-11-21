class EventTypeModel {
  final int id;
  final String name;
  final List<String> criteria;
  final DateTime createdAt;
  final DateTime updatedAt;

  EventTypeModel({
    required this.id,
    required this.name,
    List<String>? criteria,
    required this.createdAt,
    required this.updatedAt,
  }) : criteria = criteria ?? [];

  factory EventTypeModel.fromJson(Map<String, dynamic> json) {
    return EventTypeModel(
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
