import 'package:flutter_social_share/model/user_infor.dart';

class AppNotification {
  final String id;
  final String content;
  final String messageType;
  final UserInfo actor;
  final bool isRead;
  final String createdAt;
  final String updatedAt;

  AppNotification({
    required this.id,
    required this.content,
    required this.messageType,
    required this.actor,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      content: json['content'],
      messageType: json['messageType'],
      actor: UserInfo.fromJson(json['actor']),
      isRead: json['isRead'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
