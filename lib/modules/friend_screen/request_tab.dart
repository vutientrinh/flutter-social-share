import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_share/modules/friend_screen/user_avatar.dart';

import '../profile_screen/profile_screen.dart';

class RequestsTab extends StatelessWidget {
  const RequestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 10, // Sample data
        itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              children: [
                const Expanded( // Ensures row fits inside ListView
                  child: UserAvatar(
                    userName: "John Doe",
                    avatarUrl:
                    "https://th.bing.com/th/id/OIP.YoTUWMoKovQT0gCYOYMwzwHaHa?rs=1&pid=ImgDetMain",
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      label: const Text("Accept",style:  TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Accepted Request ${index + 1}",style: const TextStyle(color: Colors.black),),),
                        );
                      },
                    ),
                    const SizedBox(width: 8), // Add spacing between buttons
                    ElevatedButton.icon(
                      label: const Text("Reject",style:  TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Rejected Request ${index + 1}",style: const TextStyle(color: Colors.black),),),
                        );
                      },
                    ),
                  ],
                )

              ],
            )));
  }
}
