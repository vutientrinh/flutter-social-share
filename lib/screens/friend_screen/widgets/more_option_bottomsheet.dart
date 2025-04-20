import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/follow_response.dart';
import 'package:flutter_social_share/providers/async_provider/follow_async_provider.dart';
import 'package:flutter_social_share/providers/async_provider/friend_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/follow_provider.dart';
import 'package:flutter_social_share/providers/state_provider/friend_provider.dart';
import 'package:flutter_social_share/utils/uidata.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../messages_screen/chat_detail.dart';
import '../../messages_screen/messages_screen.dart';

class MoreOptionBottomsheet extends ConsumerStatefulWidget {
  final String username;
  final String avatar;
  final String followAt;
  final String option;
  final String id;

  const MoreOptionBottomsheet({super.key,
    required this.username,
    required this.avatar,
    required this.followAt,
    required this.option,
    required this.id,
  });

  @override
  ConsumerState<MoreOptionBottomsheet> createState() =>
      _MoreOptionBottomsheetState();
}

class _MoreOptionBottomsheetState extends ConsumerState<MoreOptionBottomsheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: widget.avatar != null
                    ? NetworkImage(LINK_IMAGE.publicImage(widget.avatar))
                    : null,
                child: widget.avatar == null ? const Icon(Icons.person) : null,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.username ?? "Unknown",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (widget.followAt.isNotEmpty)
                    Text(
                      "${widget.option} since ${timeago.format(
                          DateTime.parse(widget.followAt),
                          locale: 'en_short')}",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          /// Message

          _buildListTile(
            icon: Icons.message,
            title: "Message ${widget.username }",
            subtitle: "Send message",
            onTap: () =>
            {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ChatDetail(
                          receiverId: widget.id ,
                          receiverUsername: widget.username),
                ),
              )
            },
          ),

          if (widget.option == "Following")
            _buildListTile(
              icon: Icons.person_remove_alt_1,
              title: "Unfollow ${widget.username }",
              subtitle: "Stop seeing posts but stay friends",
              onTap: () async {
                await ref.read(followServiceProvider).unfollow(widget.id);
                ref.invalidate(followAsyncNotifierProvider);
              },
            ),

          if (widget.option == "Friend")
            _buildListTile(
              icon: Icons.person_off,
              title: "Unfriend ${widget.username }",
              subtitle: "Remove ${widget.username } as a friend",
              onTap: () async {
                await ref.read(friendServiceProvider).deleteFriend(widget.id);
                ref.invalidate(friendAsyncNotifierProvider);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade400, width: 1.5),
        ),
        child: Icon(icon, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: subtitle != null
          ? Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      )
          : null,
      onTap: onTap,
    );
  }
}
