import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../model/post.dart';
import '../../../services/post_service.dart';

class PostNotifier extends StateNotifier<AsyncValue<List<Post>>> {
  final PostService postService;

  PostNotifier(this.postService) : super(const AsyncLoading());

  Future<void> getAllPosts({
    int page = 1,
    int size = 10,
    String? authorId,
    String? keyword,
    int? type,
    String? topicName,
  }) async {
    try {
      state = const AsyncLoading();
      final posts = await postService.getAllPosts(
        page: page,
        size: size,
        authorId: authorId,
        keyword: keyword,
        type: type,
        topicName: topicName,
      );
      state = AsyncData(posts);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
