import 'package:flutter/material.dart';
import 'package:flutter_social_share/screens/friend_screen/user_avatar.dart';
import 'package:flutter_social_share/services/friend_service.dart';

import '../../model/user.dart';
import '../../services/auth_service.dart';
import '../profile_screen/profile_screen.dart';

class RequestsTab extends StatefulWidget {
  const RequestsTab({super.key});

  @override
  State<RequestsTab> createState() => _RequestsTabState();
}

class _RequestsTabState extends State<RequestsTab> {
  late Future<List<User>> getRequest;

  @override
  void initState() {
    super.initState();
    getRequest = loadData();
  }

  Future<List<User>> loadData() async {
    final data = await AuthService.getSavedData();
    final userId = data['userId'];
    return FriendService().getFriendRequests(userId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: getRequest,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No users found.'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final user = snapshot.data![index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: UserAvatar(
                        userName: user.username ?? "Unknown",
                        avatarUrl: user.avatar ??
                            "https://th.bing.com/th/id/OIP.YoTUWMoKovQT0gCYOYMwzwHaHa?rs=1&pid=ImgDetMain",
                      ),
                    ),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.check),
                          label: const Text("Accept", style: TextStyle(color: Colors.black)),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Accepted Request ${user.username ?? 'User'}",
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.close),
                          label: const Text("Reject", style: TextStyle(color: Colors.black)),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Rejected Request ${user.username ?? 'User'}",
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
