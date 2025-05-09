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

  Future<void> initData() async {
    final authService = ref.read(authServiceProvider);
    final data = await authService.getSavedData();
    final count  = await ref.read(chatServiceProvider).getUnSeenMessageCount();
    setState(() {
      userId = data['userId']; // Assign userId once data is fetched
    });

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
      body: const HorizontalUserList(),

    );
  }
}
