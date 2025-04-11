import 'dart:io';

class PostRequest {
  final String content;
  final List<File> images;
  final String authorId;
  final String topicId;

  PostRequest({
    required this.content,
    required this.images,
    required this.authorId,
    required this.topicId,

  });

  factory PostRequest.fromJson(Map<String, dynamic> json) {
    return PostRequest(
      content: json['content'],
      images: json['images'],
      authorId: json['authorId'],
      topicId: json['topicId'],
    );
  }
}
