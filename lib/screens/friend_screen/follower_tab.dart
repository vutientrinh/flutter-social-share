import 'package:flutter/material.dart';
import 'package:flutter_social_share/screens/friend_screen/user_avatar.dart';
import '../profile_screen/profile_screen.dart';

class FollowersTab extends StatelessWidget {
  const FollowersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // Sample data
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Navigate to ProfileScreen when clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(followerName: "Vutientrinh")
                    ),
                  );
                },
                child: const UserAvatar(
                  userName: "John Doe",
                  avatarUrl:
                  "https://th.bing.com/th/id/OIP.YoTUWMoKovQT0gCYOYMwzwHaHa?rs=1&pid=ImgDetMain",
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
