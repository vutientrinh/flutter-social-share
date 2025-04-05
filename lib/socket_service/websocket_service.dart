import 'dart:convert';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class WebSocketService {
  late StompClient _stompClient;
  final String userId;
  final Function(Map<String, dynamic>) onMessageReceived;

  WebSocketService({required this.userId,   required this.onMessageReceived});

  void connect() {
    _stompClient = StompClient(
      config: StompConfig.sockJS(
        url: 'http://172.21.192.1:8080/ws', // Use ws:// instead of http://
        onConnect: _onConnect,
        beforeConnect: () async {
          print("Waiting to connect...");
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
          final Map<String, dynamic> message = json.decode(frame.body!);
          _handleMessage(message);
        }
      },
    );
  }
  void _handleMessage(Map<String, dynamic> message) {
    final type = message['messageType'];

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


  void sendMessage(String content, String sender) {
    Map<String, dynamic> message = {
      "content": content,
      "sender": sender,
    };

    _stompClient.send(
      destination: "/app/chat.sendMessage", // Corrected endpoint
      body: json.encode(message),
    );
  }

  void disconnect() {
    _stompClient.deactivate();
  }
}
