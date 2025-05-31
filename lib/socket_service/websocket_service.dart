import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_social_share/model/social/conversation.dart';
import 'package:flutter_social_share/model/social/friend_connection.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import '../model/social/notification.dart';
import '../services/auth_service.dart';

enum SubscriptionType { chat, notifications, both }

class WebSocketService {
  late StompClient _stompClient;
  final String userId;
  final Function(dynamic) onMessageReceived;
  String? token;
  AuthService authService;

  WebSocketService({
    required this.userId,
    required this.authService,
    required this.onMessageReceived,
  });

  void connect(
      {SubscriptionType subscriptionType = SubscriptionType.both}) async {
    final data = await authService.getSavedData();
    token = data['token'];

    _stompClient = StompClient(
      config: StompConfig(
        url: dotenv.env['SOCKET_URL'] ?? 'ws://34.126.161.244.nip.io:8280/ws',
        beforeConnect: () async {
          print("Connecting...");
        },
        stompConnectHeaders: {
          'Authorization': 'Bearer $token',
        },
        onConnect: (frame) => _onConnect(frame, subscriptionType),
        onDisconnect: (frame) {
          print("🔁 Reconnecting in 3 seconds...");
          Future.delayed(const Duration(seconds: 3), () {
            if (!_stompClient.connected) {
              print("🔄 Reconnecting now...");
              _stompClient.activate();
            }
          });
        },
        onWebSocketError: (dynamic error) => print("WebSocket Error: $error"),
      ),
    );

    _stompClient.activate();
  }

  void _onConnect(StompFrame frame, SubscriptionType subscriptionType) {
    print("Connected to WebSocket ✅");

    if (subscriptionType == SubscriptionType.chat ||
        subscriptionType == SubscriptionType.both) {
      _subscribeToTopic("/topic/$userId");
    }

    if (subscriptionType == SubscriptionType.notifications ||
        subscriptionType == SubscriptionType.both) {
      _subscribeToTopic("/topic/notifications/$userId");
    }
  }

  void _subscribeToTopic(String topic) {
    _stompClient.subscribe(
      destination: topic,
      callback: (StompFrame frame) {
        if (frame.body != null) {
          final Map<String, dynamic> data = json.decode(frame.body!);

          // Decide model based on `messageType` or other keys
          final type = data['messageType'];

          if (_isNotificationType(type)) {
            final notification = AppNotification.fromJson(data);
            _handleNotification(notification);
          } else if (_isConversationType(type)) {
            final conversation = Conversation.fromJson(data);
            _handleConversation(conversation);
          } else {
            print("⚠️ Unknown message type: $type");
            onMessageReceived(data); // fallback: raw data
          }
        }
      },
    );
  }

  bool _isNotificationType(String type) {
    const notificationTypes = [
      "LIKE_COUNT",
      "FOLLOW_COUNT",
      "POST_COUNT",
      "COMMENT_POST_COUNT",
      "COMMENT_LIKED_COUNT",
      "LIKE_POST",
      "FOLLOW_USER",
      "COMMENT_POST",
      "COMMENT_LIKED",
      "FRIEND_REQUEST",
      "FRIEND_REQUEST_ACCEPTED",
    ];
    return notificationTypes.contains(type);
  }

  bool _isConversationType(String type) {
    const conversationTypes = [
      "CHAT",
      "UNSEEN",
      "FRIEND_OFFLINE",
      "FRIEND_ONLINE",
      "MESSAGE_DELIVERY_UPDATE",
    ];
    return conversationTypes.contains(type);
  }

  void _handleNotification(AppNotification notification) {
    print("📥 Received notification: ${notification.messageType}");
    onMessageReceived(notification);
  }

  void _handleConversation(Conversation conversation) {
    print("📥 Received conversation: ${conversation.messageType}");
    onMessageReceived(conversation);
  }

  void sendMessage(
    String message,
    String convId,
    String connectionId,
    String connectionUsername,
  ) {
    if (_stompClient.connected) {
      final body = json.encode({
        "messageType": "CHAT",
        "content": message,
        "receiverId": connectionId,
        "receiverUsername": connectionUsername,
      });

      print("✉️ Sending message: $body");
      _stompClient.send(
        destination: "/app/chat/sendMessage/$convId",
        body: body,
      );
    } else {
      print("❌ Cannot send message: WebSocket not connected");
    }
  }

  void disconnect() {
    _stompClient.deactivate();
  }
}
