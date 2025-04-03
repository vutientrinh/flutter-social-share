import 'package:flutter/material.dart';
import 'package:flutter_social_share/screens/friend_screen/request_tab.dart';

import 'follower_tab.dart';
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
              Tab(text: "Followers"),
              Tab(text: "Following"),
              Tab(text: "Requests"),
            ],
          ),
          backgroundColor: Colors.white,
        ),
        body: const TabBarView(
          children: [
            FollowersTab(),
            FollowingTab(),
            RequestsTab(),
          ],
        ),
      ),
    );
  }
}

// Followers Tab

// Following Tab


// Requests Tab
