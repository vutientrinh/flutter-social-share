import 'dart:io';

class Post {
  final String content;
  final List<File> images;
  final String authorId;
  final String topicId;

  Post({
    required this.content,
    required this.images,
    required this.authorId,
    required this.topicId,

  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      content: json['content'],
      images: json['images'],
      authorId: json['authorId'],
      topicId: json['topicId'],
    );
  }
}
