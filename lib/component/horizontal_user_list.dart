import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/social/friend_connection.dart';
import 'package:flutter_social_share/model/user.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';
import 'package:flutter_social_share/providers/state_provider/chat_provider.dart';
import 'package:flutter_social_share/providers/state_provider/friend_provider.dart';
import 'package:flutter_social_share/providers/state_provider/user_provider.dart';
import 'package:flutter_social_share/utils/uidata.dart';
import 'package:http/http.dart';

import '../screens/messages_screen/chat_detail.dart';

class HorizontalUserList extends ConsumerStatefulWidget {
  const HorizontalUserList({super.key});

  @override
  ConsumerState<HorizontalUserList> createState() => _HorizontalUserListState();
}

class _HorizontalUserListState extends ConsumerState<HorizontalUserList> {
  List<FriendConnection>? users;

  @override
  void initState() {
    super.initState();
    fetchFriend();
  }

  Future<void> fetchFriend() async {
    final response = await ref.read(chatServiceProvider).getFriends();
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

                    if (user == null ||
                        user.connectionId == null ||
                        user.connectionUsername == null) {
                      return const SizedBox.shrink(); // Skip null user
                    }

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatDetail(
                              friend: user,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.blue,
                                  child: Text(
                                    user.connectionUsername.isNotEmpty
                                        ? user.connectionUsername[0].toUpperCase()
                                        : '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                                if (user.isOnline == true)
                                  Positioned(
                                    bottom: 4,
                                    right: 4,
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            Text(
                              user.connectionUsername ?? '',
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
