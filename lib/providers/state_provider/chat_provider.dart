import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/services/social/chat_service.dart';


import '../../services/api_client.dart';

final chatServiceProvider = Provider<ChatService>((ref) {
  final dio = ref.watch(apiClientProvider);
  return ChatService(dio);
});
