import 'package:flutter/material.dart';
import 'package:flutter_social_share/services/chat_service.dart';
import '../../model/conversation.dart';
import '../../socket_service/websocket_service.dart';

class ChatDetail extends StatefulWidget {
  final String receiverId; // The current user's ID
  final String receiverUsername;
  const ChatDetail({super.key, required this.receiverId, required this.receiverUsername});

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  late WebSocketService _webSocketService;
  List<Conversation> messages = [];
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _webSocketService = WebSocketService(
      userId: widget.receiverId,
      onMessageReceived: (message) {
        setState(() {
          messages.add(message as Conversation);
        });
      },
    );
    _webSocketService.connect();
    _fetchReadMessages();
  }

  @override
  void dispose() {
    _webSocketService.disconnect();
    super.dispose();
  }

  void _sendMessage() {
    String text = _messageController.text;
    if (text.isNotEmpty) {
      _webSocketService.sendMessage(text, widget.receiverId,widget.receiverId,widget.receiverUsername);
      _messageController.clear();
    }
  }
  Future<void> _fetchReadMessages() async {
    try {
      final response = await ChatService().setReadMessages(messages);
      print("Response ne check di : ${response}");
      setState(() {
        messages = response;
      });
    } catch (e) {
      print("Error fetching unseen messages: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverUsername)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final bool isMe = message.convId != widget.receiverId;

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
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
