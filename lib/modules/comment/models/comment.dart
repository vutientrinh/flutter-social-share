import 'package:flutter_social_share/modules/posts/models/user.dart';
import 'package:flutter_social_share/utils/string_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  @JsonKey(name: 'id', includeIfNull: false)
  String? id;

  @JsonKey(name: 'status', includeIfNull: false)
  final int? status;

  @JsonKey(name: 'created_at', includeIfNull: false)
  DateTime? createdAt;

  @JsonKey(name: 'content', includeIfNull: false)
  String? content;

  @JsonKey(name: 'user', includeIfNull: false)
  User? user;

  @JsonKey(name: 'liked', includeIfNull: false)
  bool? liked;

  @JsonKey(name: 'like_count', includeIfNull: false)
  int? likeCounts;

  String get ownerId => user?.id ?? '';

  Comment({
    this.id,
    this.status,
    this.createdAt,
    this.content,
    this.user,
    this.liked,
    this.likeCounts,
  });

  String get displayName => user?.displayName ?? '';

  String? get urlUserAvatar => user?.imgUrl;

  String get displayTimePostCreated =>
      StringUtils?.calcTimePost(createdAt ?? DateTime.now()) ?? '';

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
