import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_social_share/model/social/conversation.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import '../services/auth_service.dart';

class WebSocketService {
  late StompClient _stompClient;
  final String userId;
  final Function(Conversation) onMessageReceived;
  String? token;
  AuthService authService;

  WebSocketService(
      {required this.userId,
      required this.authService,
      required this.onMessageReceived});

  void connect() async {
    final data = await authService.getSavedData();
    token = data['token'];

    _stompClient = StompClient(
      config: StompConfig(
        url: dotenv.env['SOCKET_URL'] ?? 'ws://34.41.219.13.nip.io:8280/ws',
        beforeConnect: () async {
          print("Connecting...");
        },
        stompConnectHeaders: {
          'Authorization': 'Bearer $token',
        },
        onConnect: _onConnect,
        onDisconnect: (frame) {
          print("🔁 Reconnecting in 3 seconds...");
          Future.delayed(Duration(seconds: 3), () {
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

  void _onConnect(StompFrame frame) {
    print("Connected to WebSocket");

    // Subscribe to /topic/{userId}
    _subscribeToTopic("/topic/$userId");

    // Subscribe to /topic/notifications
    _subscribeToTopic("/topic/notifications");

    // Subscribe to /topic/notifications/{userId}
    _subscribeToTopic("/topic/notifications/$userId");
  }

  void _subscribeToTopic(String topic) {
    _stompClient.subscribe(
      destination: topic,
      callback: (StompFrame frame) {
        if (frame.body != null) {
          print(frame.body);
          final message = json.decode(frame.body!);
          final newMessage = Conversation.fromJson(message);
          _handleMessage(newMessage);
        }
      },
    );
  }

  void _handleMessage(Conversation message) {
    final type = message.messageType;

    switch (type) {
      case "CHAT":
      case "UNSEEN":
        // Gửi về UI xử lý CHAT hoặc UNSEEN
        onMessageReceived(message);
        break;

      case "FRIEND_OFFLINE":
      case "FRIEND_ONLINE":
        // Cập nhật trạng thái online
        onMessageReceived(message);
        break;

      case "MESSAGE_DELIVERY_UPDATE":
        // Truyền delivery status
        onMessageReceived(message);
        break;

      case "LIKE_COUNT":
      case "FOLLOW_COUNT":
      case "POST_COUNT":
      case "COMMENT_POST_COUNT":
      case "COMMENT_LIKED_COUNT":
        print("General Notification: $type");
        print("Message: $message");
        break;

      case "LIKE_POST":
      case "FOLLOW_USER":
      case "COMMENT_POST":
      case "COMMENT_LIKED":
      case "FRIEND_REQUEST":
      case "FRIEND_REQUEST_ACCEPTED":
        print("Personal Notification: $type");
        print("Message: $message");
        break;

      default:
        print("Unknown message type: $type");
        print(message);
    }
  }

  void sendMessage(String message, String convId, String connectionId,
      String connectionUsername) {
    if (_stompClient.connected) {
      final body = json.encode({
        "messageType": "CHAT",
        "content": message,
        "receiverId": connectionId,
        "receiverUsername": connectionUsername,
      });
      print("Sending message: $body");

      _stompClient.send(
        destination: "/app/chat/sendMessage/$convId",
        body: body,
      );
    } else {
      print("❌ Cannot send message: WebSocket not connected");
      // Optional: Reconnect logic or UI notification
    }
  }

  void disconnect() {
    _stompClient.deactivate();
  }
}
