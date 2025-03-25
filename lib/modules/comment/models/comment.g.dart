// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] as String?,
      status: json['status'] as int?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      content: json['content'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      liked: json['liked'] as bool?,
      likeCounts: json['like_count'] as int?,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('status', instance.status);
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  writeNotNull('content', instance.content);
  writeNotNull('user', instance.user);
  writeNotNull('liked', instance.liked);
  writeNotNull('like_count', instance.likeCounts);
  return val;
}
