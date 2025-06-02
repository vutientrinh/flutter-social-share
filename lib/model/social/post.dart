import 'package:flutter_social_share/model/social/topic.dart';
import 'package:flutter_social_share/model/user.dart';
import 'package:flutter_social_share/model/user_infor.dart';

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
  final TopicResponse topic;
  final UserInfo author;
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

  Post copyWith({
    String? id,
    String? content,
    List<String>? images,
    String? authorId,
    String? topicId,
    int? commentCount,
    int? likedCount,
    String? type,
    String? status,
    String? createdAt,
    String? updatedAt,
    TopicResponse? topic,
    UserInfo? author,
    bool? hasLiked,
    bool? hasSaved,
  }) {
    return Post(
      id: id ?? this.id,
      content: content ?? this.content,
      images: images ?? this.images,
      authorId: authorId ?? this.authorId,
      topicId: topicId ?? this.topicId,
      commentCount: commentCount ?? this.commentCount,
      likedCount: likedCount ?? this.likedCount,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      topic: topic ?? this.topic,
      author: author ?? this.author,
      hasLiked: hasLiked ?? this.hasLiked,
      hasSaved: hasSaved ?? this.hasSaved,
    );
  }

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
      topic: TopicResponse.fromJson(json['topic']),
      author: UserInfo.fromJson(json['author']),
      hasLiked: json['hasLiked'] as bool,
      hasSaved: json['hasSaved'] as bool,
    );
  }
}


class TopicResponse {
  final String id;
  final String name;
  final int postCount;
  final String color;

  TopicResponse({
    required this.id,
    required this.name,
    required this.postCount,
    required this.color,
  });

  factory TopicResponse.fromJson(Map<String, dynamic> json) {
    return TopicResponse(
      id: json['id'],
      name: json['name'],
      postCount: json['postCount'],
      color: json['color'],
    );
  }
}
