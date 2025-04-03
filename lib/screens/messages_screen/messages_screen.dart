import 'package:flutter/material.dart';

import 'chat_detail.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  // Sample data for users and chats
  final List<String> users = ['Alice', 'Bob', 'Charlie', 'David', 'Emma'];
  final List<Map<String, String>> chatList = [
    {"name": "Alice", "message": "Hey! How's it going?"},
    {"name": "Bob", "message": "Don't forget our meeting."},
    {"name": "Charlie", "message": "Check this out!"},
    {"name": "David", "message": "Let's hang out this weekend."},
    {"name": "Emma", "message": "Can you send me the files?"},
  ];

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
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: users.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blue,
                        child: Text(
                          users[index][0], // Display the first letter
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        users[index],
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

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
                          builder: (context) => const ChatDetail(userId: "1234")
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
