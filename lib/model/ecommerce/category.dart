class Category {
  final String id;
  final String name;
  final String description;
  final String createdAt;
  final String updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
