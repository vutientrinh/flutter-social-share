import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/services/comment_service.dart';
import 'package:flutter_social_share/services/post_service.dart';


import '../../services/api_client.dart';

final commentServiceProvider = Provider<CommentService>((ref) {
  final dio = ref.watch(apiClientProvider);
  return CommentService(dio);
});
