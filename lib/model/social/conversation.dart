class Conversation {
  final String id;
  final String content;
  final String messageType;
  final String senderId;
  final String senderUsername;
  final String receiverId;
  final String receiverUsername;
  final String? userConnection;
  final String? messageDeliveryStatusEnum;
  final String? messageDeliveryStatusUpdates;
  final String? time;
  final String? lastModified;

  Conversation({
    required this.id,
    required this.content,
    required this.messageType,
    required this.senderId,
    required this.senderUsername,
    required this.receiverId,
    required this.receiverUsername,
    this.userConnection,
    this.messageDeliveryStatusEnum,
    this.messageDeliveryStatusUpdates,
    this.time,
    this.lastModified,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      content: json['content'],
      messageType: json['messageType'],
      senderId: json['senderId'] ?? '',
      senderUsername: json['senderUsername'],
      receiverId: json['receiverId'],
      receiverUsername: json['receiverUsername'],
      userConnection: json['userConnection'],
      messageDeliveryStatusEnum: json['messageDeliveryStatusEnum'],
      messageDeliveryStatusUpdates: json['messageDeliveryStatusUpdates'],
      time: json['time'],
      lastModified: json['lastModified']
    );
  }
}
