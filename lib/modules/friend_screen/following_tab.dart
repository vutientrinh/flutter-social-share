import 'package:flutter/material.dart';

import '../profile_screen/profile_screen.dart';

class FollowingTab extends StatelessWidget {
  const FollowingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8, // Sample data
      itemBuilder: (context, index) => ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text("Following ${index + 1}"),
        subtitle: const Text("You are following"),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(followerName: "Following ${index + 1}"),
            ),
          );
        },
      ),
    );
  }
}