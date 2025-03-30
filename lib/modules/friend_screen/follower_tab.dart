import 'package:flutter/material.dart';

import '../profile_screen/profile_screen.dart';

class FollowersTab extends StatelessWidget {
  const FollowersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // Sample data
      itemBuilder: (context, index) => ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text("Follower ${index + 1}"),
        subtitle: const Text("Following you"),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(followerName: "Follower ${index + 1}"),
            ),
          );
        },
      ),
    );
  }
}
