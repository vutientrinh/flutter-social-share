import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/services/notification_service.dart';

import '../../services/api_client.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final dio = ref.watch(apiClientProvider);
  return NotificationService(dio);
});
