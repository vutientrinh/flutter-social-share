import 'dart:async';

import 'package:flutter_social_share/modules/posts/models/post.dart';
import 'package:flutter_social_share/modules/posts/repos/list_posts_repo.dart';
import 'package:flutter_social_share/providers/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

class ListPostsRxDartBloc extends BlocBase {
  final _postsCtrl = BehaviorSubject<List<Post>?>();
  Stream<List<Post>?> get postsStream => _postsCtrl.stream;
  List<Post>? get postsValue => _postsCtrl.stream.value;

  Future<void> getPosts() async {
    try {
      final res = await ListPostsRepo().getPosts();
      if (res != null) {
        _postsCtrl.sink.add(res);
      }
    } catch (e) {
      _postsCtrl.sink.addError('Cannot fetch list posts right now!!!');
    }
  }

  @override
  void dispose() {
    _postsCtrl.close();
  }
}
