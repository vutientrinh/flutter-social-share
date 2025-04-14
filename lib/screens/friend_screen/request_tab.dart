import 'package:flutter/material.dart';
import 'package:flutter_social_share/model/friend_request.dart';
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
  late Future<List<FriendRequest>> getRequest;

  @override
  void initState() {
    super.initState();
    // getRequest = loadData();
    print(getRequest);
  }

  Future<void> _acceptRequest(String username, String friendRequestId) async {
    // final response = await FriendService().acceptFriend(friendRequestId);
    // if (response != false) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(
    //         "Accepted Request ${username ?? 'User'}",
    //         style: const TextStyle(color: Colors.black),
    //       ),
    //     ),
    //   );
    // }
  }

  Future<void> _rejectRequest(String username, String friendRequestId) async {
    // final response = await FriendService().deleteFriend(friendRequestId);
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(
    //       "Rejected Request ${username ?? 'User'}",
    //       style: const TextStyle(color: Colors.black),
    //     ),
    //   ),
    // );
  }

  // Future<List<FriendRequest>> loadData() async {
  //   final data = await AuthService.getSavedData();
  //   final userId = data['userId'];
  //   // return FriendService().getFriendRequests(userId);
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FriendRequest>>(
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
              final request = snapshot.data![index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: UserAvatar(
                        userName: request.username ?? "Unknown",
                        avatarUrl: request.avatar ??
                            "https://th.bing.com/th/id/OIP.YoTUWMoKovQT0gCYOYMwzwHaHa?rs=1&pid=ImgDetMain",
                      ),
                    ),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.check),
                          label: const Text("Accept",
                              style: TextStyle(color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          onPressed: () {
                            _acceptRequest(request.username, request.requestId);
                          },
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.close),
                          label: const Text("Reject",
                              style: TextStyle(color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          onPressed: () {
                            _rejectRequest(request.username, request.requestId);
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
