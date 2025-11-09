import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/i_chat_repository.dart';
import '../../data/repositories/chat_repository.dart';
import 'book_provider.dart';

/// Provider for Chat Repository
final chatRepositoryProvider = Provider<IChatRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return ChatRepository(firestore);
});

/// Provider for chat messages stream
final chatMessagesProvider = StreamProvider.family<List<Message>, String>((ref, chatId) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return chatRepository.getChatMessages(chatId);
});

/// State notifier for chat operations
class ChatNotifier extends StateNotifier<AsyncValue<void>> {
  final IChatRepository _chatRepository;

  ChatNotifier(this._chatRepository) : super(const AsyncValue.data(null));

  /// Send a message
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String senderEmail,
    required String text,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final message = Message(
        id: '',
        chatId: chatId,
        senderId: senderId,
        senderEmail: senderEmail,
        text: text,
        timestamp: DateTime.now(),
      );
      
      await _chatRepository.sendMessage(message);
    });
  }

  /// Generate chat ID for two users
  String generateChatId(String userId1, String userId2) {
    return _chatRepository.generateChatId(userId1, userId2);
  }
}

/// Provider for chat notifier
final chatNotifierProvider = StateNotifierProvider<ChatNotifier, AsyncValue<void>>((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatNotifier(chatRepository);
});