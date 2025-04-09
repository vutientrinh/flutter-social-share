class Conversation {
  final String id;
  final String? convId;
  final String fromUser;
  final String toUser;
  final DateTime? time;
  final DateTime? lastModified;
  final String? content;
  final dynamic deliveryStatus;

  Conversation({
    required this.id,
    this.convId,
    required this.fromUser,
    required this.toUser,
    this.time,
    this.lastModified,
    this.content,
    this.deliveryStatus,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      convId: json['convId'],
      fromUser: json['fromUser'],
      toUser: json['toUser'],
      time: json['time'] != null ? DateTime.parse(json['time']) : null,
      lastModified: json['lastModified'] != null ? DateTime.parse(json['lastModified']) : null,
      content: json['content'],
      deliveryStatus: json['deliveryStatus'],
    );
  }

}
