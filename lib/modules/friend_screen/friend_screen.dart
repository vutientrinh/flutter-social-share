import 'package:flutter/material.dart';

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
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
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
      ),
    );
  }
}

// Following Tab
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
      ),
    );
  }
}

// Requests Tab
class RequestsTab extends StatelessWidget {
  const RequestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5, // Sample data
      itemBuilder: (context, index) => ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person_add)),
        title: Text("Request ${index + 1}"),
        subtitle: const Text("Wants to follow you"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Accepted Request ${index + 1}")),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Rejected Request ${index + 1}")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
