import 'package:flutter_social_share/model/post.dart';
import 'package:flutter_social_share/model/user.dart';

class Comment {
  final String id;
  final String authorId;
  final String postId;
  final String? content;
  final User? author;
  final Post? post;
  final int? likedCount;
  final bool hasLiked;
  final String? status;

  Comment({
    required this.id,
    required this.authorId,
    required this.postId,
    this.content,
    this.author,
    this.post,
    this.likedCount,
    required this.hasLiked,
    this.status,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      authorId: json['authorId'],
      postId: json['postId'],
      content: json['content'],
      author: json['author'] != null ? User.fromJson(json['author']) : null,
      post: json['post'] != null ? Post.fromJson(json['post']) : null,
      likedCount: json['likedCount'],
      hasLiked: json['hasLiked'],
      status: json['status'],
    );
  }
}
