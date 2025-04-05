import 'package:flutter/material.dart';
import 'package:flutter_social_share/component/horizontal_user_list.dart';

import '../../model/user.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import 'chat_detail.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
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
    try {
      final response = await UserService().getAllUsers(); // Make sure it returns List<String> or List<Map>
      setState(() {
        users = response; // Adjust if response shape is different
      });
    } catch (e) {
      debugPrint("Error fetching users: $e");
    }
  }
  Future<void> initData() async {
    final data = await AuthService.getSavedData();
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
          HorizontalUserList(users: users),

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
                          builder: (context) => ChatDetail(userId: userId!, receiverName: "Vutientrinh",)
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
