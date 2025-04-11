import 'package:flutter_social_share/model/topic.dart';
import 'package:flutter_social_share/model/user.dart';

class Post {
  final String id;
  final String content;
  final List<String> images;
  final String authorId;
  final String topicId;
  final int commentCount;
  final int likedCount;
  final String type;
  final String status;
  final String createdAt;
  final String updatedAt;
  final Topic topic;
  final User author;
  final bool hasLiked;
  final bool hasSaved;

  Post({
    required this.id,
    required this.content,
    required this.images,
    required this.authorId,
    required this.topicId,
    required this.commentCount,
    required this.likedCount,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.topic,
    required this.author,
    required this.hasLiked,
    required this.hasSaved,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      content: json['content'],
      images: List<String>.from(json['images']),
      authorId: json['authorId'],
      topicId: json['topicId'],
      commentCount: json['commentCount'],
      likedCount: json['likedCount'],
      type: json['type'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      topic: Topic.fromJson(json['topic']),
      author: User.fromJson(json['author']),
      hasLiked: json['hasLiked'] as bool,
      hasSaved: json['hasSaved'],
    );
  }
}