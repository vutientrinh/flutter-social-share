import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/services/friend_service.dart';
import 'package:flutter_social_share/services/liked_post_service.dart';
import '../../services/api_client.dart';

final likedPostServiceProvider = Provider<LikedPostService>((ref) {
  final dio = ref.watch(apiClientProvider);
  return LikedPostService(dio);
});
