import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/social/post.dart';
import 'package:flutter_social_share/providers/async_provider/post_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';
import '../../../providers/state_provider/post_provider.dart';
import '../widgets/post_item_remake.dart';

class SavedPostsScreen extends ConsumerStatefulWidget {
  const SavedPostsScreen({super.key});

  @override
  ConsumerState<SavedPostsScreen> createState() => _SavedPostsScreenState();
}

class _SavedPostsScreenState extends ConsumerState<SavedPostsScreen> {
  List<Post>? listPosts;
  String? userId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await ref.read(postServiceProvider).getSavedPosts();
      final user = await ref.read(authServiceProvider).getSavedData();
      setState(() {
        listPosts = response;
        userId = user['userId'];
      });
    } catch (e) {
      print("Empty");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadData,
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : (listPosts == null ||
                  listPosts!.isEmpty ||
                  userId == null ||
                  userId!.isEmpty)
              ? const Center(child: Text('No saved posts yet.'))
              : RefreshIndicator(
                  onRefresh: loadData,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: listPosts!.length,
                    itemBuilder: (context, index) {
                      final post = listPosts![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: PostItem(post: post, authorId: userId!),
                      );
                    },
                  ),
                ),
    );
  }
}
