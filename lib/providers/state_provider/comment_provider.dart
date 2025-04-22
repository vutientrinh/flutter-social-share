import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/services/social/comment_service.dart';
import 'package:flutter_social_share/services/social/post_service.dart';


import '../../services/api_client.dart';

final commentServiceProvider = Provider<CommentService>((ref) {
  final dio = ref.watch(apiClientProvider);
  return CommentService(dio);
});
