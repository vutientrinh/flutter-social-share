import 'dart:async';
import 'package:flutter_social_share/providers/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../../model/post.dart';
import '../../../services/post_service.dart';

class ListPostsRxDartBloc extends BlocBase {
  final _postsController = BehaviorSubject<List<Post>?>();

  Stream<List<Post>?> get postsStream => _postsController.stream;
  List<Post>? get postsValue => _postsController.value;

  Future<void> getPosts() async {
    try {
      final posts = await PostService().getAllPosts();
      _postsController.sink.add(posts);
    } catch (e) {
      _postsController.sink.addError('Failed to fetch posts');
    }
  }

  @override
  void dispose() {
    _postsController.close();
  }
}
