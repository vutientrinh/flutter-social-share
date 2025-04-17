import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/async_provider/user_async_provider.dart';

import 'list_user.dart';

class SuggestionUser extends ConsumerStatefulWidget {
  const SuggestionUser({super.key});

  @override
  ConsumerState<SuggestionUser> createState() => _SuggestionUserState();
}

class _SuggestionUserState extends ConsumerState<SuggestionUser> {
  @override
  void initState() {
    super.initState();
    fetchAllUser();
  }

  Future<void> fetchAllUser() async {
    await ref.read(userAsyncNotifierProvider.notifier).getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    final allUsersState = ref.watch(userAsyncNotifierProvider);
    return allUsersState.when(
      data: (users) {
        if (users.isEmpty) {
          return const Center(child: Text('No users found.'));
        }
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListUser(
              username: user.username ?? "Unknown",
              avatar: user.avatar ?? "",
              trailing: ElevatedButton(
                onPressed: () => {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  "Accept",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}
