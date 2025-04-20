import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/user.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';
import 'package:flutter_social_share/providers/state_provider/friend_provider.dart';
import 'package:flutter_social_share/providers/state_provider/user_provider.dart';
import 'package:flutter_social_share/utils/uidata.dart';

import '../screens/messages_screen/chat_detail.dart';

class HorizontalUserList extends ConsumerStatefulWidget {
  const HorizontalUserList({super.key});

  @override
  ConsumerState<HorizontalUserList> createState() => _HorizontalUserListState();
}

class _HorizontalUserListState extends ConsumerState<HorizontalUserList> {
  List<User>? users;

  @override
  void initState() {
    super.initState();
    fetchFriend();
  }

  Future<void> fetchFriend() async {
    final data = await ref.read(authServiceProvider).getSavedData();
    final response = await ref.read(friendServiceProvider).getFriends(data['userId']);
    print("Friend ne : $response}");
    setState(() {
      users = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: users == null
          ? const Center(child: CircularProgressIndicator())
          : users!.isEmpty
          ? const Center(child: Text("No friends found"))
          : ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: users!.length,
        itemBuilder: (context, index) {
          final user = users![index];

          if (user == null || user.id == null || user.username == null) {
            return const SizedBox.shrink(); // Skip null user
          }

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetail(
                    receiverId: user.id,
                    receiverUsername: user.username,
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: user.avatar != null
                        ? NetworkImage(LINK_IMAGE.publicImage(user.avatar!))
                        : null,
                    backgroundColor: Colors.blue, // fallback background
                    child: user.avatar == null
                        ? Text(
                      (user.username.isNotEmpty ?? false)
                          ? user.username[0].toUpperCase()
                          : '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    )
                        : null,
                  ),

                  const SizedBox(height: 5),
                  Text(
                    user.username ?? '',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}
