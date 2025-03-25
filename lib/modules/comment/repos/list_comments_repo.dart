import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_social_share/modules/comment/models/comment.dart';

const assetKey = 'assets/comments.json';

class ListCommentsRepo {
  final String postId;

  ListCommentsRepo(this.postId);

  Future<List<Comment>?> getComments() async {
    try {
      final json = await rootBundle.loadString(assetKey);
      final res = jsonDecode(json);

      List data = res['data'];

      return data.map((json) => Comment.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
