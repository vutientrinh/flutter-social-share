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
  final List<FriendConnection> listFriendConnection;

  const HorizontalUserList({super.key, required this.listFriendConnection});

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
    setState(() {
      users = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.listFriendConnection.length,
        itemBuilder: (context, index) {
          final user = widget.listFriendConnection[index];
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
                      Container(
                        width: 54, // radius * 2 + border width (24 * 2 + 2*2)
                        height: 54,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(
                            LINK_IMAGE.publicImage(user.user.avatar),
                          ),
                          backgroundColor: Colors.white, // Optional: to prevent image overflow
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
