import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/social/friend_connection.dart';
import 'package:flutter_social_share/providers/async_provider/chat_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';
import 'package:flutter_social_share/providers/state_provider/chat_provider.dart';
import '../../model/social/conversation.dart';
import '../../socket_service/websocket_service.dart';
import '../../utils/uidata.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatDetail extends ConsumerStatefulWidget {
  final FriendConnection friend;

  const ChatDetail({super.key, required this.friend});

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
    _fetchReadMessage(widget.friend.connectionId, widget.friend.convId);
    // _fetchUnSeenMessages();
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
      _webSocketService.sendMessage(text, widget.friend.convId,
          widget.friend.connectionId, widget.friend.connectionUsername);
      _messageController.clear();
    }
  }

  Future<void> _fetchUnSeenMessages() async {
    try {
      final data = await ref
          .read(chatServiceProvider)
          .getUnSeenMessage(widget.friend.connectionId);
      setState(() {
        messages = data;
      });
      await ref.read(chatServiceProvider).setReadMessages(messages);
    } catch (e) {
      print("Error fetching unseen messages: $e");
    }
  }

  Future<void> _fetchReadMessage(String messageId, String convId) async {
    print("Get ne ba");
    try {
      final data =
          await ref.read(chatServiceProvider).getMessageBefore(convId: convId);
      setState(() {
        messages = data;
      });
    } catch (e) {
      print("Error fetching unseen messages: $e");
    }
  }

  Widget _buildDeliveryIcon(String? status) {
    switch (status) {
      case "NOT_DELIVERED":
        return const Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Not delivered",
                style: TextStyle(fontSize: 10, color: Colors.black),
              ),
              SizedBox(width: 4),
              Icon(Icons.check, size: 16, color: Colors.black),
            ],
          ),
        );
      case "DELIVERED":
        return const Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Delivered",
                style: TextStyle(fontSize: 10, color: Colors.black),
              ),
              SizedBox(width: 4),
              Icon(Icons.done_all, size: 16, color: Colors.black)
            ],
          ),
        );
      case "SEEN":
        return const Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Seen",
                style: TextStyle(fontSize: 10, color: Colors.black),
              ),
              SizedBox(width: 4),
              Icon(Icons.done_all, size: 16, color: Colors.black)
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage:
                NetworkImage(LINK_IMAGE.publicImage(widget.friend.user.avatar)),
          ),
          if (widget.friend.isOnline == true)
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
              ),
            ),
          const SizedBox(
            width: 20,
          ),
          Text(widget.friend.connectionUsername)
        ],
      )),
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
                return _buildMessageItem(message, isMe);
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

  Widget _buildMessageItem(Conversation message, bool isMe) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage(
                  LINK_IMAGE.publicImage(widget.friend.user.avatar)),
            ),
            const SizedBox(width: 8),
          ],
          Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.blue[100] : Colors.grey[300],
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(12),
                      topRight: const Radius.circular(12),
                      bottomLeft: Radius.circular(isMe ? 12 : 0),
                      bottomRight: Radius.circular(isMe ? 0 : 12),
                    ),
                  ),
                  child: Text(
                    message.content ?? "Not found",
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
                isMe
                    ? Padding(
                        padding:
                            const EdgeInsets.only(right: 12, top: 2, bottom: 5),
                        child: _buildDeliveryIcon(
                            message.messageDeliveryStatusEnum),
                      )
                    : Column(
                        children: [
                          Text(
                            timeago.format(DateTime.parse(message.time ?? "")),style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(
                            height: 4,
                          )
                        ],
                      )
              ]),

          // Text(message.) // spacing to align with avatar
        ],
      ),
    );
  }
}
