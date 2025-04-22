import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/services/social/post_service.dart';


import '../../services/api_client.dart';

final postServiceProvider = Provider<PostService>((ref) {
  final dio = ref.watch(apiClientProvider);
  return PostService(dio);
});
