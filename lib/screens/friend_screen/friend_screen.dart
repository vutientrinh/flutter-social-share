import 'package:flutter/material.dart';
import 'package:flutter_social_share/screens/friend_screen/follower_tab.dart';
import 'friend_tab.dart';
import 'following_tab.dart';

class FriendScreen extends StatelessWidget {
  const FriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Friends"),
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: "Friends"),
              Tab(text: "Follower"),
              Tab(text: "Following"),
            ],
          ),
          backgroundColor: Colors.white,
        ),
        body: const TabBarView(
          children: [
            FriendsTab(),
            FollowerTab(),
            FollowingTab(),
          ],
        ),
      ),
    );
  }
}
