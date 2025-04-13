import 'package:flutter_social_share/model/post.dart';
import 'package:flutter_social_share/model/user.dart';

class Comment {
  final String id;
  final User author;
  final Post post;
  final String? content;
  final int? likedCount;
  final String? status;

  Comment({
    required this.id,
    required this.author,
    required this.post,
    this.content,
    this.likedCount,
    this.status,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      author: User.fromJson(json['author']),
      post: Post.fromJson(json['post']),
      content: json['content'],
      likedCount: json['likedCount'],
      status: json['status'],
    );
  }
}
