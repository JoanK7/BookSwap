import '../entities/message.dart';

/// Chat repository interface
abstract class IChatRepository {
  /// Get messages for a specific chat
  Stream<List<Message>> getChatMessages(String chatId);
  
  /// Send a new message
  Future<Message> sendMessage(Message message);
  
  /// Get all chat IDs for a user
  Future<List<String>> getUserChatIds(String userId);
  
  /// Generate consistent chat ID for two users
  String generateChatId(String userId1, String userId2);
}