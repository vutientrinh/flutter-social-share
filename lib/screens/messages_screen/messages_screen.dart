import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/component/horizontal_user_list.dart';
import 'package:flutter_social_share/providers/async_provider/connection_friend_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';
import 'package:flutter_social_share/providers/state_provider/chat_provider.dart';
import '../../model/user.dart';
import '../../utils/uidata.dart';
import 'chat_detail.dart';

class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({super.key});

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> {
  String? userId;

  Future<void> initData() async {
    try {
      final authService = ref.read(authServiceProvider);
      final data = await authService.getSavedData();
      final count = await ref.read(chatServiceProvider).getUnSeenMessageCount();
      setState(() {
        userId = data['userId'];
      });
    } catch (e) {
      debugPrint("Error loading user data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    initData();
    Future.microtask(() {
      ref.invalidate(friendConnectionAsyncNotifierProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final friendConnectionListState =
        ref.watch(friendConnectionAsyncNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: friendConnectionListState.when(
        data: (friendList) {
          return Column(
            children: [
              const SizedBox(
                height: 6,
              ),
              HorizontalUserList(listFriendConnection: friendList),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: friendList.length,
                  itemBuilder: (context, index) {
                    final friend = friendList[index];
                    return ListTile(
                      leading: Container(
                        width: 54, // radius * 2 + border width (24 * 2 + 2*2)
                        height: 54,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(
                            LINK_IMAGE.publicImage(friend.user.avatar),
                          ),
                          backgroundColor: Colors
                              .white, // Optional: to prevent image overflow
                        ),
                      ),
                      title: Text(
                        friend.user.username ?? 'Unknown',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text("Let's discuss"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatDetail(friend: friend),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
