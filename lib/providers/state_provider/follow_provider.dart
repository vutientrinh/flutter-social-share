import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/services/follow_service.dart';
import 'package:flutter_social_share/services/friend_service.dart';
import '../../services/api_client.dart';

final followServiceProvider = Provider<FollowService>((ref) {
  final dio = ref.watch(apiClientProvider);
  return FollowService(dio);
});
