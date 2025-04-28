import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/services/social/uploadFile_service.dart';
import 'package:flutter_social_share/services/user_service.dart';


import '../../services/api_client.dart';

final userServiceProvider = Provider<UserService>((ref) {
  final dio = ref.watch(apiClientProvider);
  return UserService(dio);
});
