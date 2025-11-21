class ProducerBookingSlotsResponse {
  Map<String, List<Slot>> slots;

  ProducerBookingSlotsResponse({required this.slots});

  factory ProducerBookingSlotsResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawSlots = json['slots'] ?? [];
    final Map<String, List<Slot>> grouped = {};

    for (var slotJson in rawSlots) {
      final slot = Slot.fromJson(slotJson);
      grouped.putIfAbsent(slot.day, () => []).add(slot);
    }

    return ProducerBookingSlotsResponse(slots: grouped);
  }
}

class Slot {
  final int id;
  final String day;
  final String startTime;
  final String endTime;
  final int userId;
  final bool isDeleted;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  Slot({
    required this.id,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.userId,
    required this.isDeleted,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      id: json['id'],
      day: json['day'] ?? "",
      startTime: json['startTime'] ?? "",
      endTime: json['endTime'] ?? "",
      userId: json['userId'] ?? 0,
      isDeleted: json['isDeleted'] ?? false,
      isActive: json['isActive'] ?? false,
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
    );
  }
}
