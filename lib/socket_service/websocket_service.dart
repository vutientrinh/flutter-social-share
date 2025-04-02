import 'dart:convert';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class WebSocketService {
  late StompClient _stompClient;
  final Function(Map<String, dynamic>) onMessageReceived;

  WebSocketService({required this.onMessageReceived});

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

    // Subscribe to the public topic
    _stompClient.subscribe(
      destination: "/topic/public",
      callback: (StompFrame frame) {
        if (frame.body != null) {
          Map<String, dynamic> message = json.decode(frame.body!);
          onMessageReceived(message);
        }
      },
    );
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
