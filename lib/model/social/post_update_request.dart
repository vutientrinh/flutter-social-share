import 'dart:io';

class PostUpdateRequest {
  final String content;
  final List<File> images;
  final String topicId;
  final String status;
  final String type;

  PostUpdateRequest({
    required this.content,
    required this.images,
    required this.topicId,
    required this.status,
    required this.type,
  });

  factory PostUpdateRequest.fromJson(Map<String, dynamic> json) {
    return PostUpdateRequest(
      content: json['content'],
      images: json['images'],
      topicId: json['topicId'],
      status: json['status'],
      type: json['type']
    );
  }
}
