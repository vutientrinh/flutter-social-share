import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/social/comment.dart';
import 'package:flutter_social_share/model/social/conversation.dart';
import 'package:flutter_social_share/providers/state_provider/chat_provider.dart';
import '../state_provider/comment_provider.dart';

final chatMessageAsyncNotifierProvider =
    AsyncNotifierProvider<ChatNotifier, List<Conversation>>(ChatNotifier.new);

class ChatNotifier extends AsyncNotifier<List<Conversation>> {
  @override
  Future<List<Conversation>> build() async {
    return [];
  }

  Future<List<dynamic>> getUnseenMessageCount() async {
    final chatService = ref.watch(chatServiceProvider);
    final count = await chatService.getUnSeenMessageCount();
    return count;
  }

  Future<void> getUnseenMessage(String fromUserId) async {
    final chatService = ref.watch(chatServiceProvider);
    final unSeenMessages = await chatService.getUnSeenMessage(fromUserId);
    state = AsyncData(unSeenMessages);
  }

  Future<void> getMessageBefore({String? messageId, String? convId}) async {
    final chatService = ref.watch(chatServiceProvider);
    final messageBefore = await chatService.getMessageBefore(
        messageId: messageId, convId: convId);
    state = AsyncData(messageBefore);
  }
}
