import 'dart:io';

class Topic {
  final String id;
  final String name;
  final int postCount;
  final String color;
  final String createdAt;
  final String updatedAt;

  Topic({
    required this.id,
    required this.name,
    required this.postCount,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'],
      name: json['name'],
      postCount: json['postCount'],
      color: json['color'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
