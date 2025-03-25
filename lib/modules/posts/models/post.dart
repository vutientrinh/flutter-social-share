import 'package:flutter_social_share/modules/posts/models/photo.dart';
import 'package:flutter_social_share/modules/posts/models/picture.dart';
import 'package:flutter_social_share/modules/posts/models/user.dart';
import 'package:flutter_social_share/utils/string_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  @JsonKey(name: 'id', includeIfNull: false)
  final String? id;

  @JsonKey(name: 'status', includeIfNull: false)
  final int? status;

  @JsonKey(name: 'title', includeIfNull: false)
  final String? title;

  @JsonKey(name: 'description', includeIfNull: false)
  final String? description;

  @JsonKey(name: 'images', includeIfNull: false)
  final List<Picture>? images;

  @JsonKey(name: 'photos', includeIfNull: false)
  final List<Photo>? photos;

  @JsonKey(name: 'comment_counts', includeIfNull: false)
  final int? commentCounts;

  @JsonKey(name: 'like_counts', includeIfNull: false)
  int? likeCounts;

  @JsonKey(name: 'liked', includeIfNull: false)
  bool? liked;

  @JsonKey(name: 'user', includeIfNull: false)
  final User? user;

  @JsonKey(name: 'created_at', includeIfNull: false)
  final DateTime? createdAt;

  Post({
    this.id,
    this.status,
    this.title,
    this.description,
    this.images,
    this.photos,
    this.commentCounts,
    this.likeCounts,
    this.liked,
    this.user,
    this.createdAt,
  });

  String? get urlUserAvatar => user?.imgUrl;

  String get displayName => user?.displayName ?? '';

  String get displayTimePostCreated =>
      StringUtils?.calcTimePost(createdAt ?? DateTime.now()) ?? '';

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}
