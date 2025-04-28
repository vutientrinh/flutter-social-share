import 'package:flutter_social_share/model/social/post.dart';
import 'package:flutter_social_share/model/user.dart';
import 'package:flutter_social_share/model/user_infor.dart';

class Comment {
  final String id;
  final String authorId;
  final String postId;
  final String? content;
  final UserInfo author;
  final int? likedCount;
  final bool hasLiked;
  final String? status;

  Comment({
    required this.id,
    required this.authorId,
    required this.postId,
    this.content,
    required this.author,
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
      author: UserInfo.fromJson(json['author']),
      likedCount: json['likedCount'],
      hasLiked: json['hasLiked'],
      status: json['status'],
    );
  }
}
