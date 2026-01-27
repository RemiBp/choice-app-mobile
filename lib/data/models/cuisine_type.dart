class CuisineType {
  final int id;
  final String name;

  CuisineType({required this.id, required this.name});

  factory CuisineType.fromJson(Map<String, dynamic> json) {
    return CuisineType(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}
