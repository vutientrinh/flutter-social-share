import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/social/post_request.dart';
import 'package:flutter_social_share/model/social/post_update_request.dart';

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

  Future<List<Post>> _fetchPosts({bool reset = false}) async {
    final postService = ref.watch(postServiceProvider);

    if (reset) {
      _currentPage = 1;
      _hasNextPage = true;
    }

    final fetchedPosts = await postService.getRecPost(
      page: _currentPage,
      size: _pageSize,
    );

    if (fetchedPosts.length < _pageSize) {
      _hasNextPage = false;
    }

    return fetchedPosts;
  }

  Future<void> fetchNextPage() async {
    if (_isFetchingMore || !_hasNextPage) return;

    _isFetchingMore = true;
    await Future.delayed(const Duration(milliseconds: 300));
    _currentPage++;

    try {
      final postService = ref.watch(postServiceProvider);
      final newPosts = await postService.getRecPost(
        page: _currentPage,
        size: _pageSize,
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

  Future<void> updatePostLikeStatus(
      String postId, bool isLiked, int likeCount) async {
    final posts = state.value;
    if (posts == null) return;

    final updatedPosts = posts.map((post) {
      if (post.id == postId) {
        return post.copyWith(
          hasLiked: isLiked,
          likedCount: likeCount,
        );
      }
      return post;
    }).toList();

    state = AsyncValue.data(updatedPosts);
  }

  Future<void> updateComment(String postId, int commentCount) async {
    final posts = state.value;
    if (posts == null) return;

    final updatedPosts = posts.map((post) {
      if (post.id == postId) {
        return post.copyWith(commentCount: commentCount);
      }
      return post;
    }).toList();

    state = AsyncValue.data(updatedPosts);
  }

  Future<List<Post>> loadInitialPosts(String? authorId) async {
    final postService = ref.watch(postServiceProvider);

    _authorId = authorId;

    final posts = await postService.getAllPosts(
        page: _currentPage, size: _pageSize, authorId: authorId);
    return posts;
  }

  Future<void> addPost(PostRequest newPost) async {
    final postService = ref.watch(postServiceProvider);
    final post = await postService.createPost(newPost);
    state = AsyncData([post, ...?state.value]);
  }

  Future<void> deletePost(String id) async {
    final postService = ref.watch(postServiceProvider);
    await postService.deletePost(id);

    // Reset and fetch from first page again
    state = const AsyncLoading();
    final updatedPosts = await _fetchPosts(reset: true);
    state = AsyncData(updatedPosts);
  }

  Future<void> updatePost(String uuid, PostUpdateRequest update) async {
    final postService = ref.read(postServiceProvider);
    await postService.updatePost(uuid, update);
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
