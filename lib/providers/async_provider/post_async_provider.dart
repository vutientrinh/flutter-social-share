import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/social/post_request.dart';

import '../../model/social/post.dart';
import '../state_provider/post_provider.dart';

final postAsyncNotifierProvider =
    AsyncNotifierProvider<PostNotifier, List<Post>>(PostNotifier.new);

class PostNotifier extends AsyncNotifier<List<Post>> {
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _isFetchingMore = false;
  bool _hasNextPage = true;
  String? _authorId;
  @override
  Future<List<Post>> build() async {
    return await _fetchPosts(reset: true);
  }

  Future<List<Post>> _fetchPosts({bool reset = false, String? authorId}) async {
    final postService = ref.watch(postServiceProvider);

    if (reset) {
      _currentPage = 1;
      _hasNextPage = true;
    }

    final fetchedPosts = await postService.getAllPosts(
      page: _currentPage,
      size: _pageSize,
      // authorId: authorId,
    );

    if (fetchedPosts.length < _pageSize) {
      _hasNextPage = false;
    }

    return fetchedPosts;
  }

  Future<void> loadInitialPosts(String? authorId) async {
    _authorId = authorId;
    _currentPage = 1;
    _hasNextPage = true;

    try {
      final posts = await _fetchPosts(reset: true,authorId: _authorId);
      state = AsyncData(posts);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }


  Future<void> fetchNextPage({String? authorId}) async {
    if (_isFetchingMore || !_hasNextPage) return;

    _isFetchingMore = true;
    if (authorId != null) {
      _authorId = authorId; // save the authorId for future use
    }

    _currentPage++;
    try {
      final postService = ref.watch(postServiceProvider);
      final newPosts = await postService.getAllPosts(
        page: _currentPage,
        size: _pageSize,
        authorId: authorId
      );

      if (newPosts.length < _pageSize) {
        _hasNextPage = false;
      }

      final currentPosts = state.value ?? [];
      state = AsyncData([...currentPosts, ...newPosts]);
    } catch (e, st) {
      state = AsyncError(e, st);
    } finally {
      _isFetchingMore = false;
    }
  }

  Future<void> addPost(PostRequest newPost) async {
    final postService = ref.watch(postServiceProvider);
    await postService.createPost(newPost);

    // Reset and fetch from first page again
    state = const AsyncLoading();
    final updatedPosts = await _fetchPosts(reset: true);
    state = AsyncData(updatedPosts);
  }

  Future<void> deletePost(String id) async {
    final postService = ref.watch(postServiceProvider);
    await postService.deletePost(id);

    // Reset and fetch from first page again
    state = const AsyncLoading();
    final updatedPosts = await _fetchPosts(reset: true);
    state = AsyncData(updatedPosts);
  }

  Future<void> updatePost(String uuid, Map<String, dynamic> update) async {
    final postService = ref.read(postServiceProvider);
    await postService.updatePost(uuid, update);

    // Refresh list
    state = const AsyncLoading();
    final updatedPosts = await _fetchPosts(reset: true);
    state = AsyncData(updatedPosts);
  }

  Future<void> savePost(String authorId, String postId) async {
    final postService = ref.read(postServiceProvider);
    await postService.savePost(authorId, postId);
    final updatedPosts = await _fetchPosts(reset: true);
    state = AsyncData(updatedPosts);
  }

  Future<void> unSavePost(String authorId, String postId) async {
    final postService = ref.read(postServiceProvider);
    await postService.unSavePost(authorId, postId);
    final updatedPosts = await _fetchPosts(reset: true);
    state = AsyncData(updatedPosts);
  }

}
