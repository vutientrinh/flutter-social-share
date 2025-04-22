import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/friend_connection.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';
import 'package:flutter_social_share/providers/state_provider/chat_provider.dart';
import '../../model/conversation.dart';
import '../../socket_service/websocket_service.dart';

class ChatDetail extends ConsumerStatefulWidget {
  final FriendConnection friend;

  const ChatDetail(
      {super.key, required this.friend});

  @override
  ConsumerState<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends ConsumerState<ChatDetail> {
  late WebSocketService _webSocketService;
  List<Conversation> messages = [];
  List<Conversation> readMessages = [];
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    final authService = ref.read(authServiceProvider);
    super.initState();
    _webSocketService = WebSocketService(
      userId: widget.friend.convId,
      authService: authService,
      onMessageReceived: (message) {
        setState(() {
          if (message.messageType == "MESSAGE_DELIVERY_UPDATE") {
            int index = messages.indexWhere((m) => m.id == message.id);
            if (index != -1) {
              messages[index] = message; // Replace with updated delivery status
            }
          } else {
            messages.add(message); // New message or other types
          }
        });
      },

    );
    _webSocketService.connect();
    _fetchUnSeenMessages();
    // _fetchReadMessage();
  }

  @override
  void dispose() {
    _webSocketService.disconnect();
    super.dispose();
  }

  void _sendMessage() {
    String text = _messageController.text;
    if (text.isNotEmpty) {
      print(text);
      _webSocketService.sendMessage(
          text, widget.friend.convId, widget.friend.connectionId, widget.friend.connectionUsername);
      _messageController.clear();
    }
  }

  Future<void> _fetchUnSeenMessages() async {
    try {
      print(widget.friend.connectionId);
      final data = await ref
          .read(chatServiceProvider)
          .getUnSeenMessage(widget.friend.connectionId);
      print("Response ne check di : ${data}");
      setState(() {
        messages = data;
      });
      // await ref.read(chatServiceProvider).setReadMessages(messages);
    } catch (e) {
      print("Error fetching unseen messages: $e");
    }
  }
  Widget _buildDeliveryIcon(String? status) {
    switch (status) {
      case "NOT_DELIVERED":
        return const Icon(Icons.check, size: 16, color: Colors.red);
      case "DELIVERED":
        return const Icon(Icons.done_all, size: 16, color: Colors.green);
      case "SEEN":
        return const Icon(Icons.done_all, size: 16, color: Colors.black);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.friend.connectionUsername)),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final bool isMe =
                    message.senderId != widget.friend.connectionId;

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      // Message bubble
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue[300] : Colors.grey[300],
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12),
                            topRight: const Radius.circular(12),
                            bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
                            bottomRight: isMe ? Radius.zero : const Radius.circular(12),
                          ),
                        ),
                        child: Text(
                          message.content ?? "Not found",
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ),
                      // Delivery status icon outside the message bubble
                      if (isMe)
                        Padding(
                          padding: const EdgeInsets.only(right: 12, top: 2, bottom: 5),
                          child: _buildDeliveryIcon(message.messageDeliveryStatusEnum),
                        ),
                    ],
                  ),
                );

              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
