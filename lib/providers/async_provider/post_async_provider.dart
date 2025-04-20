import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/post_request.dart';

import '../../model/post.dart';
import '../state_provider/post_provider.dart';

final postAsyncNotifierProvider = AsyncNotifierProvider<PostNotifier, List<Post>>(PostNotifier.new);

class PostNotifier extends AsyncNotifier<List<Post>> {
  @override
  Future<List<Post>> build() async {
    final postService = ref.watch(postServiceProvider);
    final response = await postService.getAllPosts();
    return response;
  }

  Future<void> addPost(PostRequest newPost) async {
    final postService = ref.watch(postServiceProvider);
    await postService.createPost(newPost);

    // Update the list
    final updatedPosts = await postService.getAllPosts();
    state = AsyncData(updatedPosts);
  }

  Future<void> deletePost(String id) async {
    final postService = ref.watch(postServiceProvider);
    await postService.deletePost(id);

    // Refresh posts
    final updatedPosts = await postService.getAllPosts();
    state = AsyncData(updatedPosts);
  }
}
