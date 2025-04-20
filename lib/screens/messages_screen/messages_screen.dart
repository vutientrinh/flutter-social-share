import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/component/horizontal_user_list.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';
import 'package:flutter_social_share/providers/state_provider/chat_provider.dart';
import '../../model/user.dart';
import 'chat_detail.dart';

class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({super.key});

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> {
  // Sample data for users and chats
  String? userId;

  final List<Map<String, String>> chatList = [
    {"name": "Alice", "message": "Hey! How's it going?"},
    {"name": "Bob", "message": "Don't forget our meeting."},
    {"name": "Charlie", "message": "Check this out!"},
    {"name": "David", "message": "Let's hang out this weekend."},
    {"name": "Emma", "message": "Can you send me the files?"},
  ];

  List<User> users = [];
  Future<void> fetchUsers() async {
    // try {
    //   final response = await UserService().getAllUsers(); // Make sure it returns List<String> or List<Map>
    //   setState(() {
    //     users = response; // Adjust if response shape is different
    //   });
    // } catch (e) {
    //   debugPrint("Error fetching users: $e");
    // }
  }
  Future<void> initData() async {
    final authService = ref.read(authServiceProvider);
    final data = await authService.getSavedData();
    final count  = await ref.read(chatServiceProvider).getUnSeenMessageCount();
    setState(() {
      userId = data['userId']; // Assign userId once data is fetched
    });

    await fetchUsers(); // Fetch users after userId is fetched
  }

  @override
  void initState() {
    super.initState();
    initData(); // Call initData to fetch data asynchronously
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Navigate back to home
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Slider (Top)
          const HorizontalUserList(),

          const Divider(thickness: 1),

          // Chat List (Below)
          Expanded(
            child: ListView.builder(
              itemCount: chatList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Text(
                      chatList[index]["name"]![0], // First letter as avatar
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(chatList[index]["name"]!),
                  subtitle: Text(chatList[index]["message"]!),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Add navigation to detailed chat screen if needed
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatDetail(receiverId: userId!, receiverUsername: "VuTienTrin"),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
