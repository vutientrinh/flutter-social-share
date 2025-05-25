import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/social/post.dart';
import '../state_provider/post_provider.dart';

final postProfileAsyncNotifierProvider =
AsyncNotifierProvider<PostProfileNotifier, List<Post>>(PostProfileNotifier.new);

class PostProfileNotifier extends AsyncNotifier<List<Post>> {
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _isFetchingMore = false;
  bool _hasNextPage = true;
  String? _authorId; // Store the authorId

  @override
  Future<List<Post>> build() async {
    // If authorId is not set, return an empty list or handle as needed
    return _authorId == null ? [] : await _fetchPosts(reset: true, authorId: _authorId);
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
      authorId: authorId,
    );

    if (fetchedPosts.length < _pageSize) {
      _hasNextPage = false;
    }

    return fetchedPosts;
  }

  Future<void> fetchPostsForUser(String authorId) async {
    _authorId = authorId;
    state = const AsyncLoading();
    state = AsyncData(await _fetchPosts(reset: true, authorId: authorId));
  }

  Future<void> fetchNextPage() async {
    if (_isFetchingMore || !_hasNextPage || _authorId == null) return;

    _isFetchingMore = true;
    _currentPage++;

    try {
      final postService = ref.watch(postServiceProvider);
      final newPosts = await postService.getAllPosts(
        page: _currentPage,
        size: _pageSize,
        authorId: _authorId,
      );

      if (newPosts.length < _pageSize) {
        _hasNextPage = false;
      }

      final currentPosts = state.value ?? [];
      state = AsyncData([...currentPosts, ...newPosts]);
    } catch (e, st) {
      state = AsyncError(e, st); // Propagate error to UI
    } finally {
      _isFetchingMore = false;
    }
  }
}