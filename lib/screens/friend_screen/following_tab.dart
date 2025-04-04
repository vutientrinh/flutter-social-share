import 'package:flutter/material.dart';
import '../../model/user.dart';
import '../../services/user_service.dart';
import 'user_avatar.dart'; // Your custom widget
import '../profile_screen/profile_screen.dart';

class FollowingTab extends StatelessWidget {
  const FollowingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: UserService().getAllUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Show loading indicator
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}')); // Handle error
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No users found.')); // Handle no data
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final user = snapshot.data![index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),  // Optional padding between items
                child: UserAvatar(
                  userName: user.username,
                  avatarUrl: "https://th.bing.com/th/id/OIP.YoTUWMoKovQT0gCYOYMwzwHaHa?rs=1&pid=ImgDetMain",
                ),
              );
            },
          );

        }
      },
    );
  }
}

