import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/post_provider.dart';

import '../model/post.dart';
import '../screens/posts/postNotifier.dart';

final postProvider = StateNotifierProvider<PostNotifier, AsyncValue<List<Post>>>((ref) {
  final postService = ref.watch(postServiceProvider);
  return PostNotifier(postService);
});
