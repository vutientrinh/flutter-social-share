import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/social/post_request.dart';
import 'package:flutter_social_share/providers/state_provider/notification_provider.dart';

import '../../model/social/notification.dart';

final notificationAsyncNotifierProvider =
    AsyncNotifierProvider<NotificationNotifier, List<AppNotification>>(
        NotificationNotifier.new);

class NotificationNotifier extends AsyncNotifier<List<AppNotification>> {
  @override
  Future<List<AppNotification>> build() async {
    final notificationService = ref.watch(notificationServiceProvider);
    final response = await notificationService.getAllNotification();
    return response;
  }

  Future<void> readAllNotification() async {
    final notificationService = ref.watch(notificationServiceProvider);
    await notificationService.readAllNotification();
    final updatedPosts = await notificationService.getAllNotification();
    state = AsyncData(updatedPosts);
  }

  Future<void> readNotification(String id) async {
    final notificationService = ref.watch(notificationServiceProvider);
    await notificationService.readNotification(id);
    final updatedPosts = await notificationService.getAllNotification();
    state = AsyncData(updatedPosts);
  }
}
