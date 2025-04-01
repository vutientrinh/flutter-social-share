import 'package:flutter/material.dart';
import 'package:flutter_social_share/modules/friend_screen/user_avatar.dart';
import '../profile_screen/profile_screen.dart';

class FollowingTab extends StatelessWidget {
  const FollowingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // Sample data
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            // Avatar
            const Expanded( // Ensures row fits inside ListView
              child: UserAvatar(
                userName: "John Doe",
                avatarUrl:
                "https://th.bing.com/th/id/OIP.YoTUWMoKovQT0gCYOYMwzwHaHa?rs=1&pid=ImgDetMain",
              ),
            ),
            const SizedBox(width: 12),
            // Name & Subtitle

            // Buttons
            IconButton(
              icon: const Icon(Icons.message),
              onPressed: () {
                // Handle message button press
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () {
                // Handle more options
              },
            ),
          ],
        ),
      ),
    );
  }
}
