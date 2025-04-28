import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/services/social/friend_service.dart';
import '../../services/api_client.dart';

final friendServiceProvider = Provider<FriendService>((ref) {
  final dio = ref.watch(apiClientProvider);
  return FriendService(dio);
});
