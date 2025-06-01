import 'package:cached_network_image/cached_network_image.dart';
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
  final ScrollController _scrollController = ScrollController();
  bool? isOnline;
  @override
  void initState() {
    timeago.setLocaleMessages('vi', timeago.ViMessages());
    final authService = ref.read(authServiceProvider);
    super.initState();
    setState(() {
      isOnline = widget.friend.isOnline;
    });
    _webSocketService = WebSocketService(
      userId: widget.friend.convId,
      authService: authService,
      onMessageReceived: (message) {
        if (!mounted) return;
        setState(() {
          if (message.messageType == "MESSAGE_DELIVERY_UPDATE") {
            int index = messages.indexWhere((m) => m.id == message.id);
            if (index != -1) {
              messages[index] = message; // Replace with updated delivery status
            }
          }

          else if (message.messageType == "CHAT") {
            messages.add(message);
          }
          else if(message.messageType == "FRIEND_ONLINE"){
            setState(() {
              isOnline = true;
            });
            print("Online ne ");
          }
          else if(message.messageType == "FRIEND_OFFLINE"){
            setState(() {
              isOnline = false;
            });
            print("Offline ne ");

          }
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _scrollToBottom());

        });

      },
    );
    _webSocketService.connect(subscriptionType:  SubscriptionType.chat);
    _fetchReadMessage(widget.friend.connectionId, widget.friend.convId);
    // _fetchUnSeenMessages();
  }

  @override
  void didUpdateWidget(covariant ChatDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _webSocketService.disconnect();
    super.dispose();
  }

  void _sendMessage() {
    String text = _messageController.text;
    if (text.isNotEmpty) {
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
    try {
      final data =
          await ref.read(chatServiceProvider).getMessageBefore(convId: convId);
      setState(() {
        messages = data;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
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
            Stack(
              children: [
                Container(
                  width: 52, // radius * 2 + border width (24 * 2 + 2*2)
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: CachedNetworkImageProvider(
                      LINK_IMAGE.publicImage(widget.friend.user.avatar),
                    ),
                    backgroundColor:
                        Colors.white, // Optional: to prevent image overflow
                  ),
                ),
                if (isOnline == true)
                  Positioned(
                    bottom: 0,
                    right: 0,
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
              ],
            ),
            const SizedBox(width: 12),
            Text(widget.friend.user.username),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
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
            Container(
              width: 52, // radius * 2 + border width (24 * 2 + 2*2)
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(
                  LINK_IMAGE.publicImage(widget.friend.user.avatar),
                ),
                backgroundColor:
                    Colors.white, // Optional: to prevent image overflow
              ),
            ),
            const SizedBox(width: 8),
          ],
          Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 2 / 3,
                  ),
                  child: Container(
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
                            timeago.format(
                              DateTime.parse(message.time ?? "").toLocal(),
                            ),
                            style: const TextStyle(fontSize: 12),
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
