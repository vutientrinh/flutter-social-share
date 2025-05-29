import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/async_provider/follower_async_provider.dart';
import 'package:flutter_social_share/providers/async_provider/friend_async_provider.dart';
import 'package:flutter_social_share/utils/uidata.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../providers/async_provider/following_async_provider.dart';
import '../../../providers/state_provider/follow_provider.dart';
import '../../../providers/state_provider/friend_provider.dart';
import '../../messages_screen/messages_screen.dart';

class MoreOptionWidget extends ConsumerWidget {
  final String username;
  final String avatar;
  final String followAt;
  final String option;
  final String id;
  final String author;

  const MoreOptionWidget({
    super.key,
    required this.username,
    required this.avatar,
    required this.followAt,
    required this.option,
    required this.id,
    required this.author,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfo(),
          const SizedBox(height: 20),
          if (option == "Friend")
            _buildListTile(
              icon: Icons.message,
              title: "Message $username",
              subtitle: "Send message",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MessagesScreen()),
                );
              },
            ),
          if (option == "Following")
            _buildListTile(
              icon: Icons.person_remove_alt_1,
              title: "Unfollow $username",
              subtitle: "Stop seeing posts but stay friends",
              onTap: () async {
                await ref.read(followingAsyncNotifierProvider.notifier).unfollow(id);

              },
            ),
          if (option == "Friend")
            _buildListTile(
              icon: Icons.person_off,
              title: "Unfriend $username",
              subtitle: "Remove $username as a friend",
              onTap: () async {
                await ref.read(friendServiceProvider).deleteFriend(id);
                ref.invalidate(friendAsyncNotifierProvider);
              },
            ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: avatar.isNotEmpty
              ? NetworkImage(LINK_IMAGE.publicImage(avatar))
              : null,
          child: avatar.isEmpty ? const Icon(Icons.person) : null,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              username,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            if (followAt.isNotEmpty)
              Text(
                "$option since ${timeago.format(DateTime.parse(followAt), locale: 'en_short')}",
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
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
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
    );
  }
}
