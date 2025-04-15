import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_social_share/services/auth_service.dart';

import '../../services/api_client.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final dio = ref.watch(apiClientProvider);
  return AuthService(dio);
});
