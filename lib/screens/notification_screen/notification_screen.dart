import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/social/notification.dart';
import 'package:flutter_social_share/providers/async_provider/notification_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/notification_provider.dart';

import '../../providers/state_provider/auth_provider.dart';
import '../../socket_service/websocket_service.dart';
import '../../utils/uidata.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  late WebSocketService _webSocketService;
  List<AppNotification> listNotification = [];

  @override
  void initState() {
    super.initState();
    loadNotification();
    connectNotification();
  }

  void connectNotification() async {
    final authService = ref.read(authServiceProvider);
    final data = await authService.getSavedData();
    _webSocketService = WebSocketService(
        userId: data['userId'],
        authService: authService,
        onMessageReceived: (message) {
          setState(() {
            listNotification.insert(0, message);
          });
        });
    _webSocketService.connect(subscriptionType: SubscriptionType.notifications);
  }

  Future<void> loadNotification() async {
    final notifications =
        await ref.read(notificationServiceProvider).getAllNotification();
    setState(() {
      listNotification = notifications;
    });
  }

  Icon _getIcon(String type) {
    switch (type) {
      case 'LIKE_POST':
        return const Icon(Icons.favorite, color: Colors.red);
      case 'COMMENT_POST':
        return const Icon(Icons.comment, color: Colors.blueGrey);
      case 'COMMENT_LIKED':
        return const Icon(Icons.thumb_up, color: Colors.indigo);
      case 'FOLLOW_USER':
        return const Icon(Icons.person_add_alt_1, color: Colors.purple);
      case 'FRIEND_REQUEST':
        return const Icon(Icons.person_add, color: Colors.green);
      case 'FRIEND_REQUEST_ACCEPTED':
        return const Icon(Icons.person, color: Colors.blue);
      default:
        return const Icon(Icons.notifications, color: Colors.grey);
    }
  }

  @override
  void dispose() {
    _webSocketService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  await ref
                      .read(notificationServiceProvider)
                      .readAllNotification();
                  loadNotification();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  // Make the button background transparent
                  elevation: 0,
                  // Remove shadow
                  padding: const EdgeInsets.symmetric(
                      vertical: 6, horizontal: 12), // Minimal padding
                ),
                child: const Text(
                  "Read All",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: listNotification.length,
              itemBuilder: (context, index) {
                final AppNotification notification = listNotification[index];

                final icon = _getIcon(notification.messageType);

                bool isUnread = notification.isRead == false;

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: isUnread ? Colors.blue.shade50 : Colors.white,
                  elevation: 4,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(
                        LINK_IMAGE.publicImage(notification.actor.avatar),
                      ),
                    ),
                    title: Text(
                      notification.content,
                      style: TextStyle(
                        fontWeight:
                            isUnread ? FontWeight.bold : FontWeight.normal,
                        color: isUnread ? Colors.black : Colors.grey,
                      ),
                    ),
                    subtitle: Text(
                      _formatTime(notification.createdAt),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    trailing: isUnread
                        ? const Icon(
                            Icons.mark_chat_read,
                            color: Colors.blue,
                          )
                        : null,
                    onTap: () async {
                      await ref
                          .read(notificationServiceProvider)
                          .readNotification(notification.id);
                      ref.invalidate(notificationAsyncNotifierProvider);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Converts an ISO time string to a readable format
  String _formatTime(String isoTime) {
    final dateTime = DateTime.tryParse(isoTime);
    if (dateTime == null) return isoTime;

    // Convert to local time
    final localDateTime = dateTime.toLocal();

    return '${localDateTime.hour.toString().padLeft(2, '0')}:${localDateTime.minute.toString().padLeft(2, '0')} - ${localDateTime.day}/${localDateTime.month}/${localDateTime.year}';
  }
}
