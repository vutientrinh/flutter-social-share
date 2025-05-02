import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/social/post.dart';
import 'package:flutter_social_share/providers/async_provider/post_async_provider.dart';
import '../../../providers/state_provider/post_provider.dart';
import '../widgets/post_item_remake.dart';

class SavedPostsScreen extends ConsumerStatefulWidget {
  const SavedPostsScreen({super.key});

  @override
  ConsumerState<SavedPostsScreen> createState() => _SavedPostsScreenState();
}

class _SavedPostsScreenState extends ConsumerState<SavedPostsScreen> {
  List<Post>? listPosts;
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
      setState(() {
        listPosts = response;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load posts: $e")),
      );
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
          : (listPosts == null || listPosts!.isEmpty)
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
              child: PostItem(post: post, authorId: post.author.id),
            );
          },
        ),
      ),
    );
  }
}
