import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_social_share/modules/posts/models/post.dart';

const assetKey = 'assets/posts.json';

class ListPostsRepo {
  Future<List<Post>?> getPosts() async {
    try {
      final json = await rootBundle.loadString(assetKey);
      final res = jsonDecode(json);

      List data = res['data'];

      return data.map((json) => Post.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
